local Coffee = require("coffee")
local Skitnoedig = require("skitnoedig")
local poopUI = require("poopUI")

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
PoopSettings.stomacheBar = {}
PoopSettings.bowel = 1
PoopSettings.bowelBar = {}
PoopSettings.jitter = 0

function Pooptorio.on_tick(character, poopSettings)
	character.health = character.health - 10.0

	for k,v in ipairs(PoopSettings.listDump) do
		-- v.health = v.health - 3 
	end

	Skitnoedig.moveBowel(1, poopSettings)
	poopUI.update_ui(1, poopSettings)
	Coffee.gottaGoFast(1, poopSettings)
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

function Pooptorio.main()
	if CoffeeCraftSpeed == nil then
		Pooptorio.on_runtime_mod_setting_changed()
	end

	for k,v in pairs(game.connected_players) do
		if v.character then 
			if Pooptorio.tick % 10 == 0 then
				Pooptorio.on_tick(v.character, PoopSettings)
			end
		end
	end
	Pooptorio.tick = Pooptorio.tick + 1
end

-- Pooptorio.lua
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event) Pooptorio.on_runtime_mod_setting_changed() end, nil)
script.on_nth_tick(60, Pooptorio.main)

-- Skitnoedig.lua
script.on_event(defines.events.on_player_used_capsule, function(event) Skitnoedig.on_player_used_capsule(event, PoopSettings) end, nil)
script.on_event(defines.events.on_console_chat, function(event) Skitnoedig.on_console_chat(event, PoopSettings) end, nil)
