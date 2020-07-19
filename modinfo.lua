name = "Large Chest fixed"
author = "myxal"
version = "2.0"
description = "v"..version.."\nAdds larger variants of Chest, Icebox, Saltbox. Recipes can be individually disabled in Configuration."

folder_name = folder_name or "large chest"
if not folder_name:find("workshop-") then
    name = "(DEV)"..name
end

forumthread = ""

api_version = 10
dst_compatible = true

client_only_mod = false
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

priority = 362237
server_filter_tags = {"largechest"}

configuration_options =
{
	{
		name = "OPT_DIFFICULTY",
		label = "Recipe difficulty",
		options =	{
						{description = "Easy", data = 0, hover = "Chest: Boards(6), Icebox: Gold Nugget(4), Gears(2), Boards(2)"},
						{description = "Normal", data = 1, hover = "Chest: Boards(8), Gold Nugget(2), Icebox: Gold Nugget(6), Gears(3), Boards(3)"},
						{description = "Hard", data = 2, hover = "Chest: Boards(8), Gold Nugget(4), Icebox: Gold Nugget(8), Gears(3), Boards(4)"},
					},
		default = 1,
	},
	{
		name = "ICEBOX_ENABLE",
		label = "Enable Icebox recipe",
		options = {
			{description = "No", data = false},
			{description = "Yes", data = true}
		},
		default = true
	},
	{
		name = "CHEST_ENABLE",
		label = "Enable Chest recipe",
		options = {
			{description = "No", data = false},
			{description = "Yes", data = true}
		},
		default = true
	},
	{
		name = "SALTBOX_ENABLE",
		label = "Enable Saltbox recipe",
		options = {
			{description = "No", data = false},
			{description = "Yes", data = true}
		},
		default = true
	},
	{
		name = "CHEST_SCALE",
		label = "Visual size of chest",
		-- hover = "How large should the large chest appear in the world",
		options = {
			{description = "Small", data = 1},
			{description = "Large", data = 2}
		},
		default = 2,
	}
}
