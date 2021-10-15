partial class TwoPartClass
{
    partial void PartialMethodWithBody1();
    partial void PartialMethodWithoutBody1();
    public void Method2() { }
}

partial class TwoPartClass
{
    partial void PartialMethodWithBody1() { }
    public void Method3() { }
}

partial class OnePartPartialClass
{
    partial void PartialMethodWithoutBody2();
    public void Method4() { }
}

class NonPartialClass
{
    public void Method5() { }
}