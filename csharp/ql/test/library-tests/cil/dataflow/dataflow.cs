using System;

class Test
{
    static void Main(string[] args)
    {
        // Indirect call to method
        var c1 = "abc".Contains("a");          // Calls string.IndexOf()
        var c2 = "123".CompareTo("b");         // Calls string.Compare()
        var c3 = Tuple.Create("c", "d", "e");    // Calls Tuple constructor
    }
    
    void DataFlowThroughFramework()
    {
        // Dataflow through call
        var f1 = "tainted".ToString();
        var f2 = Math.Abs(12);
        var f3 = Math.Max(2, 3);
        var f4 = Math.Round(0.5);
        var f5 = System.IO.Path.GetFullPath("tainted");

        // Tainted dataflow (there is no untainted dataflow path)
        int remainder;
        var t1 = System.Math.DivRem(1, 2, out remainder);

        // Tainted indirect call to method (there is no untainted dataflow path)
        var t2 = System.Math.IEEERemainder(1.0, 2.0);

        // Miscellaneous examples
        var m1 = System.Math.DivRem(Math.Abs(-1), Math.Max(1, 2), out remainder);
        var m2 = "tainted".ToString().Contains("t");
    }

    void DataFlowThroughAssembly()
    {
        // Dataflow through test assembly
        var dataflow = new Dataflow.DataFlow();
        var d1 = dataflow.Taint1("d1");
        var d2 = dataflow.Taint2("d2");
        var d3 = dataflow.Taint3("d3");

        // Taint tracking
        var tt = new Dataflow.TaintFlow();
        var t1 = tt.Taint1("t1a", "t1b");
        var t2 = tt.Taint2(2, 3);
        var t3 = tt.Taint3(1);
        var t4 = tt.TaintIndirect("t6", "t6");
    }

    void DeadCode() { }

    void CilAlwaysThrows()
    {
        System.Reflection.Assembly.LoadFrom("", null, System.Configuration.Assemblies.AssemblyHashAlgorithm.SHA1);  // Throws NotSupportedException
        DeadCode();
    }

    void Throw() => throw new InvalidCastException();

    void CsAlwaysThrows()
    {
        Throw();
        DeadCode();
    }

    void Nullness()
    {
        var @null = default(object);
        var nonNull1 = default(int);
        var nullFromCil = this.GetType().DeclaringMethod;
        var nonNullFromCil = true.ToString();
        var null2 = NullFunction() ?? IndirectNull();

        // Null from dataflow assembly
        var nullMethods = new Dataflow.NullMethods();
        var null3 = nullMethods.ReturnsNull(); // Null
        var null4 = nullMethods.ReturnsNull2();
        var null5 = nullMethods.NullProperty;

        // NotNull
        var nonNull = new Dataflow.NonNullMethods();
        var nonNull2 = nonNull.ReturnsNonNull();
        var nonNull3 = nonNull.ReturnsNonNullIndirect();
        var nonNull4 = nonNull.NonNullProperty;

        // The following are not always null:
        var notNull1 = cond ? NullFunction() : this;
        var notNull2 = nullMethods.VirtualReturnsNull();
        var notNull3 = nullMethods.VirtualNullProperty;
        var notNonNull = nonNull.VirtualNonNull;

        // The following are maybe null
        var maybeNull = nonNull.MaybeNull();
        var maybeNull2 = nonNull.MaybeNull2();
        var maybeNullMethods = new DataflowUnoptimized.MaybeNullMethods();
        maybeNull = maybeNullMethods.MaybeNull();
        maybeNull2 = maybeNullMethods.MaybeNull2();
    }

    object IndirectNull() => null;

    bool cond;

    object NullFunction()
    {
        object x = IndirectNull();
        if (cond) x = null;
        return x;
    }
}
