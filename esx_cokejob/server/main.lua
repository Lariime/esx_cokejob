local PlayersHarvesting   = {}
local PlayersTransforming = {}
local PlayersSelling      = {}

local function HarvestCoke(source)

	SetTimeout(5000, function()

		if PlayersHarvesting[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local cokeQuantity = xPlayer:getInventoryItem('coke').count

				if cokeQuantity == 60 then
					TriggerClientEvent('esx_cokejob:showNotification', source, 'Vous ne pouvez plus ramasser de feuille de coca, votre inventaire est plein')
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

	TriggerClientEvent('esx_cokejob:showNotification', source, 'Ramassage en cours...')

	HarvestCoke(source)

end)

RegisterServerEvent('esx_cokejob:stopHarvestCoke')
AddEventHandler('esx_cokejob:stopHarvestCoke', function()

	PlayersHarvesting[source] = false

end)

local function TransformCoke(source)

	SetTimeout(5000, function()

		if PlayersTransforming[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local cokeQuantity = xPlayer:getInventoryItem('coke').count

				if cokeQuantity < 5 then
					TriggerClientEvent('esx_cokejob:showNotification', source, 'Vous n\'avez pas assez de feuille de coca à conditionner')
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

	TriggerClientEvent('esx_cokejob:showNotification', source, 'Conditonnement en cours...')

	TransformCoke(source)

end)

RegisterServerEvent('esx_cokejob:stopTransformCoke')
AddEventHandler('esx_cokejob:stopTransformCoke', function()

	PlayersTransforming[source] = false

end)

local function SellCoke(source)

	SetTimeout(10000, function()

		if PlayersSelling[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local poochQuantity = xPlayer:getInventoryItem('coke_pooch').count

				if poochQuantity == 0 then
					TriggerClientEvent('esx_cokejob:showNotification', source, 'Vous n\'avez plus de pochons à vendre')
				else
					xPlayer:removeInventoryItem('coke_pooch', 8)
					xPlayer:addAccountMoney('black_money', 80)
				
					SellCoke(source)
				end

			end)

		end
	end)
end

RegisterServerEvent('esx_cokejob:startSellCoke')
AddEventHandler('esx_cokejob:startSellCoke', function()

	PlayersSelling[source] = true

	TriggerClientEvent('esx_cokejob:showNotification', source, 'Vente en cours...')

	SellCoke(source)

end)

RegisterServerEvent('esx_cokejob:stopSellCoke')
AddEventHandler('esx_cokejob:stopSellCoke', function()

	PlayersSelling[source] = false

end)