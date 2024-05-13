using System;
using System.Linq;
using System.Collections;
using System.Collections.Generic;

namespace Summaries;

public class BasicFlow
{
    // No flow summary and no negative summary either.
    ~BasicFlow() { }

    private string tainted;

    // summary=Summaries;BasicFlow;false;ReturnThis;(System.Object);;Argument[this];ReturnValue;value;df-generated
    public BasicFlow ReturnThis(object input)
    {
        return this;
    }

    // summary=Summaries;BasicFlow;false;ReturnParam0;(System.String,System.Object);;Argument[0];ReturnValue;taint;df-generated
    public string ReturnParam0(string input0, object input1)
    {
        return input0;
    }

    // summary=Summaries;BasicFlow;false;ReturnParam1;(System.String,System.Object);;Argument[1];ReturnValue;taint;df-generated
    public object ReturnParam1(string input0, object input1)
    {
        return input1;
    }

    // summary=Summaries;BasicFlow;false;ReturnParamMultiple;(System.Object,System.Object);;Argument[0];ReturnValue;taint;df-generated
    // summary=Summaries;BasicFlow;false;ReturnParamMultiple;(System.Object,System.Object);;Argument[1];ReturnValue;taint;df-generated
    public object ReturnParamMultiple(object input0, object input1)
    {
        return (System.DateTime.Now.DayOfWeek == System.DayOfWeek.Monday) ? input0 : input1;
    }

    // summary=Summaries;BasicFlow;false;ReturnSubstring;(System.String);;Argument[0];ReturnValue;taint;df-generated
    public string ReturnSubstring(string s)
    {
        return s.Substring(0, 1);
    }

    // summary=Summaries;BasicFlow;false;SetField;(System.String);;Argument[0];Argument[this];taint;df-generated
    public void SetField(string s)
    {
        tainted = s;
    }

    // summary=Summaries;BasicFlow;false;ReturnField;();;Argument[this];ReturnValue;taint;df-generated
    public string ReturnField()
    {
        return tainted;
    }
}

public class CollectionFlow
{
    private string tainted;

    // summary=Summaries;CollectionFlow;false;ReturnArrayElement;(System.Object[]);;Argument[0].Element;ReturnValue;taint;df-generated
    public object ReturnArrayElement(object[] input)
    {
        return input[0];
    }

    // summary=Summaries;CollectionFlow;false;AssignToArray;(System.Object,System.Object[]);;Argument[0];Argument[1].Element;taint;df-generated
    public void AssignToArray(object data, object[] target)
    {
        target[0] = data;
    }

    // summary=Summaries;CollectionFlow;false;AssignFieldToArray;(System.Object[]);;Argument[this];Argument[0].Element;taint;df-generated
    public void AssignFieldToArray(object[] target)
    {
        target[0] = tainted;
    }

    // summary=Summaries;CollectionFlow;false;ReturnListElement;(System.Collections.Generic.List<System.Object>);;Argument[0].Element;ReturnValue;taint;df-generated
    public object ReturnListElement(List<object> input)
    {
        return input[0];
    }

    // summary=Summaries;CollectionFlow;false;AddToList;(System.Collections.Generic.List<System.Object>,System.Object);;Argument[1];Argument[0].Element;taint;df-generated
    public void AddToList(List<object> input, object data)
    {
        input.Add(data);
    }

    // summary=Summaries;CollectionFlow;false;AddFieldToList;(System.Collections.Generic.List<System.String>);;Argument[this];Argument[0].Element;taint;df-generated
    public void AddFieldToList(List<string> input)
    {
        input.Add(tainted);
    }

    // summary=Summaries;CollectionFlow;false;ReturnFieldInAList;();;Argument[this];ReturnValue;taint;df-generated
    public List<string> ReturnFieldInAList()
    {
        return new List<string> { tainted };
    }

    // summary=Summaries;CollectionFlow;false;ReturnComplexTypeArray;(System.String[]);;Argument[0].Element;ReturnValue;taint;df-generated
    public string[] ReturnComplexTypeArray(string[] a)
    {
        return a;
    }

    // summary=Summaries;CollectionFlow;false;ReturnBulkTypeList;(System.Collections.Generic.List<System.Byte>);;Argument[0].Element;ReturnValue;taint;df-generated
    public List<byte> ReturnBulkTypeList(List<byte> a)
    {
        return a;
    }

    // summary=Summaries;CollectionFlow;false;ReturnComplexTypeDictionary;(System.Collections.Generic.Dictionary<System.Int32,System.String>);;Argument[0].Element;ReturnValue;taint;df-generated
    public Dictionary<int, string> ReturnComplexTypeDictionary(Dictionary<int, string> a)
    {
        return a;
    }

    // summary=Summaries;CollectionFlow;false;ReturnUntypedArray;(System.Array);;Argument[0].Element;ReturnValue;taint;df-generated
    public Array ReturnUntypedArray(Array a)
    {
        return a;
    }

    // summary=Summaries;CollectionFlow;false;ReturnUntypedList;(System.Collections.IList);;Argument[0].Element;ReturnValue;taint;df-generated
    public IList ReturnUntypedList(IList a)
    {
        return a;
    }
}

public class IEnumerableFlow
{
    private string tainted;

    // summary=Summaries;IEnumerableFlow;false;ReturnIEnumerable;(System.Collections.Generic.IEnumerable<System.String>);;Argument[0].Element;ReturnValue;taint;df-generated
    public IEnumerable<string> ReturnIEnumerable(IEnumerable<string> input)
    {
        return input;
    }

    // summary=Summaries;IEnumerableFlow;false;ReturnIEnumerableElement;(System.Collections.Generic.IEnumerable<System.Object>);;Argument[0].Element;ReturnValue;taint;df-generated
    public object ReturnIEnumerableElement(IEnumerable<object> input)
    {
        return input.First();
    }

    // summary=Summaries;IEnumerableFlow;false;ReturnFieldInIEnumerable;();;Argument[this];ReturnValue;taint;df-generated
    public IEnumerable<string> ReturnFieldInIEnumerable()
    {
        return new List<string> { tainted };
    }
}

public class GenericFlow<T>
{
    private T tainted;

    // summary=Summaries;GenericFlow<T>;false;SetGenericField;(T);;Argument[0];Argument[this];taint;df-generated
    public void SetGenericField(T t)
    {
        tainted = t;
    }

    // summary=Summaries;GenericFlow<T>;false;ReturnGenericField;();;Argument[this];ReturnValue;taint;df-generated
    public T ReturnGenericField()
    {
        return tainted;
    }

    // summary=Summaries;GenericFlow<T>;false;AddFieldToGenericList;(System.Collections.Generic.List<T>);;Argument[this];Argument[0].Element;taint;df-generated
    public void AddFieldToGenericList(List<T> input)
    {
        input.Add(tainted);
    }

    // summary=Summaries;GenericFlow<T>;false;ReturnFieldInGenericList;();;Argument[this];ReturnValue;taint;df-generated
    public List<T> ReturnFieldInGenericList()
    {
        return new List<T> { tainted };
    }

    // summary=Summaries;GenericFlow<T>;false;ReturnGenericParam<S>;(S);;Argument[0];ReturnValue;taint;df-generated
    public S ReturnGenericParam<S>(S input)
    {
        return input;
    }

    // summary=Summaries;GenericFlow<T>;false;ReturnGenericElement<S>;(System.Collections.Generic.List<S>);;Argument[0].Element;ReturnValue;taint;df-generated
    public S ReturnGenericElement<S>(List<S> input)
    {
        return input[0];
    }

    // summary=Summaries;GenericFlow<T>;false;AddToGenericList<S>;(System.Collections.Generic.List<S>,S);;Argument[1];Argument[0].Element;taint;df-generated
    public void AddToGenericList<S>(List<S> input, S data)
    {
        input.Add(data);
    }
}

public abstract class BaseClassFlow
{
    // summary=Summaries;BaseClassFlow;true;ReturnParam;(System.Object);;Argument[0];ReturnValue;taint;df-generated
    public virtual object ReturnParam(object input)
    {
        return input;
    }
}

public class DerivedClass1Flow : BaseClassFlow
{
    // summary=Summaries;DerivedClass1Flow;false;ReturnParam1;(System.String,System.String);;Argument[1];ReturnValue;taint;df-generated
    public string ReturnParam1(string input0, string input1)
    {
        return input1;
    }
}

public class DerivedClass2Flow : BaseClassFlow
{
    // summary=Summaries;DerivedClass2Flow;false;ReturnParam;(System.Object);;Argument[0];ReturnValue;taint;df-generated
    public override object ReturnParam(object input)
    {
        return input;
    }

    // summary=Summaries;DerivedClass2Flow;false;ReturnParam0;(System.String,System.Int32);;Argument[0];ReturnValue;taint;df-generated
    public string ReturnParam0(string input0, int input1)
    {
        return input0;
    }
}

public class OperatorFlow
{
    public readonly object Field;

    // summary=Summaries;OperatorFlow;false;OperatorFlow;(System.Object);;Argument[0];Argument[this];taint;df-generated
    public OperatorFlow(object o)
    {
        Field = o;
    }

    // Flow Summary.
    // summary=Summaries;OperatorFlow;false;op_Addition;(Summaries.OperatorFlow,Summaries.OperatorFlow);;Argument[0];ReturnValue;taint;df-generated
    public static OperatorFlow operator +(OperatorFlow a, OperatorFlow b)
    {
        return a;
    }

    // No flow summary.
    public static OperatorFlow operator ++(OperatorFlow a)
    {
        return new OperatorFlow(new object());
    }

    // No flow summary as this is an implicit conversion operator.
    public static implicit operator OperatorFlow(string s)
    {
        return new OperatorFlow(s);
    }

    // No flow summary as this is an explicit conversion operator.
    public static explicit operator OperatorFlow(string[] b)
    {
        return new OperatorFlow(b);
    }

}

public class EqualsGetHashCodeNoFlow
{
    public readonly bool boolTainted;
    public readonly int intTainted;

    // No flow summary as this is an override of the Equals method.
    public override bool Equals(object obj)
    {
        return boolTainted;
    }

    // Flow summary as this is not an override of the object Equals method.
    // summary=Summaries;EqualsGetHashCodeNoFlow;false;Equals;(System.String);;Argument[0];ReturnValue;taint;df-generated
    public string Equals(string s)
    {
        return s;
    }

    // No flow summary as this is an override of the GetHashCode method.
    public override int GetHashCode()
    {
        return intTainted;
    }
}

public class Properties
{
    private string tainted;

    // summary=Summaries;Properties;false;get_Prop1;();;Argument[this];ReturnValue;taint;df-generated
    public string Prop1
    {
        get { return tainted; }
    }

    // summary=Summaries;Properties;false;set_Prop2;(System.String);;Argument[0];Argument[this];taint;df-generated
    public string Prop2
    {
        set { tainted = value; }
    }
}
