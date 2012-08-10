THEME = ActiveRecord::Base.connection.table_exists?('options') ? (Option.find_by_key('theme').try(:value).presence || 'biduribulan')  : 'biduribulan'
THEMES_DIRECTORIES = 'app/themes/'
ENTRY_TYPES_YAML = 'entry_types.yml'

CUSTOM_TAGS = %w(TextFieldTag TextAreaTag CheckBoxTag RadioButtonTag SelectTag DateSelectTag DatetimeSelectTag)

BIDURI = {}
