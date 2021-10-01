local ESX = nil
local TriggerServEvent = TriggerServerEvent
local GoFast, AllsBlips = {}, {}
local MissionActived = false
CreateThread(function() while ESX == nil do TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end) Wait(10) end end)
local GoFastMenu, IllegalGofast, statebtn, description, Timer = RageUI.CreateMenu("GoFast", "Illegal Mission", 15, 160), false, true, nil, 1 * 60000
GoFastMenu:SetRectangleBanner(255, 50, 0, 50)
GoFastMenu.Closed = function() 
    IllegalGofast = false 
end

local MissIsActived = false

local function DrawMissionText(msg, time)
    ClearPrints()
    BeginTextCommandPrint('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandPrint(time, 1)
end

local function NotifAdvanced(title, subject, msg, icon, iconType)
    SetNotificationTextEntry('STRING')
    AddTextComponentSubstringPlayerName(msg)
    SetNotificationMessage(icon, icon, false, iconType, title, subject)
    DrawNotification(false, false)
end

local function Notification(msg)
    SetNotificationTextEntry('STRING')
    AddTextComponentSubstringPlayerName(msg)
    DrawNotification(false, true)
end

RegisterNetEvent("<<DkM>>:AdvancedNotif") 
AddEventHandler("<<DkM>>:AdvancedNotif", function(title, subject, msg, icon, iconType) 
    NotifAdvanced(title, subject, msg, icon, iconType) end)

local function openMissionsIllegal()
    if IllegalGofast == false then
        if IllegalGofast then
            IllegalGofast = false
        else
            IllegalGofast = true
            RageUI.Visible(GoFastMenu, true)
            CreateThread(function()
                while IllegalGofast do
                    Wait(1.0)
                    RageUI.IsVisible(GoFastMenu, function()

                    for _, config in pairs (GoFastConfig.MenuSettings) do
                        RageUI.Button(config.typebtn, description, {}, statebtn, {
                            onSelected = function()
                            if ESX.Game.IsSpawnPointClear(config.spawncoordsveh, 7.0) then
                                TypesTrajets(config.typedetrajet, config.nameveh, config.spawncoordsveh, config.spawnheading)
                                statebtn = false
                                description = "Veuillez patientez 10 minutes avant de relancer une mission illégal"
                                RageUI.CloseAll()
                                IllegalGofast = false
                                MissionActived = true
                                getandsetMission()
                                SetTimeout(Timer, function() 
                                    statebtn = true
                                    description = nil 
                                end)
                            else
                                Notification("~o~"..NamePedRandoms.. "\n~r~Tu ne peux pas sortir de véhicule, t'es aveugle ?")
                            end
                        end});
                    end

                    end, function()
                        for k, config in pairs (GoFastConfig.MenuSettings) do
                            if not statebtn == false then
                                RageUI.BoutonPanel("~g~"..config.randomrenumeration.. "$", "Rémunération", k)
                                RageUI.StatisticPanel(config.difficulter, "Difficulté", k)
                            end
                        end
                    end)
                end
            end)
        end
    end
end

function DeleteBlips()
    for _, v in pairs (AllsBlips) do
        RemoveBlip(v)
    end
end

function setBlip(bliptype)
    if bliptype == 1 then
        CreateThread(function()
            print("DakoM >> blip 1 loaded")
            for _, var in pairs (GoFastConfig.RacheteurDrogues) do
                BlipsDrogues = AddBlipForCoord(var.PositionRacheteur)
                table.insert(AllsBlips, BlipsDrogues)
                SetBlipRoute(BlipsDrogues, true)
                SetBlipSprite(BlipsArgent, 1)
                SetBlipColour(BlipsArgent, 1)
                SetBlipRouteColour(BlipsDrogues, 1)
                SetBlipDisplay(BlipsDrogues, 5)
                SetBlipScale(BlipsDrogues, 1.0)
                SetBlipAsShortRange(BlipsDrogues, false)
            end
        end)
    elseif bliptype == 2 then
        CreateThread(function()
            print("DakoM >> blip 2 loaded")
            for _, var in pairs (GoFastConfig.RacheteurArgentSale) do
                BlipsArgent = AddBlipForCoord(var.PositionRacheteur)
                table.insert(AllsBlips, BlipsArgent)
                SetBlipRoute(BlipsArgent, true)
                SetBlipSprite(BlipsArgent, 1)
                SetBlipColour(BlipsArgent, 47)
                SetBlipRouteColour(BlipsArgent, 47)
                SetBlipDisplay(BlipsArgent, 5)
                SetBlipScale(BlipsArgent, 1.0)
                SetBlipAsShortRange(BlipsArgent, false)
            end
        end)
    end
end

local function ShowTiimer(messages, activer) 
    if activer then
        SetTextFont(0) 
        SetTextProportional(0) 
        SetTextScale(0.35, 0.35) 
        SetTextDropShadow(0, 0, 0, 0,255) 
        SetTextEdge(1, 0, 0, 0, 255) 
        SetTextEntry("STRING") 
        AddTextComponentString(messages) 
        DrawText(0.35, 0.95) 
    else
        ClearPrints()
    end
end

function getandsetMission()
    CreateThread(function()
        while true do
        local time = GetGameTimer()+60000
            while GetGameTimer() <= time do
                Wait(1.0)
                if MissionActived then
                    if IsPedInAnyVehicle(PlayerPedId(), -1) then
                        ShowTiimer(false)
                        MissionActived = true
                        time = GetGameTimer()+60000
                    else
                        ShowTiimer("Veuillez rentrez dans le véhicule avant ~r~"..math.floor((time-GetGameTimer()) / 1000).. "~s~ secondes", true)
                        MissIsActived = true
                        if math.floor((time-GetGameTimer()) / 1000) <= 1 then
                            ShowTiimer(false)
                            Notification("~r~Ta mission a était annuler, revient plus tard")
                            DeleteBlips()
                            MissionActived = false
                            MissIsActived = false
                        end
                    end
                end
            end
        end
    end)
end

function TypesTrajets(typetrajet, nameveh, coords, heading)
    if typetrajet == 1 then
        print("Drogues Loaded")
        ESX.Game.SpawnVehicle(nameveh, coords, heading, function(vehicle1) 
            vehicle1 = vehicle1
            SetPedIntoVehicle(PlayerPedId(), vehicle1, -1)
            SetVehicleDirtLevel(vehicle1, 100)
            SetVehicleEngineOn(vehicle1, false, true, true)
            SetVehicleNumberPlateText(vehicle1, "GOFAST")
            Visual.PromptDuration(3500, "Mise en Place de la Position sur le GPS", 1)
            GetIdDroguesVeh = NetworkGetNetworkIdFromEntity(vehicle1)
            print("ID Vehicule Drogues: "..GetIdDroguesVeh)
            SetTimeout(4200, function()
                SetVehicleEngineOn(vehicle1, true, true, true)
                setBlip(1)
                NotifAdvanced(NamePedRandoms, "Discussion", "Allez rend toi la bas et trace pour pas que les flics te chope tout !", "CHAR_DETONATEPHONE", 1)
            end)
            SetTimeout(1 * 60000, function()
                TriggerServEvent("<<DakoM>>:AlertPolice", "Livraison", "Illégal", "Un citoyen a apercu un véhicule avec une cargaison illégal dans le nord!", "CHAR_CALL911", 1)
            end)
        end)
    elseif typetrajet == 2 then
        print("Argents Sale Loaded")
        ESX.Game.SpawnVehicle(nameveh, coords, heading, function(vehicle2) 
            vehicle2 = vehicle2
            SetPedIntoVehicle(PlayerPedId(), vehicle2, -1)
            SetVehicleDirtLevel(vehicle2, 100)
            SetVehicleEngineOn(vehicle2, false, true, true)
            SetVehicleNumberPlateText(vehicle2, "GOFAST")
            Visual.PromptDuration(3500, "Mise en Place de la Position sur le GPS", 1)
            GetIdArgentsVeh = NetworkGetNetworkIdFromEntity(vehicle2)
            print("ID Vehicule argent sale: "..GetIdArgentsVeh)
            SetTimeout(4200, function() SetVehicleEngineOn(vehicle2, true, true, true) 
                setBlip(2) 
                NotifAdvanced(NamePedRandoms, "Discussion", "Allez rend toi la bas et trace pour pas que les flics nous chope tout !", "CHAR_DETONATEPHONE", 1)
            end)
            SetTimeout(1 * 60000, function()
                TriggerServEvent("<<DakoM>>:AlertPolice", "Livraison", "Illégal", "Un citoyen a apercu un véhicule avec une cargaison illégal dans le nord!", "CHAR_CALL911", 1)
            end)
        end)
    end
end

CreateThread(function()
    NamePedRandoms = GoFastConfig.RandomsNamesOfPed[math.random(1, #GoFastConfig.RandomsNamesOfPed)]
    local LoadNamePeds = GoFastConfig.RandomsPedSpawning[math.random(2, #GoFastConfig.RandomsPedSpawning)]
    for _, config in pairs(GoFastConfig.PedCoords) do
        RequestModel(GetHashKey(LoadNamePeds))
        while not HasModelLoaded(GetHashKey(LoadNamePeds)) do Wait(1) end
        pedsillegal = CreatePed(4, LoadNamePeds, config.PedPos[1], config.PedPos[2], config.PedPos[3], 3374176, false, true)
        SetEntityHeading(pedsillegal, config.PedPos.heading)
        FreezeEntityPosition(pedsillegal, true)
        SetEntityInvincible(pedsillegal, true)
        TaskStartScenarioInPlace(pedsillegal, config.ScenarioPeds, 0, true)
        SetBlockingOfNonTemporaryEvents(pedsillegal, true)
    end
    while true do
        local activerfps = false
        local pCoords2 = GetEntityCoords(PlayerPedId())
        for _, var in pairs(GoFastConfig.PositionMenu) do
            if #(pCoords2 - var.PostionMenu) < 1.5 then
                activerfps = true
                Visual.Subtitle("Appuyez sur ~o~E~s~ pour parler avec " ..NamePedRandoms, 1)
                if IsControlJustReleased(0, 38) then
                    openMissionsIllegal()
                end
            elseif #(pCoords2 - var.PostionMenu) < 4.0 then
                activerfps = true
            end
        end
        for _, var in pairs(GoFastConfig.RacheteurDrogues) do
            if MissIsActived then
                if #(pCoords2 - var.PositionRacheteur) < 2.0 then
                    activerfps = true
                    Visual.Subtitle("Appuyez sur ~o~E~s~ pour completer la mission", 1)
                    if IsControlJustReleased(0, 38) then
                        TriggerServEvent("<<DakoM>>:PaymentGoFastDrogues", GoFastConfig.PriceRandom.PriceDrogues)
                        activerfps = false
                        Visual.Subtitle("Bienvue mon gars ! revient plus tard", 6500)
                        Wait(10 * 60000)
                        activerfps = true
                    end
                elseif #(pCoords2 - var.PositionRacheteur) < 35.0 then
                    MissionActived = false
                    activerfps = true
                    DeleteBlips()
                    Visual.Subtitle("~r~Cherchez le racheteur", 1)
                end
            end
        end
        for _, var in pairs(GoFastConfig.RacheteurArgentSale) do
            if MissIsActived then
                if #(pCoords2 - var.PositionRacheteur) < 2.0 then
                    activerfps = true
                    Visual.Subtitle("Appuyez sur ~o~E~s~ pour completer la mission", 1)
                    if IsControlJustReleased(0, 38) then
                        TriggerServEvent("<<DakoM>>:PaymentGoFastArgent", GoFastConfig.PriceRandom.PriceArgentSale)
                        activerfps = false
                        Visual.Subtitle("Bienvue mon gars ! revient plus tard", 6500)
                        Wait(10 * 60000)
                        activerfps = true
                    end
                elseif #(pCoords2 - var.PositionRacheteur) < 35.0 then
                    MissionActived = false
                    activerfps = true
                    DeleteBlips()
                    Visual.Subtitle("~r~Cherchez le racheteur", 1)
                end
            end
        end
        if activerfps then
            Wait(1.0)
        else
            Wait(1500)
        end
    end
end)