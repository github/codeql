// semmle-extractor-options: /langversion:latest

class DefaultLiterals
{
    void f()
    {
        int x = default, y = default(int);
        if (x == default)
            ;
        switch (x)
        {
            case var _: break;
        }
        x = default;
        string s = default;
        bool b = default;
        double d = default;
    }
}

class IsConstants
{
    void f()
    {
        bool b;
        b = new object() is "abc";
        b = "" is null;
        b = b is true;
    }
}
