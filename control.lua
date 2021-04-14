

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


    --- game.player.gui.top.add{type="label", name="greeting2", caption="meowmeow"}