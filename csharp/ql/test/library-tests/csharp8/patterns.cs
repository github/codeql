using System;

class Patterns
{
    void IsPatterns()
    {
        object o = new MyStruct { X = 2 };
        
        if (o is MyStruct ms1)
        {
        }

        if (o is MyStruct { X: int x } s && x<4 && s.Y<2)
        {
        }

        if (o is {} p)
        {
        }

        // A sub-pattern match
        if (o is MyStruct {X: 12, S: {X: var subX } })
        {
        }

        // A sub-pattern match
        if (o is MyStruct {X: 12, S: MyStruct {X: _ } ms })
        {
        }
    }

    void SwitchStatements()
    {
        var s = new MyStruct { X = 0 };

        switch (s)
        {
            case MyStruct ms1 when ms1.X == 10:
                Console.WriteLine("Hit the breakpoint");
                break;
            case MyStruct ms2 when ms2.X < 10:
                Console.WriteLine("Missed the breakpoint");
                break;
        }

        switch (s)
        {
            case MyStruct { X: int x } when x > 2:
                Console.WriteLine(x);
                break;
            case MyStruct { X: 10 } ms:
                Console.WriteLine("Hit the breakpoint");
                break;
            case { X: int x2 } when x2 > 2:
                Console.WriteLine(x2);
                break;
            case (1, 2):
                break;
            case var (x, y):
                break;
            default:
                break;
        }

        switch (s)
        {
            case MyStruct { X: int x } when x > 2:
                Console.WriteLine(x);
                break;
            case MyStruct { X: 10 } ms when s.X==0:
                Console.WriteLine("Hit the breakpoint");
                break;
        }
        

        switch (new object())
        {
            case (int x, float y) when x<y:
                break;
            case ():
                break;
            case {}:
                break;
        }

        switch(1,2)
        {
            case (1, 2): break;
        }

        switch((1,2))
        {
            case (1, var x): break;
            case (2, _): break;
        }
    }

    void Expressions(int x)
    {
        var size = x switch {
            int y when y > 10 => "large",
            _ => "small"
        };

        int x0 = 0, y0 = 0;

        // Potential fall through
        var (x1, y1) = (x0, y0) switch
        {
            (0,1) => (1,0),
            (1,0) => (0,1)
        };

        // No fall through
        (x1, y1) = (x0, y0) switch
        {
            (0,var y2) => (y2, 0),
            (var x2, 0) => (0, x2),
            (var x2, var y2) => (0, 0)
        };
    }

    void Expressions2(object o)
    {
        var s = new MyStruct { X = 0 };
        var r = s switch
        {
            MyStruct { X: int x } when x > 2 => 0,
            MyStruct { X: 10 } ms => 1,
            (1, 2) => 2,
            var (x, _) => 3
        };
        
        try
        {
            r = o switch
            {
                1 => throw new ArgumentException(),
                2 => 3,
                object y when y is {} => 4,
                string _ => 5,
                MyStruct { X: 10 } _ => 6
            };
        }
        catch(InvalidOperationException ex)
        {
            Console.WriteLine("Invalid operation");
        }
    }

    struct MyStruct
    {
        public int X;
        public int Y => 10;

        public MyStruct S => this;

        public void Deconstruct(out int x, out int y)
        {
            x = X;
            y = Y;
        }

        public void Deconstruct()
        {
        }
    }
}
