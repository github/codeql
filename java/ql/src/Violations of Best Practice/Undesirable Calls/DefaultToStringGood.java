// This class does have a 'toString' method, which is used when the object is
// converted to a string.
class Person {
	private String name;
	private Date birthDate;
	
	public String toString() {
		DateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
		return "(Name: " + name + ", Birthdate: " + dateFormatter.format(birthDate) + ")";
	}
	
	public Person(String name, Date birthDate) {
		this.name =name;
		this.birthDate = birthDate;
	}
}

public static void main(String args[]) throws Exception {
	DateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
	Person p = new Person("Eric Arthur Blair", dateFormatter.parse("1903-06-25"));

	// GOOD: The following statement implicitly calls 'Person.toString', 
	// which correctly returns a human-readable string:
	// (Name: Eric Arthur Blair, Birthdate: 1903-06-25)
	System.out.println(p);
}