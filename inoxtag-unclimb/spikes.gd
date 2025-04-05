extends StaticBody2D
@export var type : int

func _ready():
	if type == 0: #On choisit le Snowy_Spikes
		$Cavern_Spikes.hide()
	else: #On choisit le Cavern Spikes
		$Snowy_Spikes.hide()
	pass
