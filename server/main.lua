local CopsConnected       = 0

local PlayersHarvesting   = {}
local PlayersTransforming = {}
local PlayersSelling      = {}

function CountCops()

	TriggerEvent('esx:getPlayers', function(xPlayers)

		CopsConnected = 0

		for k,v in pairs(xPlayers) do
			if v.job.name == 'cop' then
				CopsConnected = CopsConnected + 1
			end
		end

	end)

	SetTimeout(5000, CountCops)

end

CountCops()

local function HarvestCoke(source)

	if CopsConnected < Config.RequiredCops then
		TriggerClientEvent('esx_cokejob:showNotification', source, 'Action ~r~impossible~s~, ~b~policiers~s~: ' .. CopsConnected .. '/' .. Config.RequiredCops)
		return
	end

	SetTimeout(5000, function()

		if PlayersHarvesting[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local cokeQuantity = xPlayer:getInventoryItem('coke')

				if coke.limit ~= -1 and coke.count >= coke.limit then
					TriggerClientEvent('esx_weedjob:showNotification', source, 'Vous ne pouvez plus ramasser de Cocaine, votre inventaire est ~r~plein~s~')
				else
					xPlayer:addInventoryItem('coke', 1)
					HarvestCoke(source)
				end

			end)

		end
	end)
end

RegisterServerEvent('esx_cokejob:startHarvestCoke')
AddEventHandler('esx_cokejob:startHarvestCoke', function()

	PlayersHarvesting[source] = true

	TriggerClientEvent('esx_cokejob:showNotification', source, '~y~Ramassage en cours~s~...')

	HarvestCoke(source)

end)

RegisterServerEvent('esx_cokejob:stopHarvestCoke')
AddEventHandler('esx_cokejob:stopHarvestCoke', function()

	PlayersHarvesting[source] = false

end)

local function TransformCoke(source)

	if CopsConnected < Config.RequiredCops then
		TriggerClientEvent('esx_weedjob:showNotification', source, 'Action ~r~impossible~s~, ~b~policiers~s~: ' .. CopsConnected .. '/' .. Config.RequiredCops)
		return
	end

	SetTimeout(5000, function()

		if PlayersTransforming[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local cokeQuantity = xPlayer:getInventoryItem('coke').count

				if cokeQuantity < 5 then
					TriggerClientEvent('esx_cokejob:showNotification', source, 'Vous n\'avez pas assez de feuille de coca à ~r~conditionner~s~')
				else
					xPlayer:removeInventoryItem('coke', 7)
					xPlayer:addInventoryItem('coke_pooch', 8)
				
					TransformCoke(source)
				end

			end)

		end
	end)
end

RegisterServerEvent('esx_cokejob:startTransformCoke')
AddEventHandler('esx_cokejob:startTransformCoke', function()

	PlayersTransforming[source] = true

	TriggerClientEvent('esx_cokejob:showNotification', source, '~y~Conditonnement en cours~s~...')

	TransformCoke(source)

end)

RegisterServerEvent('esx_cokejob:stopTransformCoke')
AddEventHandler('esx_cokejob:stopTransformCoke', function()

	PlayersTransforming[source] = false

end)

local function SellCoke(source)

	if CopsConnected < Config.RequiredCops then
		TriggerClientEvent('esx_weedjob:showNotification', source, 'Action ~r~impossible~s~, ~b~policiers~s~: ' .. CopsConnected .. '/' .. Config.RequiredCops)
		return
	end

	SetTimeout(7500, function()

		if PlayersSelling[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local poochQuantity = xPlayer:getInventoryItem('coke_pooch').count

				if poochQuantity == 0 then
					TriggerClientEvent('esx_cokejob:showNotification', source, 'Vous n\'avez plus de pochons à ~r~vendre~s~')
				else
					xPlayer:removeInventoryItem('coke_pooch', 1)
					xPlayer:addAccountMoney('black_money', 750)
				
					SellCoke(source)
				end

			end)

		end
	end)
end

RegisterServerEvent('esx_cokejob:startSellCoke')
AddEventHandler('esx_cokejob:startSellCoke', function()

	PlayersSelling[source] = true

	TriggerClientEvent('esx_cokejob:showNotification', source, '~g~Vente en cours~s~...')

	SellCoke(source)

end)

RegisterServerEvent('esx_cokejob:stopSellCoke')
AddEventHandler('esx_cokejob:stopSellCoke', function()

	PlayersSelling[source] = false

end)