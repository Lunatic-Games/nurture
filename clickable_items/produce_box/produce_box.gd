extends Node2D

signal gain_coins

func handle_plant(plant):
	trade_produce(plant)


func trade_produce(plant):
	# Caught by the money manager
	emit_signal("gain_coins", plant.gold_dropped)
