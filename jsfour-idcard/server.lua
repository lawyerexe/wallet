QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('jsfour-idcard:open', function(data, target, type)
	local src = source
	local xPlayer = QBCore.Functions.GetPlayer(src)
	local Target = QBCore.Functions.GetPlayer(target)
	local show = false

	if type ~= nil then
		if type == 'driver' then
			if data["licences"]["drive"] or data["licences"]["drive_bike"] or data["licences"]["drive_truck"] or data["licences"]["aircraft"] then 
				show = true
			end
		else
			if data["licences"]["weapon"] then
				show = true
			end
		end
	else
		show = true
	end

	if show or not type then
		local licences = {}
		user = {
			citizenid = data.citizenid,
			name = data.firstname..' '..data.lastname,
			dob = data.birthdate,
			sex = data.gender,
			lastdigits = data.account,
			photo = data.photo
		}

		for name,data in pairs(data["licences"]) do 
			if data then
				licences[name] = name
			end
		end
		local array = {
			user = user,
			licenses = licences
		}
		
		TriggerClientEvent('jsfour-idcard:open', Target.PlayerData.source, array, type)
	else
		TriggerClientEvent("QBCore:Notify", xPlayer.PlayerData.source, "Cüzdan Sahibi Bu Belgeye Sahip Değil!", "error")
	end
end)

RegisterServerEvent('jsfour-idcard:server:open-pd')
AddEventHandler('jsfour-idcard:server:open-pd', function(targetID)
	local src = source
	local xPlayer = QBCore.Functions.GetPlayer(src)
	local data = {
		name = xPlayer.PlayerData.charinfo.firstname.. " " ..xPlayer.PlayerData.charinfo.lastname,
		photo = xPlayer.PlayerData.charinfo.photo,
		rank = QBCore.Shared.Jobs["police"]["grade"][xPlayer.PlayerData.job.grade].label
	}
	TriggerClientEvent("jsfour-idcard:open-pd", targetID, data)
end)

function checkTrafikCeza(xPlayer)
	if xPlayer.PlayerData.metadata.ehliyetceza > 9 then
		return xPlayer.PlayerData.metadata.ehliyetceza
	end
	return false
end