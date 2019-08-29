using System;

class LockTest
{
    static void A()    
    {
        object _object = new object();
        lock (_object)
        {
            Console.WriteLine(_object.ToString());
        }
    }
}
