class A
{
    public virtual A M1() { throw null; }
}

class B : A
{
    public override B M1() { throw null; }
}
