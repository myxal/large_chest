name = "Large Chest"
description = "Craft the Large Chest, or the Large Icebox. Or both!"
author = "lishid"
version = "1.1.1"

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
}
