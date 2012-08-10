class Entry < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, :use => :slugged, :slug_column => :name
  
  acts_as_nested_set :parent_column => :entry_id
  accepts_nested_attributes_for :children, :allow_destroy => :true,
    :reject_if => proc { |attrs| attrs['title'].blank?}
  attr_protected :lft, :rgt
  
  validates :title, :presence => true
  validates :name, :presence => true, 
                   :uniqueness => true
  validates :entry_type, :presence => true
                   
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>", :square128 => "128x128#", :article_fit => "540x300#", :featured_fit => "700x300#" }
  
  belongs_to :user
  has_many :comments, :dependent => :destroy
  has_many :taxonomy_assignments, :dependent => :destroy
  has_many :taxonomies, :through => :taxonomy_assignments
  
  has_many :entry_metas
  accepts_nested_attributes_for :entry_metas, :allow_destroy => :true,
    :reject_if => proc { |attrs| attrs['key'].blank? || attrs['value'].blank?}
  

  def to_s
    self.title    
  end

  # Return valid entry url. See config/routes.rb or run 'rake routes' to see the valid url
  def url
    "/#{self.entry_type}/#{self.name}"
  end
  
  # Return true if the entry type equal the given value
  def is?(entry_type)
    self.entry_type == entry_type.to_s
  end
  
  # Return page template of the entry.
  # The entry type must be 'page'
  # Return nil, if nil or empty string
  def page_template
    entry_metas.find_all_by_key('page_template').collect(&:value).join("").presence || nil
  end
  
  # Return true if comment_status of the entry is open
  def allow_comment?
    comment_status == 'open'
  end
  
  # Return custom field value given custom field name, field name, and field type(optional)
  def custom_field_value(custom_field_name, field_name, field_type = 'Text Field Tag')
    entry_meta = self.entry_metas.find_by_key(custom_field_name.parameterize.underscore + '_' + field_name.parameterize.underscore)
    if entry_meta.present?
      case field_type.parameterize.underscore
      when 'datetime_select_tag'
        Time.parse(entry_meta.value)
      when 'date_select_tag'
        Date.parse(entry_meta.value)
      else
        entry_meta.value
      end
    else
      ''
    end
  end
  
  # Return value in date time format
  # Use this method if we sure the field type is date or date time
  def custom_field_date_value(custom_field_name, field_name)
    custom_field_value(custom_field_name, field_name, 'Datetime select tag')
  end
  
  # Return start date value in date time format
  # Use this method if we sure there exist custom field with field name start date
  def start_date(custom_field_name = 'Events Custom Field')
    custom_field_date_value(custom_field_name, 'Start Date')
  end
  
  # Return end date value in date time format
  # Use this method if we sure there exist custom field with field name start date
  def end_date(custom_field_name = 'Events Custom Field')
    custom_field_date_value(custom_field_name, 'End Date')
  end
  
  
  # Return array of taxonomy_type from specified entry_type.
  # Empty array is return if entry type doesn't have any taxonomy
  def self.taxonomy_types(entry_type)
    BIDURI['entry_type_associations'][entry_type]['taxonomies'].presence || []
  end
  
  # Return entry type configuration object defined in yml
  def self.get_object(entry_type)
    BIDURI['entry_type_associations'][entry_type]
  end

  def self.read_entry_type
    yaml = YAML::load(File.read(Rails.root.join(Option.entry_types_yaml_path)))
    
    yaml['taxonomies'] = {}
    yaml['entry_type_associations'] = {}
    yaml['entry_types'].each do |p|
      yaml['entry_type_associations'][p['entry_type']] = {}
      if p.key?('taxonomies')
        yaml['entry_type_associations'][p['entry_type']]['taxonomies'] = []
        p['taxonomies'].each do |t|
          yaml['taxonomies'][t['taxonomy_type']] =   {
                                              'entry_type' => p['entry_type'],
                                              'entry_type_name' => p['name'], 
                                              'name' => t['name'], 
                                              'hierarchical' => t['hierarchical'].presence || false, 
                                              'multiple' => t['multiple'].presence || false
                                            }
          yaml['entry_type_associations'][p['entry_type']]['taxonomies'] << t['taxonomy_type']
        end
      end
      
      yaml['entry_type_associations'][p['entry_type']]['name'] = p['name']
      yaml['entry_type_associations'][p['entry_type']]['has_own_page'] = p['has_own_page'].presence || true
    end
    
    # BIDURI is a constant, we cannot change it's value, but we can change it's content
    BIDURI.replace(yaml)
    
    BIDURI['info'] = YAML.load(Option.find_by_key('web_info').value)


    # Define class method by entry_type
    if BIDURI['entry_types'].present?
      BIDURI['entry_types'].map{|et| et['entry_type'].pluralize}.each do |m|
        # Yes, smarter key
        unless self.respond_to? "all_#{m}"
          self.class.send(:define_method, "all_#{m}") do
            Entry.find_all_by_status_and_entry_type('publish', m.to_s.singularize, :order => "created_at DESC")
          end
        end
      end
    end
  end

  # call immeditely
  self.read_entry_type
  
  # Return array of entries sorted by tree structure
  def self.get_tree(entry_type, status=nil)
    entries_sorted = []
    curr_level = 0
    level = 0
    leveling = [99]
    depth = 0
    Entry.order(:lft).select{|entry| entry.entry_type == entry_type}.each do |t|
      level = t.depth
      leveling.pop if level <= curr_level
      leveling.pop if level < curr_level
      curr_level = level
      leveling.push(sprintf '%02d%003d', (t.menu_order.presence || 99), t.id)
      leveling_2 = Array.new(leveling)
      depth = leveling_2.size if leveling_2.size > depth
      entries_sorted << {:entry => t, :sort_str => leveling_2  }
    end
    
    entries_sorted.sort{|a, b| sort_int(a, depth) <=> sort_int(b, depth)}.collect{|c| c[:entry]}
  end

  
private
  
  def self.sort_int(node_obj, depth)
     ('1'+node_obj[:sort_str].join + ('00000' * (depth - node_obj[:entry].depth))).to_i
  end
  
end

