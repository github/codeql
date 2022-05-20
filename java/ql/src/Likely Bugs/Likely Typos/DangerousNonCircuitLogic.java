public class Person
{
	private String forename;
	private String surname;

	public boolean hasForename() {
		return forename != null && forename.length() > 0;  // GOOD: Conditional-and operator
	}

	public boolean hasSurname() {
		return surname != null & surname.length() > 0;  // BAD: Bitwise AND operator
	}

	// ...
}