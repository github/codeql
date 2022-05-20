class OuterClass
{
    private class Person // BAD: "Person" is never used
    {
        private string name;
        private int age;
        public Person(string name, int age)
        {
            this.name = name;
            this.age = age;
        }
    }
    public static void Main(string[] args)
    {

    }
}
