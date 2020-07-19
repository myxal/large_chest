local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local RECIPETABS = GLOBAL.RECIPETABS
local Ingredient = GLOBAL.Ingredient
local FOODTYPE = GLOBAL.FOODTYPE
local TECH = GLOBAL.TECH
local TUNING = GLOBAL.TUNING
local TheSim = GLOBAL.TheSim
local Vector3 = GLOBAL.Vector3
local ACTIONS = GLOBAL.ACTIONS
local TheNet = GLOBAL.TheNet

PrefabFiles =
{
    "largechest",
    "largeicebox",
    "largesaltbox"
}

Assets =
{
    Asset("ATLAS", "images/inventoryimages/largechest.xml"),
    Asset("IMAGE", "images/inventoryimages/largechest.tex"),
    Asset("ANIM", "anim/ui_largechest_5x5.zip"),
}

local chest_scale = GetModConfigData("CHEST_SCALE")
local recipe_difficulty = GetModConfigData("OPT_DIFFICULTY")
local containers = require "containers"
local containers_widgetsetup_base = containers.widgetsetup

local params = {}
local function embiggen(self)
  container = self or {}
  container.widget = {
      slotpos = {},
      animbank = "ui_largechest_5x5",
      animbuild = "ui_largechest_5x5",
      pos = GLOBAL.Vector3(0, 200, 0),
      side_align_tip = 160,
  }
  for y = 3, -1, -1 do
      for x = -1, 3 do
          table.insert(container.widget.slotpos, GLOBAL.Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
      end
  end
  return container
end

local function makeChest()
    local container =
    {
        widget =
        {
            slotpos = {},
            animbank = "ui_largechest_5x5",
            animbuild = "ui_largechest_5x5",
            pos = GLOBAL.Vector3(0, 200, 0),
            side_align_tip = 160,
        },
        type = "chest",
    }

    for y = 3, -1, -1 do
        for x = -1, 3 do
            table.insert(container.widget.slotpos, GLOBAL.Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
        end
    end

    return container
end

function containers.widgetsetup(container, prefab, data, ...)
    local t = params[prefab or container.inst.prefab]
    if t ~= nil then
        for k, v in pairs(t) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
    else
        containers_widgetsetup_base(container, prefab, data, ...)
    end
end

if GetModConfigData("ICEBOX_ENABLE") then
  -- regular recipe: 2 gold, 1 gears, 1 cutstone
  params.largeicebox = makeChest()
  function params.largeicebox.itemtestfn(container, item, slot)
    if item:HasTag("icebox_valid") then
        return true
    end

    --Perishable
    if not (item:HasTag("fresh") or item:HasTag("stale") or item:HasTag("spoiled")) then
        return false
    end

  if item:HasTag("smallcreature") then
    return false
  end

    --Edible
    for k, v in pairs(FOODTYPE) do
        if item:HasTag("edible_"..v) then
            return true
        end
    end

    return false
  end
  local ingredients =
    (recipe_difficulty == 2) and { Ingredient("goldnugget", 8), Ingredient("gears", 3), Ingredient("boards", 4) } or
    (recipe_difficulty == 1) and { Ingredient("goldnugget", 6), Ingredient("gears", 3), Ingredient("boards", 3) } or
    (recipe_difficulty == 0) and { Ingredient("goldnugget", 4), Ingredient("gears", 2), Ingredient("boards", 2) } or
    print "ERROR: unsupported recipe difficulty" and nil
  local rec = AddRecipe("largeicebox", ingredients, RECIPETABS.FARM, TECH.SCIENCE_TWO, "largeicebox_placer",
      2.5, nil, nil, nil, nil, "icebox.tex")
  if GLOBAL.AllRecipes.icebox ~= nil then
    rec.sortkey = GLOBAL.AllRecipes.icebox.sortkey + 0.1
  end
  STRINGS.NAMES.LARGEICEBOX = "Large Icebox"
  STRINGS.RECIPE_DESC.LARGEICEBOX = "A gigantic icebox."
  STRINGS.CHARACTERS.GENERIC.DESCRIBE.LARGEICEBOX = "I have harnessed the power of cold!"
end

if GetModConfigData("CHEST_ENABLE") then
  params.largechest = makeChest()
  -- regular recipe: 3 boards
  local ingredients =
    (recipe_difficulty == 2) and { Ingredient("boards", 8), Ingredient("goldnugget", 4) } or
    (recipe_difficulty == 1) and { Ingredient("boards", 8), Ingredient("goldnugget", 2) } or
    (recipe_difficulty == 0) and { Ingredient("boards", 6) } or
    print "ERROR: unsupported recipe difficulty" and nil
  local rec = AddRecipe(
      "largechest",
      ingredients,
      RECIPETABS.TOWN,
      TECH.SCIENCE_TWO,
      "largechest_placer",
      (chest_scale * 1.2 + 0.4),
      nil, nil, nil, "images/inventoryimages/largechest.xml")
  if GLOBAL.AllRecipes.treasurechest ~= nil then
    rec.sortkey = GLOBAL.AllRecipes.treasurechest.sortkey + 0.1
  end
  STRINGS.NAMES.LARGECHEST = "Large Chest"
  STRINGS.RECIPE_DESC.LARGECHEST = "A large chest to put more stuff in"
  STRINGS.CHARACTERS.GENERIC.DESCRIBE.LARGECHEST = "Looks so fancy!"
end

if GetModConfigData("SALTBOX_ENABLE") then
  -- regular recipe: 10 saltrock, 1 bluegem, 1 cutstone
  params.largesaltbox = makeChest()
  -- params.largesaltbox = GLOBAL.deepcopy(containers.saltbox) -- this doesn't work
  function params.largesaltbox.itemtestfn(container, item, slot)
  	return ((item:HasTag("fresh") or item:HasTag("stale") or item:HasTag("spoiled"))
  		and item:HasTag("cookable")
  		and not item:HasTag("deployable")
  		and not item:HasTag("smallcreature")
  		and item.replica.health == nil)
  		or item:HasTag("saltbox_valid")
  end
  local ingredients =
    (recipe_difficulty == 2) and { Ingredient("saltrock", 28), Ingredient("cutstone", 4), Ingredient("bluegem",4) } or
    (recipe_difficulty == 1) and { Ingredient("saltrock", 24), Ingredient("cutstone", 3), Ingredient("bluegem",3) } or
    (recipe_difficulty == 0) and { Ingredient("saltrock", 16), Ingredient("cutstone", 2), Ingredient("bluegem",2) } or
    print "ERROR: unsupported recipe difficulty" and nil
  local rec = AddRecipe(
      "largesaltbox",
      ingredients,
      RECIPETABS.FARM,
      TECH.SCIENCE_TWO,
      "largesaltbox_placer",
      (chest_scale * 1.2 + 0.4),
      nil, nil, nil, nil, "saltbox.tex")
  if GLOBAL.AllRecipes.saltbox ~= nil then
    rec.sortkey = GLOBAL.AllRecipes.saltbox.sortkey + 0.1
  end
  STRINGS.NAMES.LARGESALTBOX = "Large Saltbox"
  STRINGS.RECIPE_DESC.LARGESALTBOX = "Even saltier than the previous one"
  STRINGS.CHARACTERS.GENERIC.DESCRIBE.LARGESALTBOX = "It's worth more than its weight in gold!"
end


for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end
