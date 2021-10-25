using System;

class LockTest
{
    static void A()    
    {
        object @object = new object();
        lock (@object)
        {
            Console.WriteLine(@object.ToString());
        }
    }
}
