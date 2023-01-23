public interface INumber<T> where T : INumber<T>
{
    static abstract T operator ++(T other);

    static virtual T operator --(T other) => other;

    static abstract T Add(T left, T right);

    static virtual T Subtract(T left, T right) => left;

    static T Zero() => default(T);
}

public class Complex : INumber<Complex>
{
    public double Real { get; private set; } = 0.0;
    public double Imaginary { get; private set; } = 0.0;

    public Complex() { }

    public static Complex Zero() => new Complex();

    public static Complex operator ++(Complex other) =>
        new Complex { Real = other.Real + 1.0, Imaginary = other.Imaginary };

    public static Complex operator --(Complex other) =>
        new Complex { Real = other.Real - 1.0, Imaginary = other.Imaginary };

    public static Complex Add(Complex left, Complex right) =>
        new Complex { Real = left.Real + right.Real, Imaginary = left.Imaginary + right.Imaginary };

    public static Complex Subtract(Complex left, Complex right) =>
        new Complex { Real = left.Real - right.Real, Imaginary = left.Imaginary - right.Imaginary };
}