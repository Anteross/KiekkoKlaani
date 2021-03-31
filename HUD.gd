extends CanvasLayer

var coins = 0

func _ready():
	$Panel/Coinslabel.text = String(coins)

func _on_Player_item_collected(item_type):
	if item_type == "Coin":
		coins += 1
		$Panel/Coinslabel.text = String(coins)
