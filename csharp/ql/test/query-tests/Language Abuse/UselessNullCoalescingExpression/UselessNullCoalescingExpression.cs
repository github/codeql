using System;

class Tests
{
    void Main(int? param)
    {
        int? a = 5, b;

        a = a ?? a;              // BAD
        a = a ?? (b = a);          // BAD
        a = Prop ?? Prop;        // BAD
        a = param ?? param;      // BAD
        a = a ?? use(a);         // BAD
        a = Field ?? this.Field; // BAD

        a = a ?? cache(ref a);   // GOOD
        a = a ?? store(out a);   // GOOD
        a = a ?? (a = 2);          // GOOD
        a = Prop ?? use(Prop = 2); // GOOD
        a = Field ??
            store(out Field);    // GOOD
        a = a ?? use(a = Field)
              ?? a;              // GOOD
        a = a ?? store(out a)
              ?? a;              // GOOD
    }

    int? cache(ref int? a)
    {
        return a = 5;
    }

    int? store(out int? a)
    {
        return a = 5;
    }

    int? use(int? a)
    {
        return a;
    }

    int? Prop { get; set; }

    int? Field;
}
