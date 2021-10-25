public class Customer
{
	private String title;
	private String forename;
	private String surname;

	// ...

	public String tostring() {  // Incorrect capitalization of 'toString'
		return title + " " + forename + " " + surname;
	}
}