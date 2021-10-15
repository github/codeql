//This condition is too complex and can be improved by using local variables
bool accept_message =
	(message_type == CONNECT && _state != CONNECTED) ||
	(message_type == DISCONNECT && _state == CONNECTED) ||
	(message_type == DATA && _state == CONNECTED);

//This condition is acceptable, as all the logical operators are of the same type (&&)
bool valid_connect =
	message_type == CONNECT && 
	_state != CONNECTED &&
	time_since_prev_connect > MAX_CONNECT_INTERVAL &&
	message_length <= MAX_PACKET_SIZE &&
	checksum(message) == get_checksum_field(message);