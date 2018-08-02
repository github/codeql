class Parent
{
    public void PrintString()
    {
        Console.WriteLine("parent");
    }
}

class Child : Parent
{
    public void printString()
    {
        Console.WriteLine("child");
    }
}

class ConfusingOverrideNames
{
    static void Main(string[] args)
    {
        Child child = new Child();
        child.PrintString();
    }
}
