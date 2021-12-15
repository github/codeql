class Splitting
{
    void M1(bool b)
    {
        var x = "";
        if (b)
            x = "a";
        else
        {
            x = "b";
            x.ToString();
        }
        x.ToString();
        x.ToString();
        if (b)
        {
            x.ToString();
            x = "c";
        }
    }

    void M2(bool b)
    {
        var x = "";
        if (b)
            x = "a";
        else
        {
            x = "b";
            x.ToString();
        }
        x = "c";
        x.ToString();
        x.ToString();
        if (b)
        {
            x.ToString();
            x = "d";
        }
    }

    void M3(bool b)
    {
        var x = "";
        if (b)
            x = "a";
        else
        {
            x = "b";
            x.ToString();
        }
        if (b)
            b = false;
        x.ToString();
        x.ToString();
    }
}
