extends Node

func load_file(file_number: int) -> Array:
	var path = "res://Questions/election_data_" + str(file_number) + ".json"
	
	# 1. Fixed typo: "FileAcces" -> "FileAccess"
	if not FileAccess.file_exists(path):
		print("File does not exist: ", path)
		return []
	
	# 2. Open and read the file
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()

	# 3. Parse the JSON
	var json = JSON.new()
	var error = json.parse(content)
	
	if error == OK:
		# In Godot 4, the data is stored in the .data property of the JSON object
		var data = json.data
		if data is Array:
			return data
		else:
			print("Error: JSON content is not an Array")
			return []
	else:
		print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())
		return []
