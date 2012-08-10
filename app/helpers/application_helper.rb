module ApplicationHelper

  # Render a first found *.haml file in current theme directory. Order by array filenames. 
  def render_file(*filenames)
    filenames.flatten!
    i = 0
    while i < filenames.count && !File.exist?(Option.theme_full_dir + filenames[i] + '.html.haml')
      i = i + 1
    end
    if File.exist?(Option.theme_full_dir + filenames[i] + '.html.haml')
      render :file => Option.theme_full_dir + filenames[i]
    else
      # render system default or just error
    end
  end
  
  
  # Return array of entry_type name which has own page/readable
  def readable_entry_types
    BIDURI['entry_types'].select{|s| s['has_own_page'].nil? || s['has_own_page'] == true}.map{|m| m['entry_type']}
  end
  
  def is_readable_entry_type?
    params[:_entry_type_].present? && readable_entry_types.include?(params[:_entry_type_])
  end
  
  # Return true if currently showing single entry unless page (showing single entry where entry type other than page)
  def is_entry?
    is_controller_action?('entries', 'show') && is_readable_entry_type? && params[:_name_].present?
  end
  
  # Return true if currently showing single page (showing single entry where entry type is page)
  def is_page?
    is_entry? && params[:_entry_type_] == 'page'
  end
  
  # Return true if currently showing single post (showing single entry where entry type is post)
  def is_post?
    is_entry? && params[:_entry_type_] == 'post'
  end
  
  def is_not_page?
    params[:_entry_type_].blank? || !params[:_entry_type_] == 'page'
  end
  
  # Return true if currently showing home or root
  def is_home?
    is_controller_action?('home', 'index')
  end
  
  # Return true if currently showing list of entries (showing index where entry type other than page)
  def is_entries?
    is_controller_action?('entries', 'index') && is_readable_entry_type? && params[:_name_].blank? && is_not_page?
  end
  
  # Return true if currently showing list of entries (showing index where entry type other than page and has category specified)
  def is_categories?
    is_entries? && params[:_taxonomies_].present? && params[:_slug_].present? && is_not_page?
  end
  
  # Return true if currently showing list of entries (showing index where entry type other than page and has category specified)
  def is_tags?
    is_categories? && params[:_taxonomies_] == 'post_tag'
  end
  
  # Return filename of page template from a given page_template
  def page_template_filename(page_template)
    ('template_' + page_template)
  end
  
  # Return true if controller and action match the given controller and action string
  def is_controller_action?(controller, action)
    controller == controller_name && action == action_name
  end
  
  
  # Return space separated body class
  def body_class
    ssv = []
    ssv << 'home' if is_home?
    ssv << 'page' if is_page?
    ssv << 'entry' if is_entry?
    ssv << 'categories' if is_categories?
    ssv << 'tags' if is_tags?
    ssv.join(' ')
  end
  
  def title(page_title)
    content_for(:title) { page_title }
  end
  
  def component(content = nil, title = nil, footer = nil, id = nil)
    result = '<div class="component ' + (title.present? ? title.parameterize + '-component' : '') + '"'
    result << ' id="' + id + '" ' if id.present?
    result << '>'
    result << '<div class="component_title">' + title  + '</div>' if title.present?
    result << '<div class="component_content">' + content  + '</div>' if content.present?
    result << '<div class="component_footer">' + footer  + '</div>' if footer.present?
    result << '</div>'
    raw(result)
  end
  
  
  # Return array of available templates. 
  # Templates are defined from file which has prefix 'template_' e.g. 'template_about.html.haml'
  def available_page_templates
    dirname = Rails.root.join('app/' + Option.theme_full_dir)
    templates = []
    Dir.foreach(dirname) do |filename|
      if filename.length > 19 + 1 && filename.slice(0, 9) == 'template_' && filename.slice(-10, 10) == '.html.haml'
        templates << filename.slice(9, filename.length - 19)
      end
    end
    templates
  end

  
  def icon(ico, text = '', pos = 'left')
    if pos.eql? 'right'
      sanitize text + ' <i class="icon-' + ico + '"></i>'
    else
      sanitize '<i class="icon-' + ico + '"></i> ' + text
    end
  end

  
  require 'rexml/parsers/pullparser'
  # Return truncating in html raw format
  def truncate_html(text, len = 30, at_end = ' ...')
    p = REXML::Parsers::PullParser.new((text.presence || '<p> </p>').gsub(/[\r\n\t]/, ''))
    tags = []
    new_len = len
    results = ''
    while p.has_next? && new_len > 0
      p_e = p.pull
      case p_e.event_type
      when :start_element
        tags.push p_e[0]
        results << "<#{tags.last}#{attrs_to_s(p_e[1])}>"
      when :end_element
        results << "</#{tags.pop}>"
      when :text
        results << p_e[0][0..new_len]
        new_len -= p_e[0].length
      else
        results << "<!-- #{p_e.inspect} -->"
      end
    end

    if at_end && sanitize(text).length > len
      results << at_end
    end
    
    tags.reverse.each do |tag|
      results << "</#{tag}>"
    end
    raw(results)
  end
  
  private

    def attrs_to_s(attrs)
      if attrs.empty?
        ''
      else
        ' ' + attrs.to_a.map { |attr| %{#{attr[0]}="#{attr[1]}"} }.join(' ')
      end
    end

  
end
