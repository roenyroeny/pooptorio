local Skitnoedig = {}

function Skitnoedig.on_console_chat(e, poopSettings)
	local character = game.get_player(e.player_index).character
	if not character then return end

	character.health = character.health * ( 1 / character.get_health_ratio()) / character.get_health_ratio()
	table.insert(poopSettings.listDump, character.surface.create_entity{
		name = "dead-dry-hairy-tree",
		position = character.position,
	})
	character.surface.create_entity{
		name = "acid-splash-fire-spitter-medium",
		position = character.position,
	}
end

function Skitnoedig.moveBowel(player_index, poopSettings)
	local digest = poopSettings.digestSpeed
	if poopSettings.jitter > 0 then
		-- poop faster after drinking coffee
		digest = poopSettings.digestSpeed * poopSettings.coffeeDigestMultiplier
	end
	
	poopSettings.stomache = poopSettings.stomache - digest;
	poopSettings.bowel = poopSettings.bowel + digest;
	-- compensate for negative stomache content
	if poopSettings.stomache < 0 then
		poopSettings.stomache = poopSettings.stomache + poopSettings.bowel;

		--inflict starvation dammage here.

		poopSettings.stomache = 0;
	end
end

function Skitnoedig.canThePopeShitInTheWood(character)
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

function Skitnoedig.on_player_changed_position(e)
    local character = game.get_player(e.player_index).character
		if not character then
			return
		end

		if Skitnoedig.canThePopeShitInTheWood(character) then
			character.surface.create_entity{name="item-on-ground", position=character.position, stack={name="turd"}}
			local poopcount = 1;
		end
end

function Skitnoedig.on_player_used_capsule(e, poopSettings)
	if e and e.item then
		if e.item.name == "raw-fish" then 
			game.print(string.format("Player %s ate %s", e.player_index, e.item.name))
			poopSettings.need = poopSettings.need + 1
		elseif e.item.name == "cup-of-coffee" then
			game.print(string.format("Player %s drank %s", e.player_index, e.item.name))
			local character = game.get_player(e.player_index).character
			if character then
				character.insert{name="coffee-cup", count=1}
				if poopSettings.jitter == 0 then
					-- craft faster after drinking coffee
					character.force.manual_crafting_speed_modifier = poopSettings.coffeeCraftSpeed
				end
			end
			poopSettings.jitter = poopSettings.jitter + 1
		end
	end
end

-- Skitnoedig
script.on_event(defines.events.on_player_changed_position, function(event) Skitnoedig.on_player_changed_position(event) end )

return Skitnoedig