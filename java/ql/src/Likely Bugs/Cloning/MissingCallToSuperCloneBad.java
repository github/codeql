class WrongPerson implements Cloneable {
    private String name;
    public WrongPerson(String name) { this.name = name; }
    // BAD: 'clone' does not call 'super.clone'.
    public WrongPerson clone() {
        return new WrongPerson(this.name);
    }
}

class WrongEmployee extends WrongPerson {
    public WrongEmployee(String name) {
        super(name);
    }
    // ALMOST RIGHT: 'clone' correctly calls 'super.clone',
    // but 'super.clone' is implemented incorrectly.
    public WrongEmployee clone() {
    	return (WrongEmployee)super.clone();
    }
}

public class MissingCallToSuperClone {
    public static void main(String[] args) {
        WrongEmployee e = new WrongEmployee("John Doe");
        WrongEmployee eclone = e.clone(); // Causes a ClassCastException
    }
}
