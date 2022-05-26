using System;
using System.Linq;
using System.Collections.Generic;

namespace Summaries;

public class BasicFlow
{
    private string tainted;

    public BasicFlow ReturnThis(object input)
    {
        return this;
    }

    public string ReturnParam0(string input0, object input1)
    {
        return input0;
    }

    public object ReturnParam1(string input0, object input1)
    {
        return input1;
    }

    public object ReturnParamMultiple(object input0, object input1)
    {
        return (System.DateTime.Now.DayOfWeek == System.DayOfWeek.Monday) ? input0 : input1;
    }

    public string ReturnSubstring(string s)
    {
        return s.Substring(0, 1);
    }

    public void SetField(string s)
    {
        tainted = s;
    }

    public string ReturnField()
    {
        return tainted;
    }
}

public class CollectionFlow
{
    private string tainted;

    public object ReturnArrayElement(object[] input)
    {
        return input[0];
    }

    public void AssignToArray(object data, object[] target)
    {
        target[0] = data;
    }

    public void AssignFieldToArray(object[] target)
    {
        target[0] = tainted;
    }

    public object ReturnListElement(List<object> input)
    {
        return input[0];
    }

    public void AddToList(List<object> input, object data)
    {
        input.Add(data);
    }

    public void AddFieldToList(List<string> input)
    {
        input.Add(tainted);
    }

    public List<string> ReturnFieldInAList()
    {
        return new List<string> { tainted };
    }
}

public class IEnumerableFlow
{
    private string tainted;

    public IEnumerable<string> ReturnIEnumerable(IEnumerable<string> input)
    {
        return input;
    }

    public object ReturnIEnumerableElement(IEnumerable<object> input)
    {
        return input.First();
    }

    public IEnumerable<string> ReturnFieldInIEnumerable()
    {
        return new List<string> { tainted };
    }
}

public class GenericFlow<T>
{
    private T tainted;

    public void SetGenericField(T t)
    {
        tainted = t;
    }

    public T ReturnGenericField()
    {
        return tainted;
    }

    public void AddFieldToGenericList(List<T> input)
    {
        input.Add(tainted);
    }

    public List<T> ReturnFieldInGenericList()
    {
        return new List<T> { tainted };
    }

    public S ReturnGenericParam<S>(S input)
    {
        return input;
    }

    public S ReturnGenericElement<S>(List<S> input)
    {
        return input[0];
    }

    public void AddToGenericList<S>(List<S> input, S data)
    {
        input.Add(data);
    }
}

public abstract class BaseClassFlow
{
    public virtual object ReturnParam(object input)
    {
        return input;
    }
}

public class DerivedClass1Flow : BaseClassFlow
{
    public string ReturnParam1(string input0, string input1)
    {
        return input1;
    }
}

public class DerivedClass2Flow : BaseClassFlow
{
    public override object ReturnParam(object input)
    {
        return input;
    }

    public string ReturnParam0(string input0, int input1)
    {
        return input0;
    }
}

public class OperatorFlow
{
    public readonly object Field;

    public OperatorFlow(object o)
    {
        Field = o;
    }

    // Flow Summary.
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