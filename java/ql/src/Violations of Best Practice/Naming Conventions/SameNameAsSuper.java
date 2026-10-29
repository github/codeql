import com.company.util.Attendees;

public class Meeting
{
	private Attendees attendees;

	// ...
	// Many lines
	// ...

	// AVOID: This class has the same name as its superclass.
	private static class Attendees extends com.company.util.Attendees
	{
		// ...
	}
}