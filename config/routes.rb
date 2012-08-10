# Class for constrain definitions so that only /entry/entryname or /page/entryname that pass the route
class EntriesConstraint
  class Option < ActiveRecord::Base

    # DUPLICATE SOME CLASS METHOD
    def self.theme_dir
      THEME + '/'
    end

    def self.theme_full_dir
      THEMES_DIRECTORIES + Option.theme_dir
    end

    def self.config_dir
      Option.theme_full_dir + 'config/'
    end

    def self.entry_types_yaml_path
      Option.config_dir + ENTRY_TYPES_YAML
    end

  end
    
  def initialize
    @yaml = YAML::load(File.read(Rails.root.join(Option.entry_types_yaml_path)))
    
    @yaml['taxonomies'] = {}
    @yaml['entry_type_associations'] = {}
    @yaml['entry_types'].each do |p|
      @yaml['entry_type_associations'][p['entry_type']] = {}
      if p.key?('taxonomies')
        @yaml['entry_type_associations'][p['entry_type']]['taxonomies'] = []
        p['taxonomies'].each do |t|
          @yaml['taxonomies'][t['taxonomy_type']] =   {
                                              'entry_type' => p['entry_type'],
                                              'entry_type_name' => p['name'], 
                                              'name' => t['name'], 
                                              'hierarchical' => t['hierarchical'].presence || false, 
                                              'multiple' => t['multiple'].presence || false
                                            }
          @yaml['entry_type_associations'][p['entry_type']]['taxonomies'] << t['taxonomy_type']
        end
      end
      
      @yaml['entry_type_associations'][p['entry_type']]['name'] = p['name']
      @yaml['entry_type_associations'][p['entry_type']]['has_own_page'] = p['has_own_page'].presence || true
    end

    @entry_types = @yaml['entry_types'].select{|s| s['has_own_page'].nil? || s['has_own_page'] == true }.map{|m| m['entry_type']}
  rescue
  end
 
  def matches?(params)
    @entry_types.include?(params[:_entry_type_])
  end
end

# Class for constrain definitions so that only /entry/entryname or /page/entryname that pass the route
class TaxonomiesConstraint
  class Option < ActiveRecord::Base
    # DUPLICATE SOME CLASS METHOD
    def self.theme_dir
      THEME + '/'
    end

    def self.theme_full_dir
      THEMES_DIRECTORIES + Option.theme_dir
    end

    def self.config_dir
      Option.theme_full_dir + 'config/'
    end

    def self.entry_types_yaml_path
      Option.config_dir + ENTRY_TYPES_YAML
    end
  end
    
  def initialize
    @yaml = YAML::load(File.read(Rails.root.join(Option.entry_types_yaml_path)))
    
    @yaml['taxonomies'] = {}
    @yaml['entry_type_associations'] = {}
    @yaml['entry_types'].each do |p|
      @yaml['entry_type_associations'][p['entry_type']] = {}
      if p.key?('taxonomies')
        @yaml['entry_type_associations'][p['entry_type']]['taxonomies'] = []
        p['taxonomies'].each do |t|
          @yaml['taxonomies'][t['taxonomy_type']] =   {
                                              'entry_type' => p['entry_type'],
                                              'entry_type_name' => p['name'], 
                                              'name' => t['name'], 
                                              'hierarchical' => t['hierarchical'].presence || false, 
                                              'multiple' => t['multiple'].presence || false
                                            }
          @yaml['entry_type_associations'][p['entry_type']]['taxonomies'] << t['taxonomy_type']
        end
      end
      
      @yaml['entry_type_associations'][p['entry_type']]['name'] = p['name']
      @yaml['entry_type_associations'][p['entry_type']]['has_own_page'] = p['has_own_page'].presence || true
    end
    
    @entry_types = @yaml['entry_types'].select{|s| s['has_own_page'].nil? || s['has_own_page'] == true }.map{|m| m['entry_type']}
  rescue
  end
 
  def matches?(params)
    @entry_types.include?(params[:_entry_type_]) && @yaml['entry_type_associations'][params[:_entry_type_]].present? && @yaml['entry_type_associations'][params[:_entry_type_]]['taxonomies'].include?(params[:_taxonomies_])
  end
end


Biduribulan::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  get "themes/index"

  namespace :admin do
    match '/' => 'home#index', :via => 'get', :as => 'home'
    devise_for :users, :controllers => { :registrations => 'registrations' }, :path_prefix => 'd'

    resources :authentications
    resources :entries do 
      get 'new_child', :on => :member
      post 'create_child', :on => :member
    end
    resources :options
    resources :roles
    resources :taxonomies
    resources :themes do
      get 'activate'
    end
    resources :users
  end

  match '/auth/:provider/callback' => 'authentications#create'
  devise_for :users, :controllers => { :registrations => 'registrations' }
  
  resources :authentications
  resources :entries, :only => [:index, :show] do
    resources :comments
  end
  match '/:_entry_type_/:_name_' => 'entries#show', :via => 'get', :constraints => EntriesConstraint.new
  match '/:_entry_type_/:_taxonomies_/:_slug_' => 'entries#index', :via => 'get', :constraints => TaxonomiesConstraint.new

  root :to => 'home#index', :as => 'home'
  root :to => 'home#index'
end
