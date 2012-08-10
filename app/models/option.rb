class Option < ActiveRecord::Base  
  validates :key, :presence => true
  validates :value, :presence => true
  
  # reloading Option constant. Very useful especially after activating themes
  def self.reload_constant
    THEME.replace(Option.find_by_key('theme').value)
  end
  
  # Get value from Option in deserialize format
  def self.value(key, serialize = false)
    value = Option.find_by_key(key).value
    serialize ? YAML.load(value) : value
  end
  
  # Get value from Option in deserialize format
  def self.deserialize_value(key)
    YAML.load(Option.find_by_key(key).value)
  end

  def self.theme_dir
    THEME + '/'
  end

  def self.stylesheet_dir
    Option.theme_dir + 'stylesheets/'
  end

  def self.theme_full_dir
    THEMES_DIRECTORIES + Option.theme_dir
  end

  def self.stylesheet_full_dir
    THEMES_DIRECTORIES + Option.stylesheet_dir
  end

  def self.config_dir
    Option.theme_full_dir + 'config/'
  end

  def self.entry_types_yaml_path
    Option.config_dir + ENTRY_TYPES_YAML
  end


end
