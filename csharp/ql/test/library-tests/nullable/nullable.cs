public class Nullable
{
    public double? useNullable(int? x)
    {
        if (x == null)
            return null; // lifted null
        if (x == 3) // lifted binary operator
            x++; // lifted unary mutator
        x = -x; // lifted unary operator
        return x; // lifted conversion
    }
}
