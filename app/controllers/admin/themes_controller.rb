class Admin::ThemesController < Admin::BaseController
  #load_and_authorize_resource
  
  def index
    dirname = THEMES_DIRECTORIES
    @themes = Array.new
    Dir.foreach(dirname) do |filename|
      if File.directory?(dirname + filename) && filename != '.'  && filename != '..'
        dirname_new = dirname + filename + '/config/'
        Dir.foreach(dirname_new) do |filename_new|
          if filename_new == 'theme.yml'
            yaml = YAML.load(File.read(dirname_new + filename_new))
            yaml.keys.each{|k| yaml[k.to_sym] = yaml[k]; yaml.delete(k)}
            yaml[:dirname] = filename
            @themes << yaml
          end
        end
      end
    end
  end
  
  def activate
    option = Option.find_by_key('theme')
    option.value = params[:theme_id]
    
    respond_to do |format|
      if option.save
        Option.reload_constant
        format.html { redirect_to admin_themes_url, notice: 'Theme was successfully activated.' }
      else
        format.html { redirect_to admin_themes_url, alert: 'Failed activating theme.' }
      end
    end
  end
end
