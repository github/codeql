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

    public int ReturnArrayElement(int[] input)
    {
        return input[0];
    }

    public void AssignToArray(int data, int[] target)
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

public class BulkArrayFlow
{
    private char tainted;

    public void AssignToBulkArray(char[] input, char data)
    {
        input[0] = data;
    }

    public byte ReturnBulkArrayElement(byte[] input)
    {
        return input[0];
    }

    public void AssignFieldToBulkArray(char[] input)
    {
        input[0] = tainted;
    }
}