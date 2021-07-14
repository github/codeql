using System;

class Bad2
{
    void M(Exception ex)
    {
        Console.WriteLine("Error processing file: {0}", ex, ex.HResult);
        Console.WriteLine("Error processing file: {1} ({1})", ex, ex.HResult);
        Console.WriteLine("Error processing file: %s (%d)", ex, ex.HResult);
    }
}
