local Coffee = require("coffee")
local Skitnoedig = require("skitnoedig")
local poopUI = require("poopUI")
local utils = require("utils")

-- mod settings
local Pooptorio = {}
Pooptorio.tick = 0

-- per player settings
local PoopSettings = {}
PoopSettings.coffeeCraftSpeed = nil
PoopSettings.coffeeDigestMultiplier = nil
PoopSettings.digestSpeed = nil
PoopSettings.need = 0
PoopSettings.listDump = {}
PoopSettings.stomache = 1
PoopSettings.stomacheFull = 5
PoopSettings.stomacheBar = {}
PoopSettings.bowel = 5
PoopSettings.bowelFull = 6
PoopSettings.bowelBar = {}
PoopSettings.jitter = 0

local PoopSettingsTable = {}
function PoopSettingsTable.RegisterPlayer(player_index)
	if PoopSettingsTable[player_index] == nil then
		-- store a copy of PoopSettings in this table for every player
		PoopSettingsTable[player_index] = utils.deepcopy(PoopSettings)
	end
end

function Pooptorio.on_tick(character, settings)
	local player_index = character.player.index
	-- character.health = character.health - 10.0

	for k,v in ipairs(settings.listDump) do
		-- v.health = v.health - 3 
	end

	Skitnoedig.moveBowel(player_index, settings)
	poopUI.update_ui(player_index, settings)
	Coffee.gottaGoFast(player_index, settings)
end

function Pooptorio.on_runtime_mod_setting_changed()
	local coffeeCraft = settings.global["coffee-craft-speed"].value
	if coffeeCraft then
		PoopSettings.coffeeCraftSpeed = coffeeCraft
	end

	local coffeeDigest = settings.global["coffee-digest-multiplier"].value
	if coffeeDigest then
		PoopSettings.coffeeDigestMultiplier = coffeeDigest
	end

	local digest = settings.global["digest-speed"].value
	if digest then
		PoopSettings.digestSpeed = digest
	end
end

function Pooptorio.main(pst)
	if CoffeeCraftSpeed == nil then
		Pooptorio.on_runtime_mod_setting_changed()
	end

	for k,v in pairs(game.connected_players) do
		if v.character then 
			if Pooptorio.tick % 10 == 0 then
				if not pst[v.index] then
					pst.RegisterPlayer(v.index)
				end

				Pooptorio.on_tick(v.character, pst[v.index])
			end
		end
	end
	Pooptorio.tick = Pooptorio.tick + 1
end

-- Pooptorio.lua
script.on_event(defines.events.on_player_joined_game, function(event) PoopSettingsTable.RegisterPlayer(event.player_index) end, nil)
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event) Pooptorio.on_runtime_mod_setting_changed() end, nil)
script.on_nth_tick(60, function() Pooptorio.main(PoopSettingsTable) end)


-- Skitnoedig.lua
script.on_event(defines.events.on_player_used_capsule, function(event) Skitnoedig.on_player_used_capsule(event, PoopSettingsTable, poopUI) end, nil)
script.on_event(defines.events.on_console_chat, function(event) Skitnoedig.on_console_chat(event, PoopSettingsTable) end, nil)
script.on_event(defines.events.on_player_changed_position, function(event) Skitnoedig.on_player_changed_position(event, PoopSettingsTable, poopUI) end )


