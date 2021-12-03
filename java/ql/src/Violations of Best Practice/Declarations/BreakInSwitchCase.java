class Server
{
	public void respond(Event event)
	{
		Message reply = null;
		switch (event) {
		case PING:
			reply = Message.PONG;
			// Missing 'break' statement
		case TIMEOUT:
			reply = Message.PING;
		case PONG:
			// No reply needed
		}
		if (reply != null)
			send(reply);
	}

	private void send(Message message) {
		// ...
	}
}

enum Event { PING, PONG, TIMEOUT }
enum Message { PING, PONG }