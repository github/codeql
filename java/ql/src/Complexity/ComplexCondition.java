public class Dialog
{
	// ...

	private void validate() {
		// TODO: check that this covers all cases
		if ((id != null && id.length() == 0) ||
			((partner == null || partner.id == -1) &&
			((option == Options.SHORT && parameter.length() == 0) ||
			(option == Options.LONG && parameter.length() < 8))))
		{
			disableOKButton();
		} else {
			enableOKButton();
		}
	}

	// ...
}