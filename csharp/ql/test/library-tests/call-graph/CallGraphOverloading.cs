namespace Overloading;

class C1
{
    public void // $ TypeMention=System.Void
    M1()
    {
        this.M2(); // $ StaticTarget=Overloading.C1.M2()
        this.M2(null); // $ StaticTarget=Overloading.C1.M2(Overloading.C1)
        this.M2(null, null); // $ StaticTarget=Overloading.C1.M2(Overloading.C1,Overloading.C1)
        this.M2(null, null, null); // $ StaticTarget=Overloading.C1.M2(Overloading.C1,Overloading.C1,Overloading.C1)
        this.M2(null, null, null, null); // $ StaticTarget=Overloading.C1.M2(Overloading.C1,Overloading.C1,Overloading.C1,Overloading.C1[])
    }

    public void // $ TypeMention=System.Void
    M2()
    { }

    public void // $ TypeMention=System.Void
    M2(
        C1 c // $ TypeMention=Overloading.C1
    )
    { }

    public virtual void // $ TypeMention=System.Void
    M2(
        C1 c1, // $ TypeMention=Overloading.C1
        C1 c2 // $ TypeMention=Overloading.C1
    )
    { }

    public void // $ TypeMention=System.Void
    M2(
        C1 c1, // $ TypeMention=Overloading.C1
        C1 c2 = null, // $ TypeMention=Overloading.C1
        C1 c3 = null // $ TypeMention=Overloading.C1
    )
    { }

    void // $ TypeMention=System.Void
    M2(
        C1 c1, // $ TypeMention=Overloading.C1
        C1 c2, // $ TypeMention=Overloading.C1
        C1 c3, // $ TypeMention=Overloading.C1
        params C1[] cs // $ TypeMention=Overloading.C1
    )
    { }
} // $ Class=Overloading.C1

class C2 : C1 // $ TypeMention=Overloading.C1
{
    void // $ TypeMention=System.Void
    M1()
    {
        this.M2(null, null); // $ StaticTarget=Overloading.C2.M2(Overloading.C1,Overloading.C1)
    }

    public override void // $ TypeMention=System.Void
    M2(
        C1 c1, // $ TypeMention=Overloading.C1
        C1 c2 // $ TypeMention=Overloading.C1
    )
    { }
} // $ Class=Overloading.C2