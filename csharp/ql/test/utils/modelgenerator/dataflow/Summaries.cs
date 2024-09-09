using System;
using System.Linq;
using System.Collections;
using System.Collections.Generic;

namespace Models;

public class BasicFlow
{
    // No model as destructors are excluded from model generation.
    ~BasicFlow() { }

    private string tainted;

    // summary=Models;BasicFlow;false;ReturnThis;(System.Object);;Argument[this];ReturnValue;value;df-generated
    // contentbased-summary=Models;BasicFlow;false;ReturnThis;(System.Object);;Argument[this];ReturnValue;value;df-generated
    public BasicFlow ReturnThis(object input)
    {
        return this;
    }

    // summary=Models;BasicFlow;false;ReturnParam0;(System.String,System.Object);;Argument[0];ReturnValue;taint;df-generated
    // contentbased-summary=Models;BasicFlow;false;ReturnParam0;(System.String,System.Object);;Argument[0];ReturnValue;value;df-generated
    public string ReturnParam0(string input0, object input1)
    {
        return input0;
    }

    // summary=Models;BasicFlow;false;ReturnParam1;(System.String,System.Object);;Argument[1];ReturnValue;taint;df-generated
    // contentbased-summary=Models;BasicFlow;false;ReturnParam1;(System.String,System.Object);;Argument[1];ReturnValue;value;df-generated
    public object ReturnParam1(string input0, object input1)
    {
        return input1;
    }

    // summary=Models;BasicFlow;false;ReturnParamMultiple;(System.Object,System.Object);;Argument[0];ReturnValue;taint;df-generated
    // summary=Models;BasicFlow;false;ReturnParamMultiple;(System.Object,System.Object);;Argument[1];ReturnValue;taint;df-generated
    // contentbased-summary=Models;BasicFlow;false;ReturnParamMultiple;(System.Object,System.Object);;Argument[0];ReturnValue;value;df-generated
    // contentbased-summary=Models;BasicFlow;false;ReturnParamMultiple;(System.Object,System.Object);;Argument[1];ReturnValue;value;df-generated
    public object ReturnParamMultiple(object input0, object input1)
    {
        return (System.DateTime.Now.DayOfWeek == System.DayOfWeek.Monday) ? input0 : input1;
    }

    // summary=Models;BasicFlow;false;ReturnSubstring;(System.String);;Argument[0];ReturnValue;taint;df-generated
    // contentbased-summary=Models;BasicFlow;false;ReturnSubstring;(System.String);;Argument[0];ReturnValue;taint;df-generated
    public string ReturnSubstring(string s)
    {
        return s.Substring(0, 1);
    }

    // summary=Models;BasicFlow;false;SetField;(System.String);;Argument[0];Argument[this];taint;df-generated
    // contentbased-summary=Models;BasicFlow;false;SetField;(System.String);;Argument[0];Argument[this].SyntheticField[Models.BasicFlow.tainted];value;df-generated
    public void SetField(string s)
    {
        tainted = s;
    }

    // summary=Models;BasicFlow;false;ReturnField;();;Argument[this];ReturnValue;taint;df-generated
    // contentbased-summary=Models;BasicFlow;false;ReturnField;();;Argument[this].SyntheticField[Models.BasicFlow.tainted];ReturnValue;value;df-generated
    public string ReturnField()
    {
        return tainted;
    }
}

public class CollectionFlow
{
    private readonly string tainted;

    // summary=Models;CollectionFlow;false;CollectionFlow;(System.String);;Argument[0];Argument[this];taint;df-generated
    // contentbased-summary=Models;CollectionFlow;false;CollectionFlow;(System.String);;Argument[0];Argument[this].SyntheticField[Models.CollectionFlow.tainted];value;df-generated
    public CollectionFlow(string s)
    {
        tainted = s;
    }

    // summary=Models;CollectionFlow;false;ReturnArrayElement;(System.Object[]);;Argument[0].Element;ReturnValue;taint;df-generated
    // contentbased-summary=Models;CollectionFlow;false;ReturnArrayElement;(System.Object[]);;Argument[0].Element;ReturnValue;value;df-generated
    public object ReturnArrayElement(object[] input)
    {
        return input[0];
    }

    // summary=Models;CollectionFlow;false;AssignToArray;(System.Object,System.Object[]);;Argument[0];Argument[1].Element;taint;df-generated
    // contentbased-summary=Models;CollectionFlow;false;AssignToArray;(System.Object,System.Object[]);;Argument[0];Argument[1].Element;value;df-generated
    public void AssignToArray(object data, object[] target)
    {
        target[0] = data;
    }

    // summary=Models;CollectionFlow;false;AssignFieldToArray;(System.Object[]);;Argument[this];Argument[0].Element;taint;df-generated
    // contentbased-summary=Models;CollectionFlow;false;AssignFieldToArray;(System.Object[]);;Argument[this].SyntheticField[Models.CollectionFlow.tainted];Argument[0].Element;value;df-generated
    public void AssignFieldToArray(object[] target)
    {
        target[0] = tainted;
    }

    // summary=Models;CollectionFlow;false;ReturnListElement;(System.Collections.Generic.List<System.Object>);;Argument[0].Element;ReturnValue;taint;df-generated
    // contentbased-summary=Models;CollectionFlow;false;ReturnListElement;(System.Collections.Generic.List<System.Object>);;Argument[0].Element;ReturnValue;value;df-generated
    public object ReturnListElement(List<object> input)
    {
        return input[0];
    }

    // summary=Models;CollectionFlow;false;AddToList;(System.Collections.Generic.List<System.Object>,System.Object);;Argument[1];Argument[0].Element;taint;df-generated
    // contentbased-summary=Models;CollectionFlow;false;AddToList;(System.Collections.Generic.List<System.Object>,System.Object);;Argument[1];Argument[0].Element;value;df-generated
    public void AddToList(List<object> input, object data)
    {
        input.Add(data);
    }

    // summary=Models;CollectionFlow;false;AddFieldToList;(System.Collections.Generic.List<System.String>);;Argument[this];Argument[0].Element;taint;df-generated
    // contentbased-summary=Models;CollectionFlow;false;AddFieldToList;(System.Collections.Generic.List<System.String>);;Argument[this].SyntheticField[Models.CollectionFlow.tainted];Argument[0].Element;value;df-generated
    public void AddFieldToList(List<string> input)
    {
        input.Add(tainted);
    }

    // summary=Models;CollectionFlow;false;ReturnFieldInAList;();;Argument[this];ReturnValue;taint;df-generated
    // contentbased-summary=Models;CollectionFlow;false;ReturnFieldInAList;();;Argument[this].SyntheticField[Models.CollectionFlow.tainted];ReturnValue.Element;value;df-generated
    public List<string> ReturnFieldInAList()
    {
        return new List<string> { tainted };
    }

    // SPURIOUS-summary=Models;CollectionFlow;false;ReturnComplexTypeArray;(System.String[]);;Argument[0].Element;ReturnValue;taint;df-generated
    // contentbased-summary=Models;CollectionFlow;false;ReturnComplexTypeArray;(System.String[]);;Argument[0];ReturnValue;value;df-generated
    public string[] ReturnComplexTypeArray(string[] a)
    {
        return a;
    }

    // SPURIOUS-summary=Models;CollectionFlow;false;ReturnBulkTypeList;(System.Collections.Generic.List<System.Byte>);;Argument[0].Element;ReturnValue;taint;df-generated
    // contentbased-summary=Models;CollectionFlow;false;ReturnBulkTypeList;(System.Collections.Generic.List<System.Byte>);;Argument[0];ReturnValue;value;df-generated
    public List<byte> ReturnBulkTypeList(List<byte> a)
    {
        return a;
    }

    // SPURIOUS-summary=Models;CollectionFlow;false;ReturnComplexTypeDictionary;(System.Collections.Generic.Dictionary<System.Int32,System.String>);;Argument[0].Element;ReturnValue;taint;df-generated
    // contentbased-summary=Models;CollectionFlow;false;ReturnComplexTypeDictionary;(System.Collections.Generic.Dictionary<System.Int32,System.String>);;Argument[0];ReturnValue;value;df-generated
    public Dictionary<int, string> ReturnComplexTypeDictionary(Dictionary<int, string> a)
    {
        return a;
    }

    // SPURIOUS-summary=Models;CollectionFlow;false;ReturnUntypedArray;(System.Array);;Argument[0].Element;ReturnValue;taint;df-generated
    // contentbased-summary=Models;CollectionFlow;false;ReturnUntypedArray;(System.Array);;Argument[0];ReturnValue;value;df-generated
    public Array ReturnUntypedArray(Array a)
    {
        return a;
    }

    // SPURIOUS-summary=Models;CollectionFlow;false;ReturnUntypedList;(System.Collections.IList);;Argument[0].Element;ReturnValue;taint;df-generated
    // contentbased-summary=Models;CollectionFlow;false;ReturnUntypedList;(System.Collections.IList);;Argument[0];ReturnValue;value;df-generated
    public IList ReturnUntypedList(IList a)
    {
        return a;
    }

    // No flow as this is collection is of simple types.
    // neutral=Models;CollectionFlow;ReturnSimpleTypeArray;(System.Int32[]);summary;df-generated
    public int[] ReturnSimpleTypeArray(int[] a)
    {
        return a;
    }

    // No flow as this is collection is of simple types.
    // neutral=Models;CollectionFlow;ReturnSimpleTypeList;(System.Collections.Generic.List<System.Int32>);summary;df-generated
    public List<int> ReturnSimpleTypeList(List<int> a)
    {
        return a;
    }

    // No flow as this is collection is of simple types.
    // neutral=Models;CollectionFlow;ReturnSimpleTypeDictionary;(System.Collections.Generic.Dictionary<System.Int32,System.Int32>);summary;df-generated
    public Dictionary<int, int> ReturnSimpleTypeDictionary(Dictionary<int, int> a)
    {
        return a;
    }

}

public class IEnumerableFlow
{
    private readonly string tainted;

    // summary=Models;IEnumerableFlow;false;IEnumerableFlow;(System.String);;Argument[0];Argument[this];taint;df-generated
    // contentbased-summary=Models;IEnumerableFlow;false;IEnumerableFlow;(System.String);;Argument[0];Argument[this].SyntheticField[Models.IEnumerableFlow.tainted];value;df-generated
    public IEnumerableFlow(string s)
    {
        tainted = s;
    }

    // SPURIOUS-summary=Models;IEnumerableFlow;false;ReturnIEnumerable;(System.Collections.Generic.IEnumerable<System.String>);;Argument[0].Element;ReturnValue;taint;df-generated
    // contentbased-summary=Models;IEnumerableFlow;false;ReturnIEnumerable;(System.Collections.Generic.IEnumerable<System.String>);;Argument[0];ReturnValue;value;df-generated
    public IEnumerable<string> ReturnIEnumerable(IEnumerable<string> input)
    {
        return input;
    }

    // summary=Models;IEnumerableFlow;false;ReturnIEnumerableElement;(System.Collections.Generic.IEnumerable<System.Object>);;Argument[0].Element;ReturnValue;taint;df-generated
    // contentbased-summary=Models;IEnumerableFlow;false;ReturnIEnumerableElement;(System.Collections.Generic.IEnumerable<System.Object>);;Argument[0].Element;ReturnValue;value;df-generated
    public object ReturnIEnumerableElement(IEnumerable<object> input)
    {
        return input.First();
    }

    // summary=Models;IEnumerableFlow;false;ReturnFieldInIEnumerable;();;Argument[this];ReturnValue;taint;df-generated
    // contentbased-summary=Models;IEnumerableFlow;false;ReturnFieldInIEnumerable;();;Argument[this].SyntheticField[Models.IEnumerableFlow.tainted];ReturnValue.Element;value;df-generated
    public IEnumerable<string> ReturnFieldInIEnumerable()
    {
        return new List<string> { tainted };
    }
}

public class GenericFlow<T>
{
    private T tainted;

    // summary=Models;GenericFlow<T>;false;SetGenericField;(T);;Argument[0];Argument[this];taint;df-generated
    // contentbased-summary=Models;GenericFlow<T>;false;SetGenericField;(T);;Argument[0];Argument[this].SyntheticField[Models.GenericFlow`1.tainted];value;df-generated
    public void SetGenericField(T t)
    {
        tainted = t;
    }

    // summary=Models;GenericFlow<T>;false;ReturnGenericField;();;Argument[this];ReturnValue;taint;df-generated
    // contentbased-summary=Models;GenericFlow<T>;false;ReturnGenericField;();;Argument[this].SyntheticField[Models.GenericFlow`1.tainted];ReturnValue;value;df-generated
    public T ReturnGenericField()
    {
        return tainted;
    }

    // summary=Models;GenericFlow<T>;false;AddFieldToGenericList;(System.Collections.Generic.List<T>);;Argument[this];Argument[0].Element;taint;df-generated
    // contentbased-summary=Models;GenericFlow<T>;false;AddFieldToGenericList;(System.Collections.Generic.List<T>);;Argument[this].SyntheticField[Models.GenericFlow`1.tainted];Argument[0].Element;value;df-generated
    public void AddFieldToGenericList(List<T> input)
    {
        input.Add(tainted);
    }

    // summary=Models;GenericFlow<T>;false;ReturnFieldInGenericList;();;Argument[this];ReturnValue;taint;df-generated
    // contentbased-summary=Models;GenericFlow<T>;false;ReturnFieldInGenericList;();;Argument[this].SyntheticField[Models.GenericFlow`1.tainted];ReturnValue.Element;value;df-generated
    public List<T> ReturnFieldInGenericList()
    {
        return new List<T> { tainted };
    }

    // summary=Models;GenericFlow<T>;false;ReturnGenericParam<S>;(S);;Argument[0];ReturnValue;taint;df-generated
    // contentbased-summary=Models;GenericFlow<T>;false;ReturnGenericParam<S>;(S);;Argument[0];ReturnValue;value;df-generated
    public S ReturnGenericParam<S>(S input)
    {
        return input;
    }

    // summary=Models;GenericFlow<T>;false;ReturnGenericElement<S>;(System.Collections.Generic.List<S>);;Argument[0].Element;ReturnValue;taint;df-generated
    // contentbased-summary=Models;GenericFlow<T>;false;ReturnGenericElement<S>;(System.Collections.Generic.List<S>);;Argument[0].Element;ReturnValue;value;df-generated
    public S ReturnGenericElement<S>(List<S> input)
    {
        return input[0];
    }

    // summary=Models;GenericFlow<T>;false;AddToGenericList<S>;(System.Collections.Generic.List<S>,S);;Argument[1];Argument[0].Element;taint;df-generated
    // contentbased-summary=Models;GenericFlow<T>;false;AddToGenericList<S>;(System.Collections.Generic.List<S>,S);;Argument[1];Argument[0].Element;value;df-generated
    public void AddToGenericList<S>(List<S> input, S data)
    {
        input.Add(data);
    }
}

public abstract class BaseClassFlow
{
    // summary=Models;BaseClassFlow;true;ReturnParam;(System.Object);;Argument[0];ReturnValue;taint;df-generated
    // contentbased-summary=Models;BaseClassFlow;true;ReturnParam;(System.Object);;Argument[0];ReturnValue;value;df-generated
    public virtual object ReturnParam(object input)
    {
        return input;
    }
}

public class DerivedClass1Flow : BaseClassFlow
{
    // summary=Models;DerivedClass1Flow;false;ReturnParam1;(System.String,System.String);;Argument[1];ReturnValue;taint;df-generated
    // contentbased-summary=Models;DerivedClass1Flow;false;ReturnParam1;(System.String,System.String);;Argument[1];ReturnValue;value;df-generated
    public string ReturnParam1(string input0, string input1)
    {
        return input1;
    }
}

public class DerivedClass2Flow : BaseClassFlow
{
    // summary=Models;BaseClassFlow;true;ReturnParam;(System.Object);;Argument[0];ReturnValue;taint;df-generated
    // contentbased-summary=Models;BaseClassFlow;true;ReturnParam;(System.Object);;Argument[0];ReturnValue;value;df-generated
    public override object ReturnParam(object input)
    {
        return input;
    }

    // summary=Models;DerivedClass2Flow;false;ReturnParam0;(System.String,System.Int32);;Argument[0];ReturnValue;taint;df-generated
    // contentbased-summary=Models;DerivedClass2Flow;false;ReturnParam0;(System.String,System.Int32);;Argument[0];ReturnValue;value;df-generated
    public string ReturnParam0(string input0, int input1)
    {
        return input0;
    }
}

public class OperatorFlow
{
    public readonly object Field;

    // summary=Models;OperatorFlow;false;OperatorFlow;(System.Object);;Argument[0];Argument[this];taint;df-generated
    // contentbased-summary=Models;OperatorFlow;false;OperatorFlow;(System.Object);;Argument[0];Argument[this].Field[Models.OperatorFlow.Field];value;df-generated
    public OperatorFlow(object o)
    {
        Field = o;
    }

    // Flow Summary.
    // summary=Models;OperatorFlow;false;op_Addition;(Models.OperatorFlow,Models.OperatorFlow);;Argument[0];ReturnValue;taint;df-generated
    // contentbased-summary=Models;OperatorFlow;false;op_Addition;(Models.OperatorFlow,Models.OperatorFlow);;Argument[0];ReturnValue;value;df-generated
    public static OperatorFlow operator +(OperatorFlow a, OperatorFlow b)
    {
        return a;
    }

    // No flow summary.
    // neutral=Models;OperatorFlow;op_Increment;(Models.OperatorFlow);summary;df-generated
    public static OperatorFlow operator ++(OperatorFlow a)
    {
        return new OperatorFlow(new object());
    }

    // No model as user defined conversion operators are excluded
    // from model generation.
    public static implicit operator OperatorFlow(string s)
    {
        return new OperatorFlow(s);
    }

    // No model as user defined conversion operators are excluded
    // from model generation.
    public static explicit operator OperatorFlow(string[] b)
    {
        return new OperatorFlow(b);
    }

}

public class EqualsGetHashCodeNoFlow
{
    public readonly bool boolTainted;
    public readonly int intTainted;

    // neutral=Models;EqualsGetHashCodeNoFlow;Equals;(System.Object);summary;df-generated
    public override bool Equals(object obj)
    {
        return boolTainted;
    }

    // summary=Models;EqualsGetHashCodeNoFlow;false;Equals;(System.String);;Argument[0];ReturnValue;taint;df-generated
    // contentbased-summary=Models;EqualsGetHashCodeNoFlow;false;Equals;(System.String);;Argument[0];ReturnValue;value;df-generated
    public string Equals(string s)
    {
        return s;
    }

    // neutral=Models;EqualsGetHashCodeNoFlow;GetHashCode;();summary;df-generated
    public override int GetHashCode()
    {
        return intTainted;
    }
}

public class Properties
{
    private string tainted;

    // summary=Models;Properties;false;get_Prop1;();;Argument[this];ReturnValue;taint;df-generated
    // contentbased-summary=Models;Properties;false;get_Prop1;();;Argument[this].SyntheticField[Models.Properties.tainted];ReturnValue;value;df-generated
    public string Prop1
    {
        get { return tainted; }
    }

    // summary=Models;Properties;false;set_Prop2;(System.String);;Argument[0];Argument[this];taint;df-generated
    // contentbased-summary=Models;Properties;false;set_Prop2;(System.String);;Argument[0];Argument[this].SyntheticField[Models.Properties.tainted];value;df-generated
    public string Prop2
    {
        set { tainted = value; }
    }

    public object backingField;
    // No model as properties with public getters and setters are excluded from
    // model generation as these are handled directly by the dataflow library.
    public object Prop
    {
        get { return backingField; }
        set { backingField = value; }
    }
}

// No models as the methods are not public.
public sealed class PublicClassNoFlow
{
    private object PrivateReturn(object input)
    {
        return input;
    }

    internal object InternalReturn(object input)
    {
        return input;
    }

    private class PrivateClassNoFlow
    {
        public object ReturnParam(object input)
        {
            return input;
        }
    }

    private class PrivateClassNestedPublicClassNoFlow
    {
        public class NestedPublicClassFlow
        {
            public object ReturnParam(object input)
            {
                return input;
            }
        }
    }
}

public class EquatableBound : IEquatable<object>
{
    public readonly bool tainted;

    // neutral=Models;EquatableBound;Equals;(System.Object);summary;df-generated
    public bool Equals(object other)
    {
        return tainted;
    }
}

public class EquatableUnBound<T> : IEquatable<T>
{
    public readonly bool tainted;

    // neutral=Models;EquatableUnBound<T>;Equals;(T);summary;df-generated
    public bool Equals(T? other)
    {
        return tainted;
    }
}

// No methods in this class will have generated flow summaries as
// simple types are used.
public class SimpleTypes
{
    // neutral=Models;SimpleTypes;M1;(System.Boolean);summary;df-generated
    public bool M1(bool b)
    {
        return b;
    }

    // neutral=Models;SimpleTypes;M2;(System.Boolean);summary;df-generated
    public Boolean M2(Boolean b)
    {
        return b;
    }

    // neutral=Models;SimpleTypes;M3;(System.Int32);summary;df-generated
    public int M3(int i)
    {
        return i;
    }

    // neutral=Models;SimpleTypes;M4;(System.Int32);summary;df-generated
    public Int32 M4(Int32 i)
    {
        return i;
    }

    // neutral=Models;SimpleTypes;M5;(System.DateTime);summary;df-generated
    public DateTime M5(DateTime d)
    {
        return d;
    }

    // neutral=Models;SimpleTypes;M6;(System.Type);summary;df-generated
    public Type M6(Type t)
    {
        return t;
    }
}

// No models as higher order methods are excluded
// from model generation.
public class HigherOrderParameters
{
    public string M1(string s, Func<string, string> map)
    {
        return s;
    }

    public object M2(Func<object, object> map, object o)
    {
        return map(o);
    }
}

public abstract class BaseClass
{
    // neutral=Models;BaseClass;M1;(System.String);summary;df-generated
    public virtual string M1(string s)
    {
        return "";
    }

    // neutral=Models;BaseClass;M2;(System.String);summary;df-generated
    public abstract string M2(string s);
}

// No models as manually modelled methods are excluded from
// model generation.
public class ManuallyModelled
{
    public object HasSummary(object o)
    {
        return o;
    }

    public object HasNeutralSummary(object o)
    {
        return o;
    }

    public object HasNeutralSummaryNoFlow(object o)
    {
        return null;
    }
}

public class ParameterlessConstructor
{
    public bool IsInitialized;

    // No model as parameterless constructors
    // are excluded from model generation.
    public ParameterlessConstructor()
    {
        IsInitialized = true;
    }
}

public class Inheritance
{
    public abstract class BasePublic
    {
        public abstract string Id(string x);
    }

    public class AImplBasePublic : BasePublic
    {
        // summary=Models;Inheritance+BasePublic;true;Id;(System.String);;Argument[0];ReturnValue;taint;df-generated
        // contentbased-summary=Models;Inheritance+BasePublic;true;Id;(System.String);;Argument[0];ReturnValue;value;df-generated
        public override string Id(string x)
        {
            return x;
        }
    }

    public interface IPublic1
    {
        string Id(string x);
    }

    public interface IPublic2
    {
        string Id(string x);
    }

    public abstract class B : IPublic1
    {
        public abstract string Id(string x);
    }

    private abstract class C : IPublic2
    {
        public abstract string Id(string x);
    }

    public class BImpl : B
    {
        // summary=Models;Inheritance+IPublic1;true;Id;(System.String);;Argument[0];ReturnValue;taint;df-generated
        // contentbased-summary=Models;Inheritance+IPublic1;true;Id;(System.String);;Argument[0];ReturnValue;value;df-generated
        public override string Id(string x)
        {
            return x;
        }
    }

    private class CImpl : C
    {
        // summary=Models;Inheritance+IPublic2;true;Id;(System.String);;Argument[0];ReturnValue;taint;df-generated
        // contentbased-summary=Models;Inheritance+IPublic2;true;Id;(System.String);;Argument[0];ReturnValue;value;df-generated
        public override string Id(string x)
        {
            return x;
        }
    }

    public interface IPublic3
    {
        string Prop { get; }
    }

    public abstract class D : IPublic3
    {
        public abstract string Prop { get; }
    }

    public class DImpl : D
    {
        private readonly string tainted;

        // summary=Models;Inheritance+DImpl;false;DImpl;(System.String);;Argument[0];Argument[this];taint;df-generated
        // contentbased-summary=Models;Inheritance+DImpl;false;DImpl;(System.String);;Argument[0];Argument[this].SyntheticField[Models.Inheritance+DImpl.tainted];value;df-generated
        public DImpl(string s)
        {
            tainted = s;
        }

        // summary=Models;Inheritance+IPublic3;true;get_Prop;();;Argument[this];ReturnValue;taint;df-generated
        // contentbased-summary=Models;Inheritance+DImpl;true;get_Prop;();;Argument[this].SyntheticField[Models.Inheritance+DImpl.tainted];ReturnValue;value;df-generated
        public override string Prop { get { return tainted; } }
    }
}

public class MemberFlow
{
    public class C
    {
        public string Prop { get; set; }

        public string Field;
    }

    // summary=Models;MemberFlow;false;M1;(Models.MemberFlow+C);;Argument[0];ReturnValue;taint;df-generated
    // contentbased-summary=Models;MemberFlow;false;M1;(Models.MemberFlow+C);;Argument[0].Property[Models.MemberFlow+C.Prop];ReturnValue;value;df-generated
    public string M1(C c)
    {
        return c.Prop;
    }

    // summary=Models;MemberFlow;false;M2;(Models.MemberFlow+C);;Argument[0];ReturnValue;taint;df-generated
    // contentbased-summary=Models;MemberFlow;false;M2;(Models.MemberFlow+C);;Argument[0].Field[Models.MemberFlow+C.Field];ReturnValue;value;df-generated
    public string M2(C c)
    {
        return c.Field;
    }
}

public class IDictionaryFlow
{
    // summary=Models;IDictionaryFlow;false;ReturnIDictionaryValue;(System.Collections.Generic.IDictionary<System.Object,System.Object>,System.Object);;Argument[0].Element;ReturnValue;taint;df-generated
    // contentbased-summary=Models;IDictionaryFlow;false;ReturnIDictionaryValue;(System.Collections.Generic.IDictionary<System.Object,System.Object>,System.Object);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair`2.Value];ReturnValue;value;df-generated
    public object ReturnIDictionaryValue(IDictionary<object, object> input, object key)
    {
        return input[key];
    }
}

public class NestedFieldFlow
{
    public NestedFieldFlow FieldA;
    public NestedFieldFlow FieldB;

    // summary=Models;NestedFieldFlow;false;Move;();;Argument[this];ReturnValue;taint;df-generated
    // contentbased-summary=Models;NestedFieldFlow;false;Move;();;Argument[this].Field[Models.NestedFieldFlow.FieldA];ReturnValue.Field[Models.NestedFieldFlow.FieldB];value;df-generated
    public NestedFieldFlow Move()
    {
        return new NestedFieldFlow() { FieldB = this.FieldA };
    }

    // summary=Models;NestedFieldFlow;false;MoveNested;();;Argument[this];ReturnValue;taint;df-generated
    // contentbased-summary=Models;NestedFieldFlow;false;MoveNested;();;Argument[this].Field[Models.NestedFieldFlow.FieldB].Field[Models.NestedFieldFlow.FieldA];ReturnValue.Field[Models.NestedFieldFlow.FieldA].Field[Models.NestedFieldFlow.FieldB];value;df-generated
    public NestedFieldFlow MoveNested()
    {
        return new NestedFieldFlow() { FieldA = FieldB.Move() };
    }

    // summary=Models;NestedFieldFlow;false;ReverseFields;();;Argument[this];ReturnValue;taint;df-generated
    // contentbased-summary=Models;NestedFieldFlow;false;ReverseFields;();;Argument[this].Field[Models.NestedFieldFlow.FieldA].Field[Models.NestedFieldFlow.FieldB];ReturnValue.Field[Models.NestedFieldFlow.FieldA].Field[Models.NestedFieldFlow.FieldB];value;df-generated
    public NestedFieldFlow ReverseFields()
    {
        var x = new NestedFieldFlow() { FieldB = this.FieldA.FieldB };
        return new NestedFieldFlow() { FieldA = x };
    }
}

public class SyntheticFields
{
    private string value1;
    private string value2;
    private string value3;

    private string chainBegin;
    private string chainEnd;

    private string brokenChainBegin;
    private string brokenChainEnd;

    // summary=Models;SyntheticFields;false;SyntheticFields;(System.String);;Argument[0];Argument[this];taint;df-generated
    // contentbased-summary=Models;SyntheticFields;false;SyntheticFields;(System.String);;Argument[0];Argument[this].SyntheticField[Models.SyntheticFields.value1];value;df-generated
    public SyntheticFields(string v1)
    {
        value1 = v1;
    }

    // summary=Models;SyntheticFields;false;GetValue1;();;Argument[this];ReturnValue;taint;df-generated
    // contentbased-summary=Models;SyntheticFields;false;GetValue1;();;Argument[this].SyntheticField[Models.SyntheticFields.value1];ReturnValue;value;df-generated
    public string GetValue1()
    {
        return value1;
    }

    // summary=Models;SyntheticFields;false;GetValue2;();;Argument[this];ReturnValue;taint;df-generated
    // contentbased-summary=Models;SyntheticFields;false;GetValue2;();;Argument[this].SyntheticField[Models.SyntheticFields.value2];ReturnValue;value;df-generated
    public string GetValue2()
    {
        return value2;
    }

    // summary=Models;SyntheticFields;false;SetValue2;(System.String);;Argument[0];Argument[this];taint;df-generated
    // contentbased-summary=Models;SyntheticFields;false;SetValue2;(System.String);;Argument[0];Argument[this].SyntheticField[Models.SyntheticFields.value2];value;df-generated
    public void SetValue2(string v2)
    {
        value2 = v2;
    }

    // summary=Models;SyntheticFields;false;SetValue3;(System.String);;Argument[0];Argument[this];taint;df-generated
    // No content based summary as value3 is a dead synthetic field.
    public void SetValue3(string v3)
    {
        value3 = v3;
    }

    // summary=Models;SyntheticFields;false;SetChainBegin;(System.String);;Argument[0];Argument[this];taint;df-generated
    // contentbased-summary=Models;SyntheticFields;false;SetChainBegin;(System.String);;Argument[0];Argument[this].SyntheticField[Models.SyntheticFields.chainBegin];value;df-generated
    public void SetChainBegin(string v)
    {
        chainBegin = v;
    }

    // neutral=Models;SyntheticFields;CopyChainValue;();summary;df-generated
    // contentbased-summary=Models;SyntheticFields;false;CopyChainValue;();;Argument[this].SyntheticField[Models.SyntheticFields.chainBegin];Argument[this].SyntheticField[Models.SyntheticFields.chainEnd];value;df-generated
    public void CopyChainValue()
    {
        chainEnd = chainBegin;
    }

    // summary=Models;SyntheticFields;false;GetChainEnd;();;Argument[this];ReturnValue;taint;df-generated
    // contentbased-summary=Models;SyntheticFields;false;GetChainEnd;();;Argument[this].SyntheticField[Models.SyntheticFields.chainEnd];ReturnValue;value;df-generated
    public string GetChainEnd()
    {
        return chainEnd;
    }

    // summary=Models;SyntheticFields;false;SetBrokenChainBegin;(System.String);;Argument[0];Argument[this];taint;df-generated
    // No content based summary as brokenChainBegin is a dead synthetic field.
    public void SetBrokenChainBegin(string v)
    {
        brokenChainBegin = v;
    }

    // summary=Models;SyntheticFields;false;GetBrokenChainEnd;();;Argument[this];ReturnValue;taint;df-generated
    // No content based summary as brokenChainEnd is a dead synthetic field.
    public string GetBrokenChainEnd()
    {
        return brokenChainEnd;
    }

    public class InnerSyntheticFields
    {
        private readonly string value;

        // summary=Models;SyntheticFields+InnerSyntheticFields;false;InnerSyntheticFields;(System.String);;Argument[0];Argument[this];taint;df-generated
        // contentbased-summary=Models;SyntheticFields+InnerSyntheticFields;false;InnerSyntheticFields;(System.String);;Argument[0];Argument[this].SyntheticField[Models.SyntheticFields+InnerSyntheticFields.value];value;df-generated
        public InnerSyntheticFields(string v)
        {
            value = v;
        }

        // summary=Models;SyntheticFields+InnerSyntheticFields;false;GetValue;();;Argument[this];ReturnValue;taint;df-generated
        // contentbased-summary=Models;SyntheticFields+InnerSyntheticFields;false;GetValue;();;Argument[this].SyntheticField[Models.SyntheticFields+InnerSyntheticFields.value];ReturnValue;value;df-generated
        public string GetValue()
        {
            return value;
        }
    }

    // summary=Models;SyntheticFields;false;MakeInner;(System.String);;Argument[0];ReturnValue;taint;df-generated
    // contentbased-summary=Models;SyntheticFields;false;MakeInner;(System.String);;Argument[0];ReturnValue.SyntheticField[Models.SyntheticFields+InnerSyntheticFields.value];value;df-generated
    public InnerSyntheticFields MakeInner(string v)
    {
        return new InnerSyntheticFields(v);
    }
}

public class SyntheticProperties
{
    private string Prop1 { get; set; }

    private string Prop2 { get; set; }

    // summary=Models;SyntheticProperties;false;SyntheticProperties;(System.String);;Argument[0];Argument[this];taint;df-generated
    // contentbased-summary=Models;SyntheticProperties;false;SyntheticProperties;(System.String);;Argument[0];Argument[this].SyntheticField[Models.SyntheticProperties.Prop1];value;df-generated
    public SyntheticProperties(string v1)
    {
        Prop1 = v1;
    }

    // summary=Models;SyntheticProperties;false;GetProp1;();;Argument[this];ReturnValue;taint;df-generated
    // contentbased-summary=Models;SyntheticProperties;false;GetProp1;();;Argument[this].SyntheticField[Models.SyntheticProperties.Prop1];ReturnValue;value;df-generated
    public string GetProp1()
    {
        return Prop1;
    }

    // summary=Models;SyntheticProperties;false;SetProp2;(System.String);;Argument[0];Argument[this];taint;df-generated
    // No content based summary as Prop2 is a dead synthetic field.
    public void SetProp2(string v)
    {
        Prop2 = v;
    }
}
