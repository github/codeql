using System;

class C1
{
    int property1;
    object mutex = new Object();

    // BAD: getter is unlocked
    int BadProperty1
    {
        get
        {
            return property1;
        }

        set
        {
            lock (mutex) property1 = value;
        }
    }

    // BAD: getter is not properly locked
    int BadProperty2
    {
        get
        {
            lock (mutex) { }
            return property1;
        }

        set
        {
            lock (mutex) property1 = value;
        }
    }

    // GOOD: getter is locked
    int GoodProperty1
    {
        get
        {
            lock (mutex) return property1;
        }

        set
        {
            lock (mutex) property1 = value;
        }
    }

    // GOOD: neither is locked
    int GoodProperty2
    {
        get
        {
            return property1;
        }

        set
        {
            property1 = value;
        }
    }

    // GOOD: the property is not locked in the setter
    int GoodProperty3
    {
        get
        {
            return property1;
        }

        set
        {
            lock (mutex) { }
            property1 = value;
        }
    }

    // GOOD: value is not a field
    int GoodProperty4
    {
        get
        {
            return GoodProperty3;
        }
        set
        {
            lock (mutex) GoodProperty3 = value;
        }
    }
}
