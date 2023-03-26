ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


	ESX.RegisterServerCallback('brotex_builder:gmoney', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
        xPlayer.addMoney(50) -- This is money which will player get when put brick
end)


	ESX.RegisterServerCallback('brotex_builder:greward', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
        xPlayer.addMoney(100) -- This is reward which will player get after some putted bricks
end)