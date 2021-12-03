public override string ToString()
{
    var str = new StringBuilder("("); // GOOD: String value.
    for (int i = 0; i < values.Length; ++i)
    {
        if (i > 0) str.Append(',');
        str.Append(values[i]);
    }
    str.Append(')');
    return str.ToString();
}
