using System;

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

    public int ReturnArrayElement(int[] input)
    {
        return input[0];
    }

    public void AssignToArray(int data, int[] target)
    {
        target[0] = data;
    }

    public void SetField(string s)
    {
        tainted = s;
    }

    public string ReturnField()
    {
        return tainted;
    }

    public void AssignFieldToArray(object[] target)
    {
        target[0] = tainted;
    }
}
