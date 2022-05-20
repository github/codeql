using System;
using System.Runtime.InteropServices;

struct SubSubStruct
{
    public int GoodInitializedByExtern;
}

struct SubStruct
{
    public int GoodInitializedByExtern;
    SubSubStruct NestedData;
}

struct InitializedOut
{
    public int GoodInitializedByExtern;
    public SubStruct Data;
}

struct MarshalSubStruct
{
    public int GoodInitializedByExtern;
}

class MarshalInitialized
{
    public int GoodInitializedByExtern;
    public MarshalSubStruct Data;
}

struct MarshalSubStruct2
{
    public int GoodInitializedByExtern;
}

class MarshalInitialized2
{
    public int GoodInitializedByExtern;
    public MarshalSubStruct2 Data;
}

struct IMAGE_DEBUG_DIRECTORY
{
    public int GoodReferencedByCoClass;
}

class CorSymWriterClass
{
}

[Guid("0b97726e-9e6d-4f05-9a26-424022093caa")]
[InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
[ComImport]
[CoClass(typeof(CorSymWriterClass))]
interface ISymUnmanagedWriter2
{
    void GetDebugInfo(
      [In, Out] ref IMAGE_DEBUG_DIRECTORY pIDD);
}

static class MarshalHelpers
{
    public static T MarshalAs<T>(this IntPtr p)
    {
        return (T)Marshal.PtrToStructure(p, typeof(T));
    }
}

struct MyStruct
{
}

struct ViaPtr
{
    public int GoodViaPtr;
}

struct PtrToStructure2
{
    public int GoodPtrToStructure;
}

class Fields1
{
    // BAD:
    int BadNonAssigned;
    object BadAssignedNull = null;

    // GOOD:
    int GoodAssignedByInitializer = 0;
    int GoodAssignedInMethod;
    int GoodAssignedInOutParam;
    InitializedOut GoodStruct;
    [MarshalAs(UnmanagedType.LPStr)] int GoodHasAttribute;

    enum MyEnum
    {
        GoodIsEnum
    }

    MyStruct GoodIsStruct;
    const sbyte GoodIsConst = -1; // This is a (Mono) extractor bug.
    readonly int GoodIsReadOnly;
    int GoodMutated;

    void UseFields()
    {
        object x = BadNonAssigned;

        // BAD:
        BadAssignedNull = null;
        x = BadAssignedNull;

        // GOOD:
        GoodAssignedInMethod = 0;
        x = GoodAssignedInMethod;
        x = GoodAssignedByInitializer;
        x = MyEnum.GoodIsEnum;
        x = GoodHasAttribute;
        x = MyEnum.GoodIsEnum;
        x = GoodIsStruct;
        x = GoodIsConst;
        x = GoodIsReadOnly;
        x = GoodStruct.GoodInitializedByExtern;

        var y = (MarshalInitialized)Marshal.PtrToStructure(InitializeData(), typeof(MarshalInitialized));
        x = y.GoodInitializedByExtern;
        x = y.Data.GoodInitializedByExtern;

        var z = (MarshalInitialized2)InitializeData().MarshalAs<MarshalInitialized2>();
        x = z.GoodInitializedByExtern;
        x = z.Data.GoodInitializedByExtern;

        PtrToStructure2 p2 = new PtrToStructure2();
        Marshal.PtrToStructure(InitializeData(), p2);

        IMAGE_DEBUG_DIRECTORY dd = new IMAGE_DEBUG_DIRECTORY();
        x = dd.GoodReferencedByCoClass;

        unsafe { x = ((ViaPtr*)InitializeData())->GoodViaPtr; }

        ++GoodMutated;
    }

    static extern void InitializeOutFields(out InitializedOut ia);
    static extern IntPtr InitializeData();
}
