local Skitnoedig = {}

function Skitnoedig.on_console_chat(e, pst)
	local character = game.get_player(e.player_index).character
	if not character then return end

	character.health = character.health * ( 1 / character.get_health_ratio()) / character.get_health_ratio()
	table.insert(pst[e.player_index].listDump, character.surface.create_entity{
		name = "dead-dry-hairy-tree",
		position = character.position,
	})
	character.surface.create_entity{
		name = "acid-splash-fire-spitter-medium",
		position = character.position,
	}
end

function Skitnoedig.moveBowel(player_index, settings)
	local digest = settings.digestSpeed
    local character = game.get_player(player_index).character
	if settings.jitter > 0 then
		-- poop faster after drinking coffee
		digest = settings.digestSpeed * settings.coffeeDigestMultiplier
	end
	
	settings.stomache = settings.stomache - digest;
	settings.bowel = settings.bowel + digest;
	-- compensate for negative stomache content
	if settings.stomache < 0 then
		settings.stomache = settings.stomache + settings.bowel;

		--inflict starvation dammage here.
        character.damage(15.0, "player", "physical", character)

		settings.stomache = 0;
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

function Skitnoedig.on_player_changed_position(e, pst, ui)
    local character = game.get_player(e.player_index).character
    if not character then
        return
    end

    if Skitnoedig.canThePopeShitInTheWood(character) and pst[e.player_index].bowel > 0 then
        character.surface.create_entity{name="item-on-ground", position=character.position, stack={name="turd"}}
        pst[e.player_index].bowel = pst[e.player_index].bowel - 1
        ui.update_ui(e.player_index, pst[e.player_index])
    end
end

function Skitnoedig.on_player_used_capsule(e, pst, ui)
    if e.item.name == "raw-fish" then 
        game.print(string.format("Player %s ate %s", e.player_index, e.item.name))
        pst[e.player_index].stomache = pst[e.player_index].stomache + 1
        ui.update_ui(e.player_index, pst[e.player_index])
    elseif e.item.name == "cup-of-coffee" then
        game.print(string.format("Player %s drank %s", e.player_index, e.item.name))
        local character = game.get_player(e.player_index).character
        if character then
            character.insert{name="coffee-cup", count=1}
            if pst[e.player_index].jitter == 0 then
                -- craft faster after drinking coffee
                character.force.manual_crafting_speed_modifier = pst[e.player_index].coffeeCraftSpeed
            end
        end
        pst[e.player_index].jitter = pst[e.player_index].jitter + 1
    end	
end

return Skitnoedig