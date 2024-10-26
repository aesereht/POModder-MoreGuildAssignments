extends Node

const MYMODNAME_LOG = "POModder-MoreGuildAssignments"
const MYMODNAME_MOD_DIR = "POModder-MoreGuildAssignments/"


var cooldown : float = 1.0
var in_game = false
var map_node = null

var dir = ""
var ext_dir = ""
var trans_dir = ""

var overwrites_dir = "res://mods-unpacked/POModder-MoreGuildAssignments/overwrites/"

func _init():
	ModLoaderLog.info("Init", MYMODNAME_LOG)
	dir = ModLoaderMod.get_unpacked_dir() + MYMODNAME_MOD_DIR
	ext_dir = dir + "extensions/"
	trans_dir = dir + "translations/"
	for loc in ["en" , "es" , "fr"]:
		ModLoaderMod.add_translation(trans_dir + "translations." + loc + ".translation")

func _ready():
	ModLoaderLog.info("Done", MYMODNAME_LOG)
	add_to_group("mod_init")

	
func modInit():

	# Just extending scripts
	ModLoaderMod.install_script_extension(ext_dir + "Achievement_MINE_ALL.gd")
	ModLoaderMod.install_script_extension(ext_dir + "AssignmentDisplay.gd")
	ModLoaderMod.install_script_extension(ext_dir + "TileDataGenerator.gd")

	# Loading assigments
	var pathToModYaml : String = "res://mods-unpacked/POModder-MoreGuildAssignments/yaml/assignments-complete.yaml"
	Data.parseAssignmentYaml(pathToModYaml)

	# Hooking to level_ready
	StageManager.connect("level_ready", _on_level_ready)

	# Adding new archtypes
	manage_overwrites()	

	# Loading nes scene and adding it as child to Stage Manager (To look what it contains, also to check if Stage Manager does not autoclean childs)
	var stage_manager_extender = preload("res://mods-unpacked/POModder-MoreGuildAssignments/content/StageManagerExtenderMap/StageManagerExtenderMap.tscn").instantiate()
	get_tree().get_root().find_child("StageManager",false,false).add_child(stage_manager_extender)
	
# Called when the node enters the scene tree for the first time.
func manage_overwrites():
	var new_archetype = preload("res://mods-unpacked/POModder-MoreGuildAssignments/maparchetypes/assignment-detonators.tres")
	new_archetype.take_over_path("res://content/map/generation/archetypes/assignment-detonators.tres")

	var new_archetype2 = preload("res://mods-unpacked/POModder-MoreGuildAssignments/maparchetypes/assignment-aprilfools.tres")
	new_archetype2.take_over_path("res://content/map/generation/archetypes/assignment-aprilfools.tres")
	
	
func _on_level_ready():
	# Check for new assigment thieves to load drop_bearer_manger
	if Data.of("assignment.id") is String and Data.of("assignment.id") == "thieves":
		var drop_bearer_manager = preload("res://mods-unpacked/POModder-MoreGuildAssignments/content/drop_bearer/drop_bearer_manager.tscn").instantiate()
		get_tree().get_root().get_child(13).map.add_child(drop_bearer_manager)
