extends CanvasLayer

var coins = 0

func _ready():
	$CanPanel/Coinslabel.text = String(coins)

func _on_Player_item_collected(item_type):
	if item_type == "Coin":
		coins += 1
		$CanPanel/Coinslabel.text = String(coins)

func _on_Player_health_left(health_left):
	$HealthPanel/Health.text = String(health_left)
