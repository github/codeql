using System;

class LocalTest
{
    Object a, b, c;

    void F()
    {
        // BAD: Flagged in G().
        lock (a) lock (b) lock(c) { }
    }
    
    void G()
    {
        // BAD: Inconsistent with F().
        lock (a) lock (c) lock(b) { }
    }  

    void H()
    {
        // GOOD: Consistent with F() and G().
        lock (a) lock(c) { }
    }
}

class GlobalTest
{
    Object a, b, c;

    void F()
    {
        lock (a) G();
    }
    
    void G()
    {
       lock (b) H();
       lock (c) I();
    }
    
    void H()
    {
        // BAD: Inconsistent with I().
        lock (c) { }
    }
    
    void I()
    {
        // BAD: Flagged in H().
        lock (b) { }
    }
}

class LambdaTest
{
    Object a, b;
    
    void F()
    {
        Action lock_a = () => { lock(a) { } };  // BAD: Inconsistent with lock_b.
        Action lock_b = () => { lock(b) { } };  // BAD: Flagged in lock_a.
      
        lock(a) lock_b();
        lock(b) lock_a();
    }
}

// semmle-extractor-options: /r:System.Runtime.Extensions.dll /r:System.Threading.dll /r:System.Threading.Thread.dll
