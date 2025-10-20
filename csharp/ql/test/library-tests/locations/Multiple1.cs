public partial class Multiple { }

public partial class MultipleGeneric<S> { }

public class Multiple1Specific
{
    public static (int, string) M()
    {
        (int, string) x = (0, "");
        (int, int) y = (0, 0);
        return x;
    }
}
