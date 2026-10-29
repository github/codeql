//This switch statement has long case statements, and can become difficult to
//read as the processing for each message type becomes more complex
switch (message_type) {
	case CONNECT:
		_state = CONNECTING;
		int message_id = message_get_id(message);
		int source = connect_get_source(message);
		//More code here...
		send(connect_response);
		break;
	case DISCONNECT:
		_state = DISCONNECTING;
		int message_id = message_get_id(message);
		int source = disconnect_get_source(message);
		//More code here...
		send(disconnect_response);
		break;
	default:
		log("Invalid message, id : %d", message_get_id(message));
}

//This is better, as each case is split out to a separate function
switch (packet_type) {
	case STREAM:
		process_stream_packet(packet);
		break;
	case DATAGRAM:
		process_datagram_packet(packet);
		break;
	default:
		log("Invalid packet type: %d", packet_type);
}