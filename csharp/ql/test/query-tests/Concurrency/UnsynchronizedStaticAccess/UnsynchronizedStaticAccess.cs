using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Concurrent;
using System.Threading;

public class Klass
{
    public static Dictionary<string, string> dict = new Dictionary<string, string>();
    public static ConcurrentDictionary<string, string> cdict = new ConcurrentDictionary<string, string>();

    private Object mutex = new Object();

    public static void aWriter()
    {
        // GOOD: static access
        dict["foo"] = "bar";
    }

    public void test()
    {
        // BAD: unsynchronized access
        string val = dict["foo"];

        lock (mutex)
        {
            // GOOD: locked
            val = dict["foo"];
        }

        // GOOD: concurrent collection
        val = cdict["foo"];

        // GOOD: monitor taken
        Monitor.Enter(dict);
        val = dict["foo"];
        Monitor.Exit(dict);
    }

    // separate method to avoid the monitor calls interfering - we don't handle releasing monitors
    public void test2()
    {
        Monitor.Enter(dict);
        testLocked();
        Monitor.Exit(dict);
    }

    private void threading()
    {
        Thread t = new Thread(new ThreadStart(this.testMethod));
        t.Start();
    }

    private void testPrivate()
    {
        // GOOD: probably not concurrently called
        string val = dict["foo"];
    }

    private void testLocked()
    {
        // GOOD: called concurrently, but locked
        string val = dict["foo"];
    }

    private void testMethod()
    {
        // BAD: called concurrently by thread
        string val = dict["foo"];
    }
}

// semmle-extractor-options: /r:System.Collections.Concurrent.dll /r:System.Threading.Thread.dll
