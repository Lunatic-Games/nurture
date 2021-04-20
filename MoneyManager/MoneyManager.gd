extends Control

onready var current_coins = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	var money_makers = get_tree().get_nodes_in_group("money_maker")
	
	for maker in money_makers:
		maker.connect("gain_coins", self, "gain_coins")


func gain_coins(coins):
	print("gaining coins")
	current_coins += coins
	$Coins.bbcode_text = "[shake]" + str(current_coins) + "[/shake]"
