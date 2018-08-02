using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Concurrent;
using System.Threading;

public class Configuration
{
    public static Dictionary<string, string> properties = new Dictionary<string, string>();

    // called concurrently elsewhere
    public string getProperty(string key)
    {
        // BAD: unsynchronized access to static collection
        return dict["foo"];
    }
}
