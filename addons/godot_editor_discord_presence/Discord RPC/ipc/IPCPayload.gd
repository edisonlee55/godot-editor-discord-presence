enum OpCodes {
	HANDSHAKE,
	FRAME,
	CLOSE,
	PING,
	PONG
}

const UUID: Script = preload("../util/UUID.gd")
const DiscordRPCUtil = preload("../RPC.gd")

var op_code: int = OpCodes.PING
var nonce: String
var command: String
var event: String
var data: Dictionary
var arguments: Dictionary

func _init() -> void:
	self.generate_nonce()

func generate_nonce() -> void:
	self.nonce = UUID.v4()

func is_error() -> bool:
	return event == DiscordRPCUtil.Events.ERROR

func get_error_code() -> int:
	var code: int
	if (self.is_error()):
		code = self.data["code"]
	return code

func get_error_messsage() -> String:
	var message: String
	if (self.is_error()):
		message = self.data["message"]
	return message

func to_dict() -> Dictionary:
	return {
		nonce = self.nonce,
		cmd = self.command,
		# warning-ignore:incompatible_ternary
		evt = self.event if not self.event.is_empty() else null,
		data = self.data,
		args = self.arguments
	}

func to_bytes() -> PackedByteArray:
	var buffer: PackedByteArray = JSON.new().stringify(self.to_dict()).to_utf8_buffer()
	var stream: StreamPeerBuffer = StreamPeerBuffer.new()
	stream.put_32(self.op_code)
	stream.put_32(buffer.size())
	# warning-ignore:return_value_discarded
	stream.put_data(buffer)
	return stream.data_array

func _to_string() -> String:
	return ("op_code: %d\n" % op_code) + JSON.stringify(to_dict(), "\t")
