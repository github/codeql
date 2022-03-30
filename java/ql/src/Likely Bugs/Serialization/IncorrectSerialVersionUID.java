class WrongNote implements Serializable {
	// BAD: serialVersionUID must be static, final, and 'long'
	private static final int serialVersionUID = 1;
	
	//...
}

class Note implements Serializable {
	// GOOD: serialVersionUID is of the correct type
	private static final long serialVersionUID = 1L;
}