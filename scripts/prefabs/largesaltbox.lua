require "prefabutil"
local scale = 1.5
local assets =
{
    Asset("ANIM", "anim/saltbox.zip"),
    Asset("ANIM", "anim/ui_largechest_5x5.zip"),
}

local prefabs =
{
    "collapse_small",
}

local function fn()
  local inst = Prefabs.saltbox.fn()
  inst.AnimState:SetScale(scale, scale)
  MakeSnowCoveredPristine(inst)
  inst.entity:SetPristine()
  if not TheWorld.ismastersim then
      return inst
  end
  inst.components.container:WidgetSetup("largesaltbox")
  return inst

end

return Prefab("largesaltbox", fn, assets),
        MakePlacer("largesaltbox_placer", "salt_box", "salt_box", "closed", nil, nil, nil, scale)
