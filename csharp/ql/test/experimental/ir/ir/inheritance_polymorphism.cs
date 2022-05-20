public class A
{
    public virtual int function()
    {
        return 0;
    }
}

class B : A
{
}

class C : B
{
    public override int function()
    {
        return 1;
    }
}

class Program
{
    static void Main()
    {
        B objB = new B();
        objB.function();        

        // Check conversion works
        A objA;
        objA = objB;
        objA.function();

        A objC = new C();
        objC.function();
    }

}
