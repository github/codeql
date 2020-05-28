using System;

public class Finally
{
    string Field;

    void M1()
    {
        try
        {
            Console.WriteLine("Try1");
        }
        finally
        {
            Console.WriteLine("Finally");
        }
    }

    void M2()
    {
        try
        {
            Console.WriteLine("Try2");
            return; // Go to the finally block
        }
        catch (System.IO.IOException ex) when (true)
        {
            throw;  // Go to the finally block
        }
        catch (System.ArgumentException ex)
        {
            try
            {
                if (true) throw;
            }
            finally
            {
                throw new Exception("Boo!");
            }
        }
        catch (Exception)
        {
        }
        catch
        {
            return; // Dead
        }
        finally
        {
            Console.WriteLine("Finally");
        }
    }

    void M3()
    {
        try
        {
            Console.WriteLine("Try3");
            return; // Go to the finally block
        }
        catch (System.IO.IOException ex) when (true)
        {
            throw;  // Go to the finally block
        }
        catch (Exception e) when (e.Message != null)
        {
        }
        finally
        {
            Console.WriteLine("Finally");
        }
    }

    void M4()
    {
        var i = 10;
        while (i > 0)
        {
            try
            {
                if (i == 0)
                    return;
                if (i == 1)
                    continue;
                if (i == 2)
                    break;
            }
            finally
            {
                try
                {
                    if (i == 3)
                        throw new Exception();
                }
                finally
                {
                    i--;
                }
            }
        }
    }

    void M5()
    {
        try
        {
            if (Field.Length == 0)
                return;
            if (Field.Length == 1)
                throw new OutOfMemoryException();
        }
        finally
        {
            if (!(Field.Length == 0))
                Console.WriteLine(Field);
            if (Field.Length > 0)
                Console.WriteLine(1);
        }
    }

    void M6()
    {
        try
        {
            var temp = 0 / System.Math.E;
        }
        catch
        {
            ; // dead
        }
    }

    void M7()
    {
        try
        {
            Console.WriteLine("Try");
        }
        finally
        {
            throw new ArgumentException("");
            Console.WriteLine("Dead");
        }
        Console.WriteLine("Dead");
    }

    void M8(string[] args)
    {
        try
        {
            if (args == null)
                throw new ArgumentNullException();
        }
        finally
        {
            try
            {
                if (args.Length == 1)
                    throw new Exception("1");
            }
            catch (Exception e) when (e.Message == "1")
            {
                Console.WriteLine(args[0]);
            }
            catch
            {
                Console.WriteLine("");
            }
        }
    }

    class ExceptionA : Exception { }
    class ExceptionB : Exception { }
    class ExceptionC : Exception { }

    void M9(bool b1, bool b2)
    {
        try
        {
            if (b1) throw new ExceptionA();
        }
        finally
        {
            try
            {
                if (b2) throw new ExceptionB();
            }
            catch (ExceptionB) when (b2)
            {
                if (b1) throw new ExceptionC();
            }
        }
    }

    void M10(bool b1, bool b2, bool b3)
    {
        try
        {
            if (b1) throw new ExceptionA();
        }
        finally
        {
            try
            {
                if (b2) throw new ExceptionB();
            }
            finally
            {
                if (b3) throw new ExceptionC();
            }
            this.Field = "0";
        }
        this.Field = "1";
    }

    void M11()
    {
        try
        {
            Console.WriteLine("Try");
        }
        catch
        {
            Console.WriteLine("Catch");
        }
        finally
        {
            Console.WriteLine("Finally");
        }
        Console.WriteLine("Done");
    }
}
