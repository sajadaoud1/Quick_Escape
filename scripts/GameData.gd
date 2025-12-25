extends Node

var unlocked_levels: int = 2

func unlock_next_level(currunt_level:int):
	if currunt_level >= unlocked_levels:
		unlocked_levels += 1
	
