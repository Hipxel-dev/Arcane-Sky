extends CanvasLayer

enum shopstate {
	NOTACTIVE
	MAIN,
	RESOURCES,
	UPGRADES,
	BUFF
}

var current_state = shopstate.MAIN
