ESX = nil
local Objekti = {}
local YouWork = false
local ObjBr = 1
local TakeBrick = false
local LeaveTheBrick = false
local LastBrick = nil
local FirtBrick = nil
local OstaviKoord = nil
local prop = nil
local RandomJob = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	CheckJob()
end)
--------------------------------------------------------------------------------
-- Do not touch
--------------------------------------------------------------------------------
local isInService = false
local hasAlreadyEnteredMarker = false
local lastZone                = nil

local plaquevehicule = ""
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
--------------------------------------------------------------------------------
function CheckJob()
	ESX.PlayerData = ESX.GetPlayerData()
end


--------------------------------------------------------------------------------
-- Menu
--------------------------------------------------------------------------------
function StartJob()
	ObjBr = 1
	YouWork = true
	TriggerEvent("dpemotes:Radim", true)
	Objekti = {}
	TakeBrick = true
	RandomJob = math.random(1,2)
	if RandomJob == 1 then
		OstaviKoord = vector3(1373.4049072266, -781.62121582031, 66.773597717285)
	elseif RandomJob == 2 then
		OstaviKoord = vector3(1367.0717773438, -780.54565429688, 66.745780944824)
	end

end

function SetClothes(playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if ConfigL.Uniforms["uniforma"].male then
				TriggerEvent('skinchanger:loadClothes', skin, ConfigL.Uniforms["uniforma"].male)
				else
			
				end
			
		else
			if ConfigL.Uniforms["uniforma"].female then
				TriggerEvent('skinchanger:loadClothes', skin, ConfigL.Uniforms["uniforma"].female)
				else
		
				end


		end
	end)
end
local blip = AddBlipForCoord(vector3(1380.8416748047, -773.89587402344, 65.999649047852))
	
SetBlipSprite(blip, 478)
SetBlipScale (blip, 0.5)
SetBlipColour(blip, 81)
SetBlipAsShortRange(blip, true)
	 
BeginTextCommandSetBlipName('STRING')
AddTextComponentSubstringPlayerName('Construction site')
EndTextCommandSetBlipName(blip)

local blip = AddBlipForCoord(vector3(1382.96, -741.55, 67.22))
	
SetBlipSprite(blip, 478)
SetBlipScale (blip, 0.9)
SetBlipColour(blip, 81)
SetBlipAsShortRange(blip, true)
	 
BeginTextCommandSetBlipName('STRING')
AddTextComponentSubstringPlayerName('Construction site')
EndTextCommandSetBlipName(blip)

exports.qtarget:AddBoxZone("builderbrick", vector3(1381.05, -774.04, 67.31), 1.8, 1.99, {
    name="builderbrick",
	heading=125.0,
	debugPoly=false,

    }, {
        options = {
            {
                event = "TakeBrick:builder", 
                icon = "fas fa-hand",
                label = "Take the brick",
            },
  
        },
        distance = 3.5
})
poceo = false
AddEventHandler('TakeBrick:builder', function()
	if  poceo then
	TakeBrick = false
	if ConfigL.rprogress then 
		exports.rprogress:Custom({
			Duration = 2000,
			Label = "You take a brick..",
			DisableControls = {
				Mouse = false,
				Player = true,
				Vehicle = true
			}
		})
	end 	
	LeaveTheBrick = true
	uzeo = true
	ESX.Streaming.RequestAnimDict('creatures@rottweiler@tricks@', function()
		FreezeEntityPosition(PlayerPedId(), true)
		TaskPlayAnim(PlayerPedId(), 'creatures@rottweiler@tricks@', 'petting_franklin', 8.0, -8, -1, 36, 0, 0, 0, 0)
		Citizen.Wait(2000)
		ClearPedSecondaryTask(PlayerPedId())
		FreezeEntityPosition(PlayerPedId(), false)
		RemoveAnimDict("creatures@rottweiler@tricks@")
	end)
	ESX.Streaming.RequestAnimDict('amb@world_human_bum_freeway@male@base', function()
		TaskPlayAnim(PlayerPedId(), 'amb@world_human_bum_freeway@male@base', 'base', 8.0, -8, -1, 49, 0, 0, 0, 0)
	end)
	local playerPed = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(playerPed))
	prop = CreateObject(GetHashKey("prop_wallbrick_01"), x, y, z+2, false, false, false)
	local boneIndex = GetPedBoneIndex(playerPed, 57005)
	AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.068, -0.241, 0.0, 90.0, 20.0, true, true, false, true, 1, true)
	ESX.ShowNotification("Go to the last wall to leave the block!")
	else
		return
	end
end)

AddEventHandler('brotex_builder:hasEnteredMarker', function(zone)
	

	
	if zone == 'LeaveTheBrick' then
		LeaveTheBrick = false
		if ConfigL.rprogress then
			exports.rprogress:Custom({
				Duration = 1500,
				Label = "You placed a brick..",
				DisableControls = {
					Mouse = false,
					Player = true,
					Vehicle = true
				}
			})
		end	
		if ObjBr == 1 then
			ESX.Streaming.RequestAnimDict('random@domestic', function()
				FreezeEntityPosition(PlayerPedId(), true)
				TaskPlayAnim(PlayerPedId(), 'random@domestic', 'pickup_low', 8.0, -8, -1, 36, 0, 0, 0, 0)
				Wait(500)
				DeleteObject(prop)
				prop = nil
				Citizen.Wait(1700)
				ClearPedSecondaryTask(PlayerPedId())
				FreezeEntityPosition(PlayerPedId(), false)
				RemoveAnimDict("random@domestic")
			end)
			if RandomJob == 1 then
				ESX.Game.SpawnLocalObject('prop_wallbrick_01', {
							x = 1373.352,
							y =  -781.0687,
							z = 66.01108
				}, function(obj)
					--PlaceObjectOnGroundProperly(obj)
					SetEntityRotation(obj, -0.08805062, -0.0002665851, -9.770086, 2, true)
					FreezeEntityPosition(obj, true)
					table.insert(Objekti, obj)
					LastBrick = obj
					FirtBrick = obj
					local prvioffset = GetOffsetFromEntityInWorldCoords(obj, -0.42, -0.4, 0.0)
					OstaviKoord = prvioffset
				end)
			elseif RandomJob == 2 then
				ESX.Game.SpawnLocalObject('prop_wallbrick_01', {
							x = 1367.143,
							y =  -779.98,
							z = 66.02597
				}, function(obj)
					--PlaceObjectOnGroundProperly(obj)
					SetEntityRotation(obj, -0.08805062, -0.0002665851, -9.770086, 2, true)
					FreezeEntityPosition(obj, true)
					table.insert(Objekti, obj)
					LastBrick = obj
					FirtBrick = obj
					local prvioffset = GetOffsetFromEntityInWorldCoords(obj, -0.42, -0.4, 0.0) 
					OstaviKoord = prvioffset
				end)
			end
			ObjBr = ObjBr+1
			TakeBrick = true
			ESX.TriggerServerCallback('brotex_builder:gmoney', function() end)
                 ESX.ShowNotification('You placed a brick and got $50')
		else
			if ObjBr > 1 and ObjBr ~= 16 and ObjBr ~= 31 and ObjBr ~= 46 and ObjBr ~= 61 then
				local prvioffset = GetOffsetFromEntityInWorldCoords(LastBrick, -0.42, 0.0, -0.073) 
				ESX.Streaming.RequestAnimDict('random@domestic', function()
					FreezeEntityPosition(PlayerPedId(), true)
					TaskPlayAnim(PlayerPedId(), 'random@domestic', 'pickup_low', 8.0, -8, -1, 36, 0, 0, 0, 0)
					Wait(500)
					DeleteObject(prop)
					prop = nil
					Citizen.Wait(1700)
					ClearPedSecondaryTask(PlayerPedId())
					FreezeEntityPosition(PlayerPedId(), false)
					RemoveAnimDict("random@domestic")
				end)
				ESX.Game.SpawnLocalObject('prop_wallbrick_01', {
							x = prvioffset.x,
							y =  prvioffset.y,
							z = prvioffset.z
				}, function(obj)
					--PlaceObjectOnGroundProperly(obj)
					SetEntityRotation(obj, -0.08805062, -0.0002665851, -9.770086, 2, true)
					FreezeEntityPosition(obj, true)
					table.insert(Objekti, obj)
					LastBrick = obj
					if ObjBr == 16 or ObjBr == 31 or ObjBr == 46 or ObjBr == 61 then
						if RandomJob == 1 then
							OstaviKoord = vector3(1373.4049072266, -781.62121582031, 66.773597717285)
						elseif RandomJob == 2 then
							OstaviKoord = vector3(1367.0717773438, -780.54565429688, 66.745780944824)
						end
					else
						local prvioffset2 = GetOffsetFromEntityInWorldCoords(obj, -0.42, -0.4, 0.0) 
						OstaviKoord = prvioffset2
					end
				end)
				ObjBr = ObjBr+1
				if ObjBr == 76 then
				     ESX.ShowNotification('You finished the job')
					 ESX.TriggerServerCallback('brotex_builder:greward', function() end)
	
					ESX.ShowNotification("To start working again, go and get the gear!")
				else
					TakeBrick = true
				end

				ESX.TriggerServerCallback('brotex_builder:gmoney', function() end)
			  ESX.ShowNotification('You placed a brick and got $10')
			elseif ObjBr == 16 or ObjBr == 31 or ObjBr == 46 or ObjBr == 61 then
				local prvioffset = GetOffsetFromEntityInWorldCoords(FirtBrick, 0.0, 0.0, 0.07)
				ESX.Streaming.RequestAnimDict('random@domestic', function()
					FreezeEntityPosition(PlayerPedId(), true)
					TaskPlayAnim(PlayerPedId(), 'random@domestic', 'pickup_low', 8.0, -8, -1, 36, 0, 0, 0, 0)
					Wait(500)
					DeleteObject(prop)
					prop = nil
					Citizen.Wait(1700)
					ClearPedSecondaryTask(PlayerPedId())
					FreezeEntityPosition(PlayerPedId(), false)
					RemoveAnimDict("random@domestic")
				end)
				ESX.Game.SpawnLocalObject('prop_wallbrick_01', {
					x = prvioffset.x,
					y =  prvioffset.y,
					z = prvioffset.z
				}, function(obj)
					--PlaceObjectOnGroundProperly(obj)
					SetEntityRotation(obj, -0.08805062, -0.0002665851, -9.770086, 2, true)
					FreezeEntityPosition(obj, true)
					table.insert(Objekti, obj)
					LastBrick = obj
					FirtBrick = obj
					local prvioffset2 = GetOffsetFromEntityInWorldCoords(obj, -0.42, -0.4, 0.0) 
					OstaviKoord = prvioffset2
				end)
				ObjBr = ObjBr+1
				TakeBrick = true
				ESX.TriggerServerCallback('brotex_builder:gmoney', function() end)
	  ESX.ShowNotification('You placed a brick and got $10')
			end
		end
	end
end)

function ZavrsiPosao()
	if YouWork == true then
		for i=1, #Objekti, 1 do
			if Objekti[i] ~= nil then
				ESX.Game.DeleteObject(Objekti[i])
			end
		end
		YouWork = false
		TriggerEvent("dpemotes:Radim", false)
		LeaveTheBrick = false
		TakeBrick = false
		LastBrick = nil
		OstaviKoord = nil
	end
end

AddEventHandler('brotex_builder:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()    
    CurrentAction = nil
    CurrentActionMsg = ''
end)

function round(num, numDecimalPlaces)
    local mult = 5^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- Crtanje markera
Citizen.CreateThread(function()
	local waitara = 500
	while true do
		Citizen.Wait(waitara)
		local naso = 0
			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(ConfigL.Cloakroom) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end
			
			if YouWork and TakeBrick and (GetDistanceBetweenCoords(coords, 1380.8416748047, -773.89587402344, 66.999649047852, true) < 1.5) then
				isInMarker  = true
				currentZone = "TakeBrick"
			end
			
			if YouWork and LeaveTheBrick and (GetDistanceBetweenCoords(coords, OstaviKoord, false) < 0.5) then
				isInMarker  = true
				currentZone = "LeaveTheBrick"
			end
			
			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('brotex_builder:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('brotex_builder:hasExitedMarker', lastZone)
			end

		
		
			
			if YouWork and LeaveTheBrick and GetDistanceBetweenCoords(coords, OstaviKoord, true) < ConfigL.DrawDistance then
				waitara = 0
				naso = 1
				DrawMarker(0, OstaviKoord, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 204, 204, 0, 100, false, true, 2, false, false, false, false)
			end

		end
		if naso == 0 then
			waitara = 500
		end
end)

-------------------------------------------------
-- Functions  --   Functions and playerLoad    --
-------------------------------------------------

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

RegisterNetEvent('brotex_builder:finish')
AddEventHandler('brotex_builder:finish', function(source)
	ZavrsiPosao()
	poceo = false
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)
end)

RegisterNetEvent('brotex_builder:start1')
AddEventHandler('brotex_builder:start1', function(source)
	SetClothes(PlayerPedId())
	StartJob()
	poceo = true
end)
local peds = {
    `s_m_y_construct_01`,
}
        exports["qtarget"]:AddTargetModel(peds, {
            options = {
                {
                    event = "otvorigradjevinara",
                    icon = "fas fa-hammer",
                    label = "Builder!",
					num = 1
                },
			
             },
             job = {"all"},
            distance = 2.0
        })

		AddEventHandler('otvorigradjevinara', function()
			TriggerEvent('nh-context:sendMenu', {
				{
					id = 1,
					header = "🧱| Start work!",
					txt = "Start working as a builder!",
					params = {
						event = "brotex_builder:start1",
					}
					
				},
				{
					id = 2,
					header = "🧽| Finish the job!",
					txt = "Finish your work and take off your uniform!",
					params = {
						event = "brotex_builder:finish",
					}
					
				},
			})
		end)



  TabelaZaPedove = {
	{'s_m_y_construct_01'--[[HASH]], 1390.95--[[X COORDS]], -749.07 --[[Y COORDS]],66.33--[[Z COORDS]],99.0--[[HEADING]]},
  }
  
  Citizen.CreateThread(function()
	
	for _,v in pairs(TabelaZaPedove) do
	  RequestModel(GetHashKey(v[1]))
	  while not HasModelLoaded(GetHashKey(v[1])) do
		Wait(1)
	  end

	  BuilderPed =  CreatePed(4, v[1],v[2],v[3],v[4],v[5], false, true)
	  FreezeEntityPosition(BuilderPed, true) 
	  SetEntityInvincible(BuilderPed, true) 
	  SetBlockingOfNonTemporaryEvents(BuilderPed, true) 
	end
  end)