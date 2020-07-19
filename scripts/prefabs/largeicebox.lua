require "prefabutil"
local scale = 1.5
local assets =
{
    Asset("ANIM", "anim/ice_box.zip"),
}

local function fn()
  local inst = Prefabs.icebox.fn()
  inst.AnimState:SetScale(scale, scale)  
  if not TheWorld.ismastersim then
      return inst
  end
  inst.components.container:WidgetSetup("largeicebox")
  return inst

end

return Prefab("largeicebox", fn, assets),
        MakePlacer("largeicebox_placer", "icebox", "ice_box", "closed", nil, nil, nil, scale)
