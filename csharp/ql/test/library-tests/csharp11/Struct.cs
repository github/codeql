namespace structassembly;

public class MyEmptyClass { }

public ref struct RefStruct
{
    public int MyInt;
    public ref byte MyByte;
    public ref object MyObject;
    internal ref MyEmptyClass MyEmptyClass;
    public ref readonly byte MyReadonlyByte;
    public readonly ref object MyReadonlyObject;
    public readonly ref readonly string MyReadonlyString;
}