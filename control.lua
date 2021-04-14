character = nil;
need = 0;
time = 0;
listDump = {}

function on_console_chat()
	if character then
		character.health = character.health * ( 1 / character.get_health_ratio()) / character.get_health_ratio()
		table.insert(listDump, character.surface.create_entity{
			name = "dead-dry-hairy-tree",
			position = character.position,
		})
		character.surface.create_entity{
			name = "acid-splash-fire-spitter-medium",
			position = character.position,
		}
	end
end

function on_tick()
	if not character then
		if game.get_player(1) and game.get_player(1).character then
			character = game.get_player(1).character
		else
			game.print("no character")
			return
		end
	else
		if not character then
			return
		end
		character.health = character.health - 10.0  
		-- time = time + 1
	end

	for k,v in ipairs(listDump) do
		v.health = v.health - 3 
	end
end

function canThePopeShitInTheWood(player)
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

function on_player_used_capsule(e)
	if e and e.item then
		if e.item.name == "raw-fish" then 
			game.print(string.format("Player %s ate %s", e.player_index, e.item.name))
			need = need + 1
		end
	end
	--game.print("on_player_used_capsule")
end
function on_player_respawned()
	game.print("on_player_respawned")
	character = nil
end

script.on_event(defines.events.on_player_changed_position,
  function(event)
    local player = game.get_player(event.player_index) -- get the player that moved            
    -- if they're wearing our armor
      -- create the fire where they're standing


      if canThePopeShitInTheWood(player) then
      	player.surface.create_entity{name="item-on-ground", position=player.position, stack={name="turd"}}

      	local poopcount = 1;
	  end
  end
)

script.on_event(defines.events.on_console_chat, on_console_chat, nil)
script.on_event(defines.events.on_player_used_capsule, function(event) on_player_used_capsule(event) end, nil)
script.on_event(defines.events.on_player_respawned, on_player_respawned, nil)
script.on_nth_tick(600, on_tick)

    --- game.player.gui.top.add{type="label", name="greeting2", caption="meowmeow"}