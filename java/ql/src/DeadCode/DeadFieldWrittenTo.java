public class FieldOnlyRead {
	private int writtenToField;

	public void runThing() {
		writtenToField = 2;
		callOtherThing();
	}

	public static main(String[] args) {
		runThing();
	}
}