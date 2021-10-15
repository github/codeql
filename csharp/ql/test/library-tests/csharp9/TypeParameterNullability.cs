interface I1 {}

class A2
{
    public virtual void F1<T>(T? t) { }                 // value or ref type
    public virtual void F2<T>(T? t) where T: struct { } // value type
    public virtual void F3<T>(T? t) where T: class { }  // ref type
    public virtual void F4<T>(T? t) where T: A2 { }     // A2, ref type
    public virtual void F5<T>(T? t) where T: I1 { }     // I1, value or ref type
    public virtual void F6<T>(T? t) where T: struct, I1 { }  // I1, value type
}

class B2 : A2
{
    public override void F1<T>(T? t) where T: default { } // value or ref type
    public override void F2<T>(T? t) { }                  // value type
    public override void F3<T>(T? t) where T: class { }   // ref type
    public override void F4<T>(T? t) where T: class { }   // A2, ref type
    public override void F6<T>(T? t) { }                  // I1, value type
}

class B3 : A2
{
    public override void F2<T>(T? t) where T: struct { }  // value type
}
