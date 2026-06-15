using System;

/// <summary>
///   GOOD: Class documented correctly
/// </summary>
public class Class1
{
    protected class Exception1 : ArgumentException
    {
    }

    protected class Exception2 : ArgumentException
    {
    }

    /// <summary>
    ///    GOOD: This public method is documented correctly
    /// <summary>
    /// <param name="p1">First parameter</param>
    /// <param name="p2">Second parameter</param>
    /// <returns>Only via exception</returns>
    /// <exception cref= "Exception1" >Exception 1</exception>
    /// <exception cref='System.ArgumentException'>Exception 2</exception>
    public virtual int method1(int p1, int p2)
    {
        throw new Exception1();
        throw new Exception2();
    }

    /// BAD: This XML comment is missing several tags
    /// <param name="p3">BAD: This parameter does not exist</param>
    /// <exception cref="Exception1">BAD: This should say Exception2</exception>
    public int method2(int p1, int p2)
    {
        return p1 > 0 ? throw new Exception2() : p2;
    }

    // BAD: Missing documentation comment
    public int method3()
    {
        return 0;
    }

    // GOOD: This internal comment does not need documentation
    internal int method4()
    {
        return 0;
    }

    // BAD: Public class is not documented
    public class Class2
    {
    }

    // GOOD: Private class does not need documentation
    class Class3
    {
    }

    // GOOD: Constructor is private
    private Class1(string s)
    {
    }

    /// <summary>
    ///   GOOD: Constructor is correctly documented
    /// </summary>
    /// <param name='p'>The parameter</param>
    public Class1(int p)
    {
    }

    // BAD: Constructor is public and not documented
    public Class1(int a, int b)
    {
    }

    /// <summary>
    ///   BAD: Missing a typeparam
    ///   BAD: Contains an extra typeparam
    /// </summary>
    /// <typeparam name="X">The type</typeparam>
    class Class4<T> { }

    /// <summary>
    ///   GOOD: Type params are correctly labeled
    /// </summary>
    /// <typeparam name="T1">First type</typeparam>
    /// <typeparam name="T2">Second type</typeparam>
    class Class5<T1, T2> { }

    /// <summary>
    ///   BAD: Missing a typeparam on a method
    ///   BAD: Contains an extra typeparam
    /// </summary>
    /// <typeparam name="T0">BAD typeparam</typeparam>
    /// <typeparam name='T2'>GOOD typeparam</typeparam>
    void method5<T1, T2>() { }

    // BAD: These fields are empty
    /// <summary></summary>
    /// <param name="p1"/>
    /// <param name="p2"> </param>
    /// <returns></returns>
    /// <typeparam name="T"></typeparam>
    public virtual int method4<T>(int p1, int p2) { return p1; }
}

class Class2 : Class1
{
    // GOOD
    /// <inheritdoc/>
    public Class2(int i) : base(i) { }

    // GOOD
    /// <inheritdoc/>
    public override int method1(int p1, int p2)
    {
        throw new Exception1();
        throw new Exception2();
    }

    // GOOD: Even if the overridden method is bad.
    /// <inheritdoc/>
    public override int method4<T>(int p1, int p2) { return p1; }

    // GOOD: Has an attribute
    [My1]
    public void method5()
    {
    }

    // BAD: Has only System.Runtime.CompilerServices attribute
    [System.Runtime.CompilerServices.My2]
    public void method6()
    {
    }
}

internal class My1Attribute : Attribute { }

namespace System.Runtime.CompilerServices
{
    internal class My2Attribute : Attribute { }
}
