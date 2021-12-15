public class FieldMasksSuperField {
    static class Person {
        protected int age;
        public Person(int age)
        {
            this.age = age;
        }
    }

    static class Employee extends Person {
        protected int age;  // This field hides 'Person.age'.
        protected int numberOfYearsEmployed;
        public Employee(int age, int numberOfYearsEmployed)
        {
            super(age);
            this.numberOfYearsEmployed = numberOfYearsEmployed;
        }
    }

    public static void main(String[] args) {
        Employee e = new Employee(20, 2);
        System.out.println(e.age);
    }
}