Pooptorio = {}
Pooptorio.character = nil
Pooptorio.need = 0
Pooptorio.tick = 0
Pooptorio.listDump = {}

function Pooptorio.on_console_chat()
	if Pooptorio.character then
		Pooptorio.character.health = Pooptorio.character.health * ( 1 / Pooptorio.character.get_health_ratio()) / Pooptorio.character.get_health_ratio()
		table.insert(Pooptorio.listDump, Pooptorio.character.surface.create_entity{
			name = "dead-dry-hairy-tree",
			position = Pooptorio.character.position,
		})
		Pooptorio.character.surface.create_entity{
			name = "acid-splash-fire-spitter-medium",
			position = Pooptorio.character.position,
		}
	end
end

function Pooptorio.on_tick()
	Pooptorio.character.health = Pooptorio.character.health - 10.0

	for k,v in ipairs(Pooptorio.listDump) do
		v.health = v.health - 3 
	end
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
	Pooptorio.character = nil
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

function GetCharacter()
	if Pooptorio.character then
		return true
	else if not Pooptorio.character then
		if game.get_player(1) and game.get_player(1).character then
			Pooptorio.character = game.get_player(1).character
			return true
		else
			game.print("no character")
		end
	end
	return false
end

function Pooptorio.main()
	if Pooptorio.GetCharacter() then
		if tick % 6 = 0 then
			Pooptorio.on_tick()
		end
	end
	tick = tick + 1
end

script.on_event(defines.events.on_console_chat, Pooptorio.on_console_chat, nil)
script.on_event(defines.events.on_player_used_capsule, function(event) Pooptorio.on_player_used_capsule(event) end, nil)
script.on_event(defines.events.on_player_respawned, Pooptorio.on_player_respawned, nil)
script.on_nth_tick(600, Pooptorio.on_tick)
script.on_nth_tick(100, Pooptorio.main)

    --- game.player.gui.top.add{type="label", name="greeting2", caption="meowmeow"}