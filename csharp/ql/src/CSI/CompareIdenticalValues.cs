class Person
{
    private string name;
    private int age;
    public Person(string name, int age)
    {
        this.name = name;
        this.age = age;
    }
    public override bool Equals(object obj)
    {
        Person personObj = obj as Person;
        if (personObj == null)
        {
            return false;
        }
        return name == personObj.name && age == age; // BAD
    }
}
