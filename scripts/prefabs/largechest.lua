-- Source modified from prefabs/treasurechest.lua

require "prefabutil"
local modname = KnownModIndex:GetModActualName("Large Chest fixed")
local chest_scale = GetModConfigData("CHEST_SCALE", modname)
local assets =
{
    Asset("ANIM", "anim/pandoras_chest_large.zip"),
    Asset("ANIM", "anim/pandoras_chest.zip"),
    Asset("ANIM", "anim/treasure_chest.zip"),
}

local function onopen(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("open")
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
    end
end

local function onclose(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("close")
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
    end
end

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("closed", false)
        if inst.components.container ~= nil then
            inst.components.container:DropEverything()
            inst.components.container:Close()
        end
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("closed", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/chest_craft")
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

local onburnt_old
local function onburnt_new(inst)
    inst.AnimState:SetBank("chest")
    inst.AnimState:SetBuild("treasure_chest")
    local animscale = 0.8 + ( chest_scale * 0.4 )
    inst.AnimState:SetScale(animscale, animscale)
    onburnt_old(inst)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("minotaurchest.png")

    inst:AddTag("structure")
    inst:AddTag("chest")
    if chest_scale == 1 then
      inst.AnimState:SetBank("pandoras_chest")
      inst.AnimState:SetBuild("pandoras_chest")
    elseif chest_scale == 2 then
      inst.AnimState:SetBank("pandoras_chest_large")
      inst.AnimState:SetBuild("pandoras_chest_large")
    else
      print("ERROR: Unsupported chest scale, anim build not set")
    end
    inst.AnimState:PlayAnimation("closed")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("largechest")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(2)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    AddHauntableDropItemOrWork(inst)

    inst:ListenForEvent("onbuilt", onbuilt)
    MakeSnowCovered(inst)
    MakeSmallBurnable(inst, nil, nil, true)
    MakeMediumPropagator(inst)
    onburnt_old = inst.components.burnable.onburnt
    inst.components.burnable:SetOnBurntFn(onburnt_new)
    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end
local placer
if chest_scale == 1 then
  placer = MakePlacer("common/largechest_placer", "pandoras_chest", "pandoras_chest", "closed")
elseif chest_scale == 2 then
  placer = MakePlacer("common/largechest_placer", "pandoras_chest_large", "pandoras_chest_large", "closed")
else
  print("ERROR: Unsupported chest scale, placer missing!")
end

return Prefab("common/largechest", fn, assets), placer
