class Person implements Cloneable {
    private String name;
    public Person(String name) { this.name = name; }
    // GOOD: 'clone' correctly calls 'super.clone'
    public Person clone() {
        try {
            return (Person)super.clone();
        } catch (CloneNotSupportedException e) {
            throw new AssertionError("Should never happen");
        }
    }
}

class Employee extends Person {
    public Employee(String name) {
        super(name);
    }
    // GOOD: 'clone' correctly calls 'super.clone'
    public Employee clone() {
    	return (Employee)super.clone();
    }
}

public class MissingCallToSuperClone {
    public static void main(String[] args) {
        Employee e2 = new Employee("Jane Doe");
        Employee e2clone = e2.clone(); // 'clone' correctly returns an object of type 'Employee'
    }
}
