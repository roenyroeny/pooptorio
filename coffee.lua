local Coffee = {}

function Coffee.gottaGoFast(player_index, poopSettings)
	if poopSettings.jitter == 0 then
		return
	end

	poopSettings.jitter = poopSettings.jitter - 1
	if poopSettings.jitter == 0 then
		game.print(string.format("Player %s's coffee wore out", player_index))

		-- craft faster after drinking coffee
		local character = game.get_player(player_index).character
		if character then
			character.force.manual_crafting_speed_modifier = 1
		end
	end
end

return Coffee