public class Person
{
	private String title;
	private String forename;
	private String surname;

	// ...

	public int hashcode() {  // The method is named 'hashcode'.
		int hash = 23 * title.hashCode();
		hash ^= 13 * forename.hashCode();
		return hash ^ surname.hashCode();
	}
}