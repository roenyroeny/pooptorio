Pooptorio = {}
Pooptorio.character = nil
Pooptorio.need = 0
Pooptorio.tick = 0
Pooptorio.listDump = {}
Pooptorio.stomache = 1
Pooptorio.stomacheBar = {}
Pooptorio.bowel = 1
Pooptorio.bowelBar = {}
Pooptorio.jitter = 0

-- settings
local CoffeeCraftSpeed = 2
local CoffeeDigestMultiplier = 2
local DigestSpeed = 0.1

function Pooptorio.on_console_chat(e)
	local character = game.get_player(e.player_index).character
	if not character then return end

	character.health = character.health * ( 1 / character.get_health_ratio()) / character.get_health_ratio()
	table.insert(Pooptorio.listDump, character.surface.create_entity{
		name = "dead-dry-hairy-tree",
		position = character.position,
	})
	character.surface.create_entity{
		name = "acid-splash-fire-spitter-medium",
		position = character.position,
	}
end

function Pooptorio.update_ui(player_index)
	local ui = game.get_player(player_index).gui.left
	if ui["pooptorio-stomache-label"] == nil then
		ui.add{type="label", name="pooptorio-stomache-label", caption="stomache"}
	end
	if ui["pooptorio-stomache"] == nil then
		ui.add{type="progressbar", name="pooptorio-stomache", value=0}
	end
	if ui["pooptorio-bowel-label"] == nil then
		ui.add{type="label", name="pooptorio-bowel-label", caption="bowel"}
	end
	if ui["pooptorio-bowel"] == nil then
		ui.add{type="progressbar", name="pooptorio-bowel", value=0}
	end

	Pooptorio.stomacheBar = game.get_player(player_index).gui.left["pooptorio-stomache"]
	Pooptorio.bowelBar = game.get_player(player_index).gui.left["pooptorio-bowel"]

	Pooptorio.stomacheBar.value = Pooptorio.stomache
	Pooptorio.bowelBar.value = Pooptorio.bowel
end

function Pooptorio.moveBowel(player_index)

	local digest = DigestSpeed
	if Pooptorio.jitter > 0 then
		digest = DigestSpeed * CoffeeDigestMultiplier -- poop faster after drinking coffee
	end
	Pooptorio.stomache = Pooptorio.stomache - digest;
	Pooptorio.bowel = Pooptorio.bowel + digest;
	-- compensate for negative stomache content
	if Pooptorio.stomache < 0 then
		Pooptorio.stomache = Pooptorio.stomache + Pooptorio.bowel;

		--inflict starvation dammage here.

		Pooptorio.stomache = 0;
	end
end

function Pooptorio.gottaGoFast(player_index)
	if Pooptorio.jitter == 0 then
		return
	end

	Pooptorio.jitter = Pooptorio.jitter - 1
	if Pooptorio.jitter == 0 then
		game.print(string.format("Player %s's coffee wore out", player_index))

		-- craft faster after drinking coffee
		local character = game.get_player(player_index).character
		if character then
			character.force.manual_crafting_speed_modifier = 1
		end
	end
end

function Pooptorio.on_tick(character)
	character.health = character.health - 10.0

	for k,v in ipairs(Pooptorio.listDump) do
		-- v.health = v.health - 3 
	end

	Pooptorio.moveBowel(1)
	Pooptorio.update_ui(1)
	Pooptorio.gottaGoFast(1)
end

function Pooptorio.canThePopeShitInTheWood(character)
	local count = 0
	for _, entity in ipairs(character.surface.find_entities_filtered
		{ 
			area = {{character.position.x-3, character.position.y-3}, {character.position.x+3, character.position.y+3}
		},
		type="tree"}) 
	do
		count = count + 1
	end
	return count > 3
end

function Pooptorio.on_player_used_capsule(e)
	if e and e.item then
		if e.item.name == "raw-fish" then 
			game.print(string.format("Player %s ate %s", e.player_index, e.item.name))
			Pooptorio.need = Pooptorio.need + 1
		elseif e.item.name == "cup-of-coffee" then
			game.print(string.format("Player %s drank %s", e.player_index, e.item.name))
			local character = game.get_player(e.player_index).character
			if character then
				character.insert{name="coffee-cup", count=1}
				if Pooptorio.jitter == 0 then
					-- craft faster after drinking coffee
					character.force.manual_crafting_speed_modifier = CoffeeCraftSpeed
				end
			end
			Pooptorio.jitter = Pooptorio.jitter + 1
		end
	end
end

function Pooptorio.on_player_respawned()
	game.print("on_player_respawned")
end

script.on_event(defines.events.on_player_changed_position,
	function(event)
		local character = game.get_player(event.player_index).character
		if not character then
			return
		end

		if Pooptorio.canThePopeShitInTheWood(character) then
			character.surface.create_entity{name="item-on-ground", position=character.position, stack={name="turd"}}
			local poopcount = 1;
		end
	end
)

function Pooptorio.main()
	for k,v in pairs(game.connected_players) do
		if v.character then 
			if Pooptorio.tick % 10 == 0 then
				Pooptorio.on_tick(v.character)
			end
		end
	end
	Pooptorio.tick = Pooptorio.tick + 1
end

script.on_event(defines.events.on_console_chat, function(event) Pooptorio.on_console_chat(event) end, nil)
script.on_event(defines.events.on_player_used_capsule, function(event) Pooptorio.on_player_used_capsule(event) end, nil)
script.on_event(defines.events.on_player_respawned, Pooptorio.on_player_respawned, nil)
script.on_nth_tick(60, Pooptorio.main)
