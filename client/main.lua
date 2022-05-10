ESX = nil


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
        RefreshBlip()
        CreateBlip()
	end

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
    RefreshBlip()
    CreateBlip()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer

end)

local satiyormu = false
local satiskordinat = false
local satisblip = false

function SatisBlipOlustur(x,y,z)
	local blip = AddBlipForCoord(x,y,z)
	SetBlipSprite(blip, 514)
	SetBlipColour(blip, 4)
	AddTextEntry('MYBLIP', "Teslimat Noktası")
	BeginTextCommandSetBlipName('MYBLIP')
	AddTextComponentSubstringPlayerName(name)
	EndTextCommandSetBlipName(blip)
	return blip
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(2)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    while true do
        local ms = 2000
        local player = PlayerPedId()
        local playercoords = GetEntityCoords(player)
        local coords = GetBlipInfoIdCoord(satisblip)
        if GetDistanceBetweenCoords(playercoords, Config.Toplamabolgesi.x, Config.Toplamabolgesi.y, Config.Toplamabolgesi.z, true) < 10 then
            ms = 0
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'kargo' then
            DrawMarker(2, Config.Toplamabolgesi.x, Config.Toplamabolgesi.y, Config.Toplamabolgesi.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4, 0.2, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
            if GetDistanceBetweenCoords(playercoords, Config.Toplamabolgesi.x, Config.Toplamabolgesi.y, Config.Toplamabolgesi.z, true) < 1.0 then
                DrawText3D(Config.Toplamabolgesi.x, Config.Toplamabolgesi.y, Config.Toplamabolgesi.z + 0.4, 'Tavuk eti paketlemek icin ~g~E~s~ bas')
                    if IsControlJustReleased(0, 38) then
                        exports['mythic_progbar']:Progress({
                        name = "kargopaketle",
                        duration = Config.toplamasuresikargo,
                        label = 'Kargo topluyorsun...',
                        useWhileDead = false,
                        canCancel = false,
                        controlDisables = {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        },
                        animation = {
                            animDict = "creatures@rottweiler@tricks@",
                            anim = "petting_franklin",
                            flags = 49,
                        },
                        }, function(cancelled)
                            if not cancelled then
                                TriggerServerEvent('erbay-kargo:kargotopla')
                                Citizen.Wait(Config.toplamasuresikargo)
                            else
                            -- Do Something If Action Was Cancelled
                            end
                        end)
                    end
                end
            end
        end
        if GetDistanceBetweenCoords(playercoords, Config.Satmabolgesi.x, Config.Satmabolgesi.y, Config.Satmabolgesi.z, true) < 10 then
            ms = 0
            if GetDistanceBetweenCoords(playercoords, Config.Satmabolgesi.x, Config.Satmabolgesi.y, Config.Satmabolgesi.z, true) < 5 then
                if ESX.PlayerData.job and ESX.PlayerData.job.name == 'kargo' then
                    DrawText3D(Config.Satmabolgesi.x, Config.Satmabolgesi.y, Config.Satmabolgesi.z + 2.0, 'Kargo dagıtıcısı ile konusmak için ~g~E~s~ bas')
                    if IsControlJustReleased(0, 38) then
                        kargoteslimatbaslat()
                    end
                end
            end
        end
        if satiyormu == true and satiskordinat ~= false and GetDistanceBetweenCoords(playercoords, coords[1], coords[2], coords[3], true) < 10 then
            ms = 0
            if satiyormu == true and satiskordinat ~= false and GetDistanceBetweenCoords(playercoords, coords[1], coords[2], coords[3], true) < 5 then
                if ESX.PlayerData.job and ESX.PlayerData.job.name == 'kargo' then
                    DrawText3D(coords[1], coords[2], coords[3] + 1.0, 'Alıcıyla Konus için ~g~E~s~ bas')
                    if IsControlJustReleased(0, 38) then
                        kargoteslim()
                    end
                end
            end
        end
        Citizen.Wait(ms)
    end
end)

function kargoteslimatbaslat()
    if not satiyormu then
        ESX.TriggerServerCallback('erbay-kargo:kargokontrol', function(data)
            local random = math.random(1,#Config.Locations)
	        satisblip = true
	        satiskordinat = {
		        x = Config.Locations[random][1],
		        y = Config.Locations[random][2],
		        z = Config.Locations[random][3],
		        h = Config.Locations[random][4]
	        }
	        satisblip = SatisBlipOlustur(satiskordinat.x, satiskordinat.y, satiskordinat.z)
            satiyormu = true
			exports['mythic_notify']:DoHudText('success', 'Dağıtıma çıktın!')
            local hash = GetHashKey('a_m_m_bevhills_01')
            while not HasModelLoaded(hash) do
            RequestModel(hash)
            Wait(20)
            end
            npc = CreatePed("PED_TYPE_CIVFEMALE", 'a_m_m_bevhills_01', satiskordinat.x, satiskordinat.y, satiskordinat.z, satiskordinat.h, false, true)
            PlaceObjectOnGroundProperly(npc)
            SetEntityAsMissionEntity(npc)
            SetBlockingOfNonTemporaryEvents(npc, true)
            FreezeEntityPosition(npc, true)
            SetEntityInvincible(npc, true)
            TaskStartScenarioAtPosition(npc, "CODE_HUMAN_CROSS_ROAD_WAIT", satiskordinat.x, satiskordinat.y, satiskordinat.z, satiskordinat.h, -1, false, false)
        end, "kargo", 1)
    elseif satiyormu then
		exports['mythic_notify']:DoHudText('error', 'Zaten dağıtıma çıktın!')
    end
end

function kargoteslimatbaslattekrar()
    if not satiyormu then
        ESX.TriggerServerCallback('erbay-kargo:kargokontrol1', function(data)
            local random = math.random(1,#Config.Locations)
	        satisblip = true
	        satiskordinat = {
		        x = Config.Locations[random][1],
		        y = Config.Locations[random][2],
		        z = Config.Locations[random][3],
		        h = Config.Locations[random][4]
	        }
	        satisblip = SatisBlipOlustur(satiskordinat.x, satiskordinat.y, satiskordinat.z)
            satiyormu = true
			exports['mythic_notify']:DoHudText('success', 'Yeni kargo teslimat yeri belirlendi!')
            local hash = GetHashKey('a_m_m_bevhills_01')
            while not HasModelLoaded(hash) do
            RequestModel(hash)
            Wait(20)
            end
            npc = CreatePed("PED_TYPE_CIVFEMALE", 'a_m_m_bevhills_01', satiskordinat.x, satiskordinat.y, satiskordinat.z, satiskordinat.h, false, true)
            PlaceObjectOnGroundProperly(npc)
            SetEntityAsMissionEntity(npc)
            SetBlockingOfNonTemporaryEvents(npc, true)
            FreezeEntityPosition(npc, true)
            SetEntityInvincible(npc, true)
            TaskStartScenarioAtPosition(npc, "CODE_HUMAN_CROSS_ROAD_WAIT", satiskordinat.x, satiskordinat.y, satiskordinat.z, satiskordinat.h, -1, false, false)
        end, "kargo", 1)
    elseif satiyormu then
		exports['mythic_notify']:DoHudText('error', 'Zaten dağıtıma çıktın!')
    end
end

function kargoteslim()
    exports['mythic_progbar']:Progress({
        name = "alicikonusma",
        duration = 10000,
        label = 'Alıcıyla konuşuyorsun...',
        useWhileDead = false,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "anim@heists@box_carry@",
            anim = "idle",
            flags = 49,
        },
        prop = {
            model = "hei_prop_heist_box",
            bone = 60309,
            coords = { x = 0.12, y = 0.0, z = 0.001 },
            rotation = { x = -150.0, y = 0.0, z = 0.0 },
        },
    }, function(cancelled)
        if not cancelled then
            TriggerServerEvent('erbay-kargo:kargokontrolteslim')
            satiskordinat = false
            satiyormu = false
            ClearPedTasks(npc)
            SetPedAsNoLongerNeeded(npc)
            TaskWanderStandard(npc, 10.0, 10)
			exports['mythic_notify']:DoHudText('success', 'Kargoyu teslim ettin!')
            kargoteslimatbaslattekrar()
            blipkaldir()
        else
            -- Do Something If Action Was Cancelled
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        local sleep = 2000
        if satiyormu == false and satisblip ~= false then
            sleep = 7
			RemoveBlip(satisblip)
			satisblip = false
        end
        Citizen.Wait(sleep)
    end
end)

function blipkaldir()
    RemoveBlip(satisblip)
end

Citizen.CreateThread(function()
    RequestModel(Config.Saticinpcmodel)
    while not HasModelLoaded(Config.Saticinpcmodel) do
        Wait(1)
    end

    erbay = CreatePed(1, Config.Saticinpcmodel, Config.Satmabolgesi.x, Config.Satmabolgesi.y, Config.Satmabolgesi.z, Config.Satmabolgesi.h, false, true)
    SetBlockingOfNonTemporaryEvents(erbay, true)
    SetPedDiesWhenInjured(erbay, false)
    SetPedCanPlayAmbientAnims(erbay, true)
    SetPedCanRagdollFromPlayerImpact(erbay, false)
    SetEntityInvincible(erbay, true)
    FreezeEntityPosition(erbay, true)
    TaskStartScenarioInPlace(erbay, "WORLD_HUMAN_CLIPBOARD", 0, true);
end)

function CreateBlip()
    if ESX.GetPlayerData() and ESX.GetPlayerData().job and 'kargo' == ESX.PlayerData.job.name then
        blip = AddBlipForCoord(Config.Toplamabolgesi.x, Config.Toplamabolgesi.y, Config.Toplamabolgesi.z)
        SetBlipSprite(blip, 268)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, 0.7)
        SetBlipColour(blip, 0)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Kargo Toplama')
        EndTextCommandSetBlipName(blip)
        SetBlipAsShortRange(blip, true)
    end
    if ESX.GetPlayerData() and ESX.GetPlayerData().job and 'kargo' == ESX.PlayerData.job.name then
        blip1 = AddBlipForCoord(Config.Satmabolgesi.x, Config.Satmabolgesi.y, Config.Satmabolgesi.z)
        SetBlipSprite(blip1, 268)
        SetBlipDisplay(blip1, 4)
        SetBlipScale  (blip1, 0.7)
        SetBlipColour(blip1, 0)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Kargo Dağıtım Görevlisi')
        EndTextCommandSetBlipName(blip1)
        SetBlipAsShortRange(blip1, true)
    end
end

function RefreshBlip()
    if blip then
        RemoveBlip(blip)
        RemoveBlip(blip1)
    end
end
