public interface INumber<T> where T : INumber<T>
{
    static abstract T operator ++(T other);

    static virtual T operator --(T other) => other;

    static abstract T operator +(T left, T right);

    static virtual T operator -(T left, T right) => left;

    static abstract explicit operator int(T n);

    static abstract explicit operator short(T n);

    static abstract T Inc(T other);

    static virtual T Dec(T other) => other;

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

    static Complex INumber<Complex>.operator +(Complex left, Complex right) =>
        new Complex { Real = left.Real + right.Real, Imaginary = left.Imaginary + right.Imaginary };

    static Complex INumber<Complex>.operator -(Complex left, Complex right) =>
        new Complex { Real = left.Real - right.Real, Imaginary = left.Imaginary - right.Imaginary };

    public static explicit operator int(Complex n) => (int)n.Real;

    static explicit INumber<Complex>.operator short(Complex n) => (short)n.Real;

    static Complex INumber<Complex>.Inc(Complex other) =>
        new Complex { Real = other.Real + 1.0, Imaginary = other.Imaginary };

    static Complex INumber<Complex>.Dec(Complex other) =>
        new Complex { Real = other.Real - 1.0, Imaginary = other.Imaginary };

    public static Complex Add(Complex left, Complex right) =>
        new Complex { Real = left.Real + right.Real, Imaginary = left.Imaginary + right.Imaginary };

    public static Complex Subtract(Complex left, Complex right) =>
        new Complex { Real = left.Real - right.Real, Imaginary = left.Imaginary - right.Imaginary };
}