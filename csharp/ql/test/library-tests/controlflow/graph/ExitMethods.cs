using System;
using System.Linq;

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

    void Exit()
    {
        Environment.Exit(0);
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
}

namespace System.Windows.Forms
{
    public class Application
    {
        public static void Exit() { }
    }
}
