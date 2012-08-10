module EntriesHelper
  
  # Return all entries which entry_type = page as an array
  def link_by_title(title)
    link = Entry.find_by_title(title)
    if link.present?
      link_to link.title, link.content
    else
      ''
    end
  end
  
  # Return menu page
  def menu_tree_page(options = {})
    case options
    when Hash
      div_wrapper = options[:wrapper]
      if div_wrapper.eql?(false)
        raw(construct_menu(Entry.get_tree('page', 'publish'), options))
      else
        raw('<div class="menu page_menu">' + construct_menu(Entry.get_tree('page', 'publish'), options) + '</div>')
      end
    else
      raw('<div class="menu page_menu">' + construct_menu(Entry.get_tree('page', 'publish'), options) + '</div>')
    end
  end  
  
  # Return html fos singgle menu item
  def menu_item(node, options = {})  
    result = ''
    link_label = (node.rgt - node.lft > 1) ? icon('caret-down', node.to_s, 'right') : node.to_s

    result << '<div class="node">' unless options[:li_wrapper].eql?(false)
    if node.class.name == 'Taxonomy'
      result << (link_to link_label, (node.entries.find_by_entry_type('link').present? ? node.entries.find_by_entry_type('link').content : '#')) 
    else
      result << (link_to link_label, '/page/' + node.name)
    end
    result << '</div>' unless options[:li_wrapper].eql?(false)
    result
  end
  
  # Constructing menu from nested_set format and return the constructed html
  def construct_menu(nodes, options = {}, current = nil)
    ul_class = ''

    case options
    when Hash
      ul_class = options[:ul_class]
    end

    if ul_class.present?
      result = '<ul class="' + ul_class + '">'
    else
      result = '<ul>'
    end
    
    if options.present? && options[:home].present? && options[:home] == true
      unless options[:li_wrapper].eql?(false)
        result << '<li><div class="node"><a href="/" title="Home">Home</a></div></li>'
      else
        result << '<li><a href="/" title="Home">Home</a></li>'
      end
    end
    
    parents = []
    prev_node = nil
    nodes.each do |node| 
      if prev_node.present?
        if node.parent_id == prev_node.id #children
          result << '<ul class="children">'
        elsif node.parent_id == parents.pop #siblings
          result << '</li>'
        else
          while parents.length > 0 && node.parent_id != parents.pop #drop
            result << '</li></ul></li>'
          end #parents
          result << '</li></ul></li>'
        end
        parents.push(node.parent_id)
      else
      end
        
      result << '<li class="' + 
                (node.rgt - node.lft > 1 ? 'has_children ' : '') + 
                'level_'+node.depth.to_s + '">'

      result << menu_item(node, options)
      prev_node = node
    end
    for i in 0..(parents.length - 1)
      result << '</li></ul>'
    end
    result << '</li>'
    result << '</ul>'
    result
  end
  
  
  def menu_component(menu_title)
    raw('<div class="menu menu_component" id="'+menu_title.parameterize.underscore+'">' + construct_menu(Taxonomy.get_tree('menu').select{|s| s.entries.find_all_by_entry_type('menu').collect(&:title).include? menu_title}) + '</div>')
  end
  
  
end
