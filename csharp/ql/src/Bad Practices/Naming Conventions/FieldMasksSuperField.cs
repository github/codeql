class Person
{
    private string name;
    public Person() { }
    public Person(string name)
    {
        this.name = name;
    }
}
class Employee : Person
{
    private string name; // BAD
    private string department;
    public Employee(string name, string department)
    {
        this.name = name;
        this.department = department;
    }
}
