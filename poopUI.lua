local PoopUI = {}

function PoopUI.update_ui(player_index, poopSettings)
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

	poopSettings.stomacheBar = game.get_player(player_index).gui.left["pooptorio-stomache"]
	poopSettings.bowelBar = game.get_player(player_index).gui.left["pooptorio-bowel"]

	poopSettings.stomacheBar.value = poopSettings.stomache
	poopSettings.bowelBar.value = poopSettings.bowel
end

return PoopUI