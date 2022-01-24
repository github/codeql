class WrongNetRequest implements Serializable {
	// BAD: Does not match the exact signature required for a custom 
	// deserialization protocol. Will not be called during deserialization.
	void readObject(ObjectInputStream in) {
		//...
	}
	
	// BAD: Does not match the exact signature required for a custom 
	// deserialization protocol. Will not be called during deserialization.
	void readObjectNoData() {
		//...
	}
	
	// BAD: Does not match the exact signature required for a custom 
	// serialization protocol. Will not be called during serialization.
	protected void writeObject(ObjectOutputStream out) {
		//...
	}
}

class NetRequest implements Serializable {
	// GOOD: Signature for a custom deserialization implementation.
	private void readObject(ObjectInputStream in) {
		//...
	}
	
	// GOOD: Signature for a custom deserialization implementation.
	private void readObjectNoData() {
		//...
	}
	
	// GOOD: Signature for a custom serialization implementation.
	private void writeObject(ObjectOutputStream out) {
		//...
	}
}