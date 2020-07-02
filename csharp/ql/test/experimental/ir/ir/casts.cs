public class Casts_A 
{
}

public class Casts_B : Casts_A 
{
}

public class Casts 
{
    public static void Main() 
    {
        Casts_A Aobj = new Casts_A();
        Casts_B bobjCE = (Casts_B) Aobj;
        Casts_B bobjAS = Aobj as Casts_B;
    }
}
