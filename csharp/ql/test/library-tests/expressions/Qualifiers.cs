using System;

class Qualifiers
{
    public short S => Static<short>(null);

    public int I => Instance<int>();

    public bool B => this.Instance<bool>();

    static T Static<T>(object o) => default(T);

    T Instance<T>() => default(T);
}
