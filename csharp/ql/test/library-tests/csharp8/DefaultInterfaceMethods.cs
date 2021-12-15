using System;

interface IPerson
{
    string Name { get; }

    string Greeting
    {
        get => "Hello";
        set { }
    }

    string Greet(string name) => Greeting + " " + name;

    string GreetingString => Greet(Name);

    void Greet();
}

class Person : IPerson
{
    public string Name => "Petra";

    string IPerson.Greeting { get => "Howdy"; set { } }

    public void Greet() { }
}
