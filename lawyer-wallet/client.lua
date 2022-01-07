
QBCore = nil
Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('lawyer-wallet:wallet', function(data)
    exports['qb-menu']:openMenu({
        {
            header = "Kimlik Cüzdanı",
			isMenuHeader = true,
        },
        {
            header = "Kimlik",
            txt = "Kimlik işlemleri.",
            params = {
                event = "lawyer-wallet:openid",
				args = {
                    data = data,
                }
            }
        },
		{
            header = "Ehliyet",
            txt = "Ehliyet işlemleri.",
            params = {
                event = "lawyer-wallet:opendriver",
				args = {
                    data = data,
                }
            }
        },
    })
end)

RegisterNetEvent('lawyer-wallet:openid', function(data)
	local data = data.data
    exports['qb-menu']:openMenu({
        {
            header = "Kimlik İşlemleri",
        },
        {
            header = "Kimliği Görüntüle",
            txt = "Kimliğine bak.",
            params = {
                event = "lawyer-wallet:showid",
				args = {
                    data = data,
                }
            }
        },
		{
            header = "Kimliği Uzat",
            txt = "Kimliğini yakındaki kişiye göster.",
            params = {
                event = "lawyer-wallet:giveid",
				args = {
                    data = data,
                }
            }
        },
    })
end)

RegisterNetEvent('lawyer-wallet:opendriver', function(data)
	local data = data.data
    exports['qb-menu']:openMenu({
        {
            header = "Ehliyet İşlemleri",
        },
        {
            header = "Ehliyeti Görüntüle",
            txt = "Ehliyetini bak.",
            params = {
                event = "lawyer-wallet:showdriver",
				args = {
                    data = data,
                }
            }
        },
		{
            header = "Ehliyeti Uzat",
            txt = "Ehliyetini yakındaki kişiye göster.",
            params = {
				args = {
                    data = data,
                }
            }
        },
    })
end)

RegisterNetEvent('lawyer-wallet:showid', function(data)
	local data = data.data
	TriggerServerEvent('jsfour-idcard:open', data, GetPlayerServerId(PlayerId()))
end)

RegisterNetEvent('lawyer-wallet:giveid', function(data)
	local data = data.data
    local player, distance = QBCore.Functions.GetClosestPlayer(GetEntityCoords(PlayerPedId()))

    if player ~= -1 and distance < 3 then
		QBCore.Functions.Notify('Kimlik Veriliyor', "inform")
		TriggerEvent('lawyer-wallet:animation')
		TriggerServerEvent('jsfour-idcard:open', data, GetPlayerServerId(player))
    else
        QBCore.Functions.Notify("Yakında Oyuncu Yok", "error")
    end
end)

RegisterNetEvent('lawyer-wallet:showdriver', function(data)
	local data = data.data
	TriggerServerEvent('jsfour-idcard:open', data, GetPlayerServerId(PlayerId()), 'driver')
end)

RegisterNetEvent('lawyer-wallet:givedriver', function(data)
	local data = data.data
    local player, distance = QBCore.Functions.GetClosestPlayer(GetEntityCoords(PlayerPedId()))
	
    if player ~= -1 and distance < 3 then
		if val == 'showDriver' then
			QBCore.Functions.Notify('Ehliyet Veriliyor', "inform")
			TriggerEvent('lawyer-wallet:animation')
		  	TriggerServerEvent('jsfour-idcard:open', data, GetPlayerServerId(player), 'driver')
		end
    else
        QBCore.Functions.Notify("Yakında Oyuncu Yok", "error")
    end
end)

local plate_net = nil

RegisterNetEvent("lawyer-wallet:animation", function()
	RequestModel(GetHashKey("prop_cs_swipe_card"))
	while not HasModelLoaded(GetHashKey("prop_cs_swipe_card")) do
		Citizen.Wait(100)
	end

	RequestAnimDict("missfbi_s4mop")
	while not HasAnimDictLoaded("missfbi_s4mop") do
		Citizen.Wait(100)
	end

	local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
	local platespawned = CreateObject(GetHashKey("prop_cs_swipe_card"), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
	Citizen.Wait(1000)
	local netid = ObjToNet(platespawned)
	SetNetworkIdExistsOnAllMachines(netid, true)
	SetNetworkIdCanMigrate(netid, false)
	TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0)
	TaskPlayAnim(GetPlayerPed(PlayerId()), "missfbi_s4mop", "swipe_card", 1.0, 1.0, -1, 50, 0, 0, 0, 0)
	Citizen.Wait(800)
	AttachEntityToEntity(platespawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
	plate_net = netid
	Citizen.Wait(3000)
	ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
	DetachEntity(NetToObj(plate_net), 1, 1)
	DeleteEntity(NetToObj(plate_net))
	plate_net = nil
end)