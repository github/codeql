using System;
using System.Text;

public record Person
{
    public string LastName { get; }
    public string FirstName { get; }

    public Person(string first, string last) => (FirstName, LastName) = (first, last);
}

public record Teacher : Person
{
    public string Subject { get; }

    public Teacher(string first, string last, string sub)
        : base(first, last) => Subject = sub;
}

public sealed record Student : Person
{
    public int Level { get; }

    public Student(string first, string last, int level) : base(first, last) => Level = level;
}

public record Person1(string FirstName, string LastName);

public record Teacher1(string FirstName, string LastName, string Subject)
    : Person1(FirstName, LastName);

public sealed record Student1(string FirstName, string LastName, int Level)
    : Person1(FirstName, LastName);

public record Pet(string Name)
{
    public void ShredTheFurniture() =>
        Console.WriteLine("Shredding furniture");
}

public record Dog(string Name) : Pet(Name)
{
    public void WagTail() =>
        Console.WriteLine("It's tail wagging time");

    public override string ToString()
    {
        var s = new StringBuilder();
        base.PrintMembers(s);
        return $"{s.ToString()} is a dog";
    }
}

public abstract record R1(string A) { }

public record R2(string A, string B) : R1(A) { }

public class Record1
{
    public void M1()
    {
        var person = new Person("Bill", "Wagner");
        var student = new Student("Bill", "Wagner", 11);

        Console.WriteLine(student == person);
    }

    public void M2()
    {
        Person1 p1 = new Teacher1("Bill", "Wagner", "Math");

        var (first, last) = p1;
        Console.WriteLine(first);

        var p2 = p1 with { FirstName = "Paul" };
        var p3 = (Teacher1)p1 with { FirstName = "Paul", Subject = "Literature" };
        var clone = p1 with { };
    }

    public void M3()
    {
        R2 a = new R2("A", "B");
        R1 b = a;
        R1 c = b with { A = "C" };
    }
}
