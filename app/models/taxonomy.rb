class Taxonomy < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged
  
  acts_as_nested_set :parent_column => :taxonomy_id
  accepts_nested_attributes_for :children, :allow_destroy => :true,
    :reject_if => proc{|attrs| attrs['name'].blank?}
  attr_protected :lft, :rgt
  
  validates :name, :presence => true
  validates :taxonomy_type, :presence => true
  
  has_many :taxonomy_assignments, :dependent => :destroy
  has_many :entries, :through => :taxonomy_assignments
  accepts_nested_attributes_for :taxonomy_assignments, :allow_destroy => :true,
    :reject_if => proc{|attrs| attrs['entry_id'].blank?}
  
  # available taxonomy type: category, link_category, entry_tag, menu_group
     
  def to_s
    self.name
  end

  # Return true if the taxonomy type equal the given value
  def is?(taxonomy_type)
    self.taxonomy_type == taxonomy_type
  end
     
  # Return valid entry url. See config/routes.rb or run 'rake routes' to see the valid url
  def url
    "/#{Taxonomy.get(taxonomy_type)['entry_type']}/#{taxonomy_type}/#{slug}"
  end                     
  
  # Return taxonomy_type configuration object defined in yml
  def self.get(taxonomy_type)
    BIDURI['taxonomies'][taxonomy_type]
  end
  
  # Return array of taxonomies sorted by tree structure
  def self.get_tree(taxonomy_type, status=nil)
    taxonomies_sorted = []
    curr_level = 0
    leveling = [99]
    depth = 0
    Taxonomy.order(:lft).select{|taxonomy| taxonomy.taxonomy_type == taxonomy_type}.each do |t|
      leveling.pop if t.depth <= curr_level
      leveling.pop if t.depth < curr_level
      curr_level = t.depth
      leveling.push(sprintf '%02d%003d', (t.menu_order.presence || 99), t.id)
      leveling_2 = Array.new(leveling)
      depth = leveling_2.size if leveling_2.size > depth
      taxonomies_sorted << {:taxonomy => t, :sort_str => leveling_2  }
    end
    
    taxonomies_sorted.sort{|a, b| sort_int(a, depth) <=> sort_int(b, depth)}.collect{|c| c[:taxonomy]}
  end
  
  def delete_node_keep_sub_nodes
    if self.child?
      self.move_children_to_immediate_parent
    else
      self.move_children_to_root
    end
  end

  def move_children_to_immediate_parent
    node_immediate_children = self.children
    node_immediate_parent = self.parent
    node_immediate_children.each do |child|
      child.move_to_child_of(node_immediate_parent)
      node_immediate_parent.reload
    end
  end

  def move_children_to_root
    node_immediate_children = self.children
    node_immediate_children.each do |child|
      child.move_to_root
      child.reload
    end
  end

  
private
  
  def self.sort_int(node_obj, depth)
     ('1'+node_obj[:sort_str].join + ('00000' * (depth - node_obj[:taxonomy].depth))).to_i
  end
  
end
