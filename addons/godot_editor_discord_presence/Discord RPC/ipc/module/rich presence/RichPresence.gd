class_name RichPresence

# warning-ignore-all:narrowing_conversion

const RichPresenceButton: Script = preload("./RichPresenceButton.gd")

var state: String
var details: String
var start_timestamp: int
var end_timestamp: int
var large_image_key: String
var large_image_text: String
var small_image_key: String
var small_image_text: String
var party_id: String
var party_size: int : set = set_party_size
var party_max: int : set = set_party_max
var match_secret: String
var join_secret: String
var spectate_secret: String
var first_button: RichPresenceButton
var second_button: RichPresenceButton
var instance: bool = true

func set_party_size(size: int) -> void:
	party_size = clamp(size, 0, self.party_max)

func set_party_max(value: int) -> void:
	party_max = max(0, value)
	# Esnure that the party size is always in the correct range
	self.party_size = party_size

func to_dict() -> Dictionary:
	var data: Dictionary = {"instance": self.instance}
	
	if (not self.state.is_empty()):
		data["state"] = self.state
	if (not self.details.is_empty()):
		data["details"] = self.details
	
	var timestamps: Dictionary = {}
	if (self.start_timestamp > 0):
		timestamps["start"] = self.start_timestamp
	if (self.end_timestamp > 0):
		timestamps["end"] = self.end_timestamp
	if (not timestamps.is_empty()):
		data["timestamps"] = timestamps
	
	var assets: Dictionary = {}
	if (not self.large_image_key.is_empty()):
		assets["large_image"] = self.large_image_key	
	if (not self.large_image_text.is_empty()):
		assets["large_text"] = self.large_image_text
	if (not self.small_image_key.is_empty()):
		assets["small_image"] = self.small_image_key
	if (not self.small_image_text.is_empty()):
		assets["small_text"] = self.small_image_text
	if (not assets.is_empty()):
		data["assets"] = assets
	
	var secrets: Dictionary = {}
	if (not self.join_secret.is_empty()):
		secrets["join"] = self.join_secret
	if (not self.spectate_secret.is_empty()):
		secrets["spectate"] = self.spectate_secret
	if (not self.match_secret.is_empty()):
		secrets["instanced_match"] = self.match_secret
	if (not secrets.is_empty()):
		data["secrets"] = secrets
	
	var party: Dictionary = {}
	if (not self.party_id.is_empty()):
		party["id"] = self.party_id
	if (self.party_max > 0):
		party["size"] = [self.party_size, self.party_max]
	data["party"] = party
	
	var buttons: Array = []
	if (first_button):
		buttons.append(first_button.to_dict())
	if (second_button):
		buttons.append(second_button.to_dict())
	if (not buttons.is_empty()):
		data["buttons"] = buttons
	
	return data
