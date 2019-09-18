using System;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;

class ExitMethods
{
    void M1()
    {
        ErrorMaybe(true);
        return; // not dead
    }

    void M2()
    {
        ErrorMaybe(false);
        return; // dead (not detected)
    }

    void M3()
    {
        ErrorAlways(true);
        return; // dead
    }

    void M4()
    {
        Exit();
        return; // dead
    }

    void M5()
    {
        ApplicationExit();
        return; // dead
    }

    void M6()
    {
        try
        {
            ErrorAlways(false);
        }
        catch (ArgumentException)
        {
            return; // not dead
        }
        catch (Exception)
        {
            return; // not dead
        }
    }

    void M7()
    {
        ErrorAlways2();
        return; // dead
    }

    void M8()
    {
        ErrorAlways3();
        return; // dead
    }

    static void ErrorMaybe(bool b)
    {
        if (b)
            throw new Exception();
    }

    static void ErrorAlways(bool b)
    {
        if (b)
            throw new Exception();
        else
            throw new ArgumentException("b");
    }

    static void ErrorAlways2()
    {
        throw new Exception();
    }

    static void ErrorAlways3() => throw new Exception();

    void Exit()
    {
        Environment.Exit(0);
    }

    void ExitInTry()
    {
        try
        {
            Exit();
        }
        finally
        {
            // dead
            System.Console.WriteLine("");
        }
    }

    void ApplicationExit()
    {
        System.Windows.Forms.Application.Exit();
    }

    decimal ThrowExpr(decimal input)
    {
        return input != 0 ? 1 / input : throw new ArgumentException("input");
    }

    public int ExtensionMethodCall(string s)
    {
        return s.Contains('-') ? 0 : 1;
    }

    public void FailingAssertion()
    {
        Assert.IsTrue(false);
        var x = 0; // dead
    }

    public void FailingAssertion2()
    {
        FailingAssertion();
        var x = 0; // dead
    }

    void AssertFalse(bool b) => Assert.IsFalse(b);

    public void FailingAssertion3()
    {
        AssertFalse(true);
        var x = 0; // dead
    }
}

// semmle-extractor-options: ${testdir}/../../../resources/stubs/System.Windows.cs  ${testdir}/../../../resources/stubs/Microsoft.VisualStudio.TestTools.UnitTesting.cs
