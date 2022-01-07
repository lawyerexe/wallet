QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Functions.CreateUseableItem('kimlikcuzdan' , function(source, item)
	local src = source
	local res = exports['ghmattimysql']:executeSync('SELECT * FROM players WHERE citizenid = @citizenid', {
		['@citizenid'] = item.info.citizenid
	})
	if res[1] ~= nil then
		res[1].charinfo = json.decode(res[1].charinfo)
	end
	TriggerClientEvent('lawyer-wallet:wallet', src, res[1].charinfo)
end)