# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: "Chicago" }, { name: "Copenhagen" }])
#   Mayor.create(name: "Emanuel", city: cities.first)

Role.delete_all
role_admin       = Role.create({name: "Admin",        description: "Full control of the web"})
role_editor      = Role.create({name: "Editor",       description: "Can manage the content of the web"})
role_contributor = Role.create({name: "Contributor",  description: "Can write entry or specific content of the web"})
role_subscriber  = Role.create({name: "Subscriber",   description: "Can read the content of the web"})


admin       = User.create({email: "admin@biduribulan.com", password: "test123", password_confirmation: "test123", role_ids: role_admin.id})
editor      = User.create({email: "editor@biduribulan.com", password: "test123", password_confirmation: "test123", role_ids: role_editor.id})
contributor = User.create({email: "contributor@biduribulan.com", password: "test123", password_confirmation: "test123", role_ids: role_contributor.id})
subscriber  = User.create({email: "subscriber@biduribulan.com", password: "test123", password_confirmation: "test123", role_ids: role_subscriber.id})

# Option's seed must placed before entry's seed
Option.create({key: "web_info", value: YAML.dump({name: "BiduriBulan", tagline: "CMS for Rails", description: "Content Management System for Ruby on Rails", keyword: ["cms", "cms rails", "content management system", "starqle"]})})
Option.create({key: "theme", value: "biduribulan"})
Option.create({key: "system_entry_type", value: YAML.dump([{name: "entry"}, {name: "page"}, {name: "media"}])})
Option.create({key: "custom_entry_type", value: YAML.dump([])})


Entry.read_entry_type
hello_world = Entry.create({entry_id: nil, title: "Hello, world",   comment_status: 'open', content: "<p>\r\n\tHello world from BiduriBulan.</p>\r\n",     entry_type: "post", status: "publish", user_id: admin.id})
first_post =  Entry.create({entry_id: nil, title: "First Post",     comment_status: 'open', content: "<p>\r\n\tThis is your first post example.</p>\r\n<p>\r\n\tLorem ipsum dolor sit amet, consectetur adipiscing elit. Proin dapibus, ligula nec hendrerit malesuada, libero lacus tincidunt lorem, sed rhoncus eros lorem egestas nisi. Nulla facilisi. Vivamus sagittis nibh id nunc cursus ornare. Proin malesuada, neque non auctor vulputate, lorem leo venenatis diam, eu elementum leo urna a ligula. Praesent at nisi odio. Vivamus at est ac lectus aliquam viverra id a metus. Duis turpis quam, porttitor quis facilisis eget, blandit at diam. Mauris scelerisque dignissim dictum. Curabitur dui diam, tincidunt a commodo imperdiet, euismod vel turpis. Nulla facilisi. Vestibulum aliquam dui eu nibh mollis pretium. Integer ac metus ut nisi gravida convallis non eu tellus. Nunc velit justo, porttitor sit amet eleifend eget, ornare eu mi. Aliquam auctor dolor sit amet ante placerat congue. Donec et pellentesque arcu.</p>\r\n<p>\r\n\tMorbi fringilla ultrices lacus ut convallis. Nam pellentesque, arcu non consequat volutpat, leo lacus convallis metus, non mattis nunc lorem id erat. Ut nunc nisl, egestas vel vehicula ac, congue in mauris. Ut elit velit, pellentesque at volutpat sit amet, accumsan eu metus. Vestibulum egestas aliquam pharetra. In vulputate commodo mauris at tristique. Nunc faucibus posuere quam, et scelerisque erat interdum nec. Proin ut ligula purus. Aliquam non turpis at dui vulputate euismod. In porta felis in est auctor facilisis. Vestibulum pharetra volutpat commodo. Nunc placerat, leo a commodo porta, dolor justo facilisis risus, nec tincidunt eros dolor in libero. Suspendisse potenti. Quisque at neque eu erat pharetra sagittis vitae id lacus.</p>\r\n",   entry_type: "post", status: "publish", user_id: editor.id})
Entry.create({entry_id: nil, title: "About",          content: "<p>LDut elit velit, pellentesque at volutpat sit amet, acmsan.</p>",   entry_type: "page", status: "publish", user_id: admin.id})
parent_entry = Entry.create({entry_id: nil, title: "Sample Page",  content: "<p>Fusce rhoncus augue nec urna ultrices ac elementt ultrices.</p>",  entry_type: "page", status: "publish", user_id: editor.id})
Entry.create({entry_id: parent_entry.id,    title: "Child Page",   content: "<p>Mauris rhoncus mollis lacinia. Proin dignissim lacus dos.</p>",    entry_type: "page", status: "publish", user_id: admin.id})

Entry.rebuild!


Comment.create(content: 'This is your first comment example', user_id: admin.id, entry_id: first_post.id)
Comment.rebuild!