class InconsistentCompareTo
{
    class Age : IComparable<Age>
    {
        private int age;
        public Age(int age)
        {
            this.age = age;
        }
        public int CompareTo(Age rhs)
        {
            return age.CompareTo(rhs.age);
        }
    }

    public static void Main(string[] args)
    {
        Age a1 = new Age(22);
        Age a2 = new Age(22);
        Console.WriteLine("Comparing a1 with a2: " + a1.CompareTo(a2));
        Console.WriteLine("a1 equals a2: " + a1.Equals(a2));
    }
}
