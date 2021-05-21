extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var money_makers = get_tree().get_nodes_in_group("money_maker")
	
	for maker in money_makers:
		maker.connect("gain_coins", self, "gain_coins")


func gain_coins(coins):
	AutoVars.current_coins += coins
	$Coins.bbcode_text = "[shake]" + str(AutoVars.current_coins) + "[/shake]"


func lose_coins(coins):
	AutoVars.current_coins -= coins
	$Coins.bbcode_text = "[shake]" + str(AutoVars.current_coins) + "[/shake]"
