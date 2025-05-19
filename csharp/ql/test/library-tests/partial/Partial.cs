partial class TwoPartClass
{
    partial void PartialMethodWithBody1();
    partial void PartialMethodWithoutBody1();
    public void Method2() { }
    // Declaring declaration.
    public partial object PartialProperty1 { get; set; }
    // Declaring declaration.
    public partial object this[int index] { get; set; }
}

partial class TwoPartClass
{
    partial void PartialMethodWithBody1() { }
    public void Method3() { }
    private object _backingField;
    // Implementation declaration.
    public partial object PartialProperty1
    {
        get { return _backingField; }
        set { _backingField = value; }
    }
    private object[] _backingArray;
    // Implmentation declaration.
    public partial object this[int index]
    {
        get { return _backingArray[index]; }
        set { _backingArray[index] = value; }
    }
}

partial class OnePartPartialClass
{
    partial void PartialMethodWithoutBody2();
    public void Method4() { }
}

class NonPartialClass
{
    public void Method5() { }
    public object Property { get; set; }
    public object this[int index]
    {
        get { return null; }
        set { }
    }
}
