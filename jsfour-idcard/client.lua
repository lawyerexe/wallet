local open = false

RegisterNetEvent('jsfour-idcard:open', function(data, type)
	open = true
	SendNUIMessage({
		action = "open",
		array = data,
		type = type
	})
end)

Citizen.CreateThread(function()
	while true do
		local time = 250
		if open then
			time = 1
			DisableControlAction(0, 177, true)
			DisableControlAction(0, 200, true)
			if IsDisabledControlJustReleased(0, 177) then
				SendNUIMessage({action = "close"})
				open = false
			end
		end
		Citizen.Wait(time)
	end
end)