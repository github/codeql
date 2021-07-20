using System;
using System.Collections.Generic;
using System.Linq;

public class AnonObj
{
    private List<AnonObj> l = new();

    public int Prop1 { get; set; }

    public AnonObj M1(AnonObj t)
    {
        this.M1(new() { Prop1 = 1 });
        return new();
    }

    delegate void D(int x);

    void M2(int x) { }

    D GetM() { return new(M2); }

    void MethodAdd()
    {
        List<int> list = new();// { 1, 2, 3 }; todo: the initializer causes an extraction error
    }
}
