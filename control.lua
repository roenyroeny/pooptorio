Pooptorio = {}
Pooptorio.character = nil
Pooptorio.need = 0
Pooptorio.tick = 0
Pooptorio.listDump = {}
Pooptorio.stomache = 1
Pooptorio.stomacheBar = {}
Pooptorio.bowel = 1
Pooptorio.bowelBar = {}

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

	local digest = 0.1
	Pooptorio.stomache = Pooptorio.stomache - digest;
	Pooptorio.bowel = Pooptorio.bowel + digest;
	-- compensate for negative stomache content
	if Pooptorio.stomache < 0 then
		Pooptorio.stomache = Pooptorio.stomache + Pooptorio.bowel;

		--inflict starvation dammage here.

		Pooptorio.stomache = 0;
	end
end

function Pooptorio.on_tick(player)
	if player.character then
		player.character.health = player.character.health - 10.0
	end

	if not Pooptorio.character then
		if game.get_player(1) and game.get_player(1).character then
			Pooptorio.character = game.get_player(1).character
		else
			game.print("no character")
			return
		end
	else
		if not Pooptorio.character then
			return
		end
		-- Pooptorio.character.health = Pooptorio.character.health - 10.0  
		-- time = time + 1
	end

	for k,v in ipairs(Pooptorio.listDump) do
		-- v.health = v.health - 3 
	end

	Pooptorio.moveBowel(1)
	Pooptorio.update_ui(1)
end

function Pooptorio.canThePopeShitInTheWood(player)
	local count = 0
	for _, entity in ipairs(player.surface.find_entities_filtered
		{ 
			area = {{player.position.x-3, player.position.y-3}, {player.position.x+3, player.position.y+3}
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
		end
	end
end

function Pooptorio.on_player_respawned()
	game.print("on_player_respawned")
end

script.on_event(defines.events.on_player_changed_position,
  function(event)
    local player = game.get_player(event.player_index) -- get the player that moved            
    -- if they're wearing our armor
      -- create the fire where they're standing

      if Pooptorio.canThePopeShitInTheWood(player) then
      	player.surface.create_entity{name="item-on-ground", position=player.position, stack={name="turd"}}
      	local poopcount = 1;
	  end
  end
)

function Pooptorio.main()
	for k,v in pairs(game.connected_players) do
		if Pooptorio.tick % 6 == 0 then
			Pooptorio.on_tick(v)
		end
	end
	Pooptorio.tick = Pooptorio.tick + 1
end

script.on_event(defines.events.on_console_chat, function(event) Pooptorio.on_console_chat(event) end, nil)
script.on_event(defines.events.on_player_used_capsule, function(event) Pooptorio.on_player_used_capsule(event) end, nil)
script.on_event(defines.events.on_player_respawned, Pooptorio.on_player_respawned, nil)
script.on_nth_tick(100, Pooptorio.main)
