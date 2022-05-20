using System;

class Class1
{
    void G()
    {
    }

    int p;

    void TestNoThrow()
    {
        try
        {
            ;
        }
        catch (NullReferenceException ex)
        {
            ;
        }
        catch (OverflowException ex)
        {
            ;
        }
        catch (OutOfMemoryException ex)
        {
            ;
        }
        catch (DivideByZeroException ex)
        {
            ;
        }
        catch (Exception ex)
        {
            ;
        }
        finally
        {
            ;
        }
    }

    void TestCall()
    {
        try
        {
            ;
            G();
        }
        catch (NullReferenceException ex)
        {
            ;
        }
        catch (OverflowException ex)
        {
            ;
        }
        catch (OutOfMemoryException ex)
        {
            ;
        }
        catch (DivideByZeroException ex)
        {
            ;
        }
        catch
        {
            ;
        }
    }

    void TestCreation()
    {
        try
        {
            ;
            var v = new Class1();
        }
        catch (NullReferenceException ex)
        {
            ;
        }
        catch (OverflowException ex)
        {
            ;
        }
        catch (OutOfMemoryException ex)
        {
            ;
        }
        catch (DivideByZeroException ex)
        {
            ;
        }
        catch (Exception ex)
        {
            ;
        }
    }

    void TestIntAdd()
    {
        try
        {
            ;
            var v = 1 + 2;
        }
        catch (NullReferenceException ex)
        {
            ;
        }
        catch (OverflowException ex)
        {
            ;
        }
        catch (OutOfMemoryException ex)
        {
            ;
        }
        catch (DivideByZeroException ex)
        {
            ;
        }
        catch (Exception ex)
        {
            ;
        }
    }

    void TestIntSub()
    {
        try
        {
            ;
            var v = 1 - 2;
        }
        catch (NullReferenceException ex)
        {
            ;
        }
        catch (OverflowException ex)
        {
            ;
        }
        catch (OutOfMemoryException ex)
        {
            ;
        }
        catch (DivideByZeroException ex)
        {
            ;
        }
        catch (Exception ex)
        {
            ;
        }
    }

    void TestIntMul()
    {
        try
        {
            ;
            var v = 1 * 2;
        }
        catch (NullReferenceException ex)
        {
            ;
        }
        catch (OverflowException ex)
        {
            ;
        }
        catch (OutOfMemoryException ex)
        {
            ;
        }
        catch (DivideByZeroException ex)
        {
            ;
        }
        catch (Exception ex)
        {
            ;
        }
    }

    void TestStringLiteral()
    {
        try
        {
            ;
            var v = "";
        }
        catch (NullReferenceException ex)
        {
            ;
        }
        catch (OverflowException ex)
        {
            ;
        }
        catch (OutOfMemoryException ex)
        {
            ;
        }
        catch (DivideByZeroException ex)
        {
            ;
        }
        catch (Exception ex)
        {
            ;
        }
    }

    void TestStringAdd()
    {
        try
        {
            string s = "";
            ;
            var v = s + s;
        }
        catch (NullReferenceException ex)
        {
            ;
        }
        catch (OverflowException ex)
        {
            ;
        }
        catch (OutOfMemoryException ex)
        {
            ;
        }
        catch (DivideByZeroException ex)
        {
            ;
        }
        catch (Exception ex)
        {
            ;
        }
    }

    void TestDivide()
    {
        try
        {
            ;
            var v = 1 / 2;
        }
        catch (NullReferenceException ex)
        {
            ;
        }
        catch (OverflowException ex)
        {
            ;
        }
        catch (OutOfMemoryException ex)
        {
            ;
        }
        catch (DivideByZeroException ex)
        {
            ;
        }
        catch (Exception ex)
        {
            ;
        }
    }

    void TestRemainder()
    {
        try
        {
            ;
            var v = 1 % 2;
        }
        catch (NullReferenceException ex)
        {
            ;
        }
        catch (OverflowException ex)
        {
            ;
        }
        catch (OutOfMemoryException ex)
        {
            ;
        }
        catch (DivideByZeroException ex)
        {
            ;
        }
        catch (Exception ex)
        {
            ;
        }
    }

    void TestMemberAccess()
    {
        try
        {
            ;
            var v = this.p;
        }
        catch (NullReferenceException ex)
        {
            ;
        }
        catch (OverflowException ex)
        {
            ;
        }
        catch (OutOfMemoryException ex)
        {
            ;
        }
        catch (DivideByZeroException ex)
        {
            ;
        }
        catch (Exception ex)
        {
            ;
        }
    }

    void TestCast()
    {
        try
        {
            ;
            var v = (short)1;
        }
        catch (NullReferenceException ex)
        {
            ;
        }
        catch (OverflowException ex)
        {
            ;
        }
        catch (OutOfMemoryException ex)
        {
            ;
        }
        catch (DivideByZeroException ex)
        {
            ;
        }
        catch (Exception ex)
        {
            ;
        }
    }

    void TestThrow()
    {
        try
        {
            var e = new DivideByZeroException();
            ;
            throw e;
        }
        catch (NullReferenceException ex)
        {
            ;
        }
        catch (OverflowException ex)
        {
            ;
        }
        catch (OutOfMemoryException ex)
        {
            ;
        }
        catch (DivideByZeroException ex)
        {
            ;
        }
        catch (Exception ex)
        {
            ;
        }
    }

    void TestUnaryOperation()
    {
        try
        {
            var a = 1;
            ;
            ++a;
        }
        catch (NullReferenceException ex)
        {
            ;
        }
        catch (OverflowException ex)
        {
            ;
        }
        catch (OutOfMemoryException ex)
        {
            ;
        }
        catch (DivideByZeroException ex)
        {
            ;
        }
        catch (Exception ex)
        {
            ;
        }
    }

    void TestRethrow()
    {
        try
        {
            try
            {
            }
            catch
            {
                ;
                throw;
            }
        }
        catch (OutOfMemoryException ex)
        {
            ;
        }
        catch
        {
            ;
        }
    }

    void TestSubtypeCast()
    {
        try
        {
            object o = null;
            ;
            var p = (Class1)o;
        }
        catch (InvalidCastException ex)
        {
            ;
        }
        catch (Exception ex)
        {
            ;
        }
    }

    void TestDivideMaybeZero(int i)
    {
        try
        {
            ;
            var v = 1 / i;
        }
        catch (NullReferenceException ex)
        {
            ;
        }
        catch (OverflowException ex)
        {
            ;
        }
        catch (OutOfMemoryException ex)
        {
            ;
        }
        catch (DivideByZeroException ex)
        {
            ;
        }
        catch (Exception ex)
        {
            ;
        }
    }
}
