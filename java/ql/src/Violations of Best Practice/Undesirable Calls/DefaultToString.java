// This class does not have a 'toString' method, so 'java.lang.Object.toString'
// is used when the class is converted to a string.
class WrongPerson {
	private String name;
	private Date birthDate; 
	
	public WrongPerson(String name, Date birthDate) {
		this.name =name;
		this.birthDate = birthDate;
	}
}

public static void main(String args[]) throws Exception {
	DateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
	WrongPerson wp = new WrongPerson("Robert Van Winkle", dateFormatter.parse("1967-10-31"));

	// BAD: The following statement implicitly calls 'Object.toString', 
	// which returns something similar to:
	// WrongPerson@4383f74d
	System.out.println(wp);
}