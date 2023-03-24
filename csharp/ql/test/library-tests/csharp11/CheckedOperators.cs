namespace CheckedOperators;

public class Number
{
    public int Value { get; }

    public Number(int n) => this.Value = n;

    public static Number operator checked +(Number n1, Number n2) =>
        new Number(checked(n1.Value + n2.Value));

    public static Number operator +(Number n1, Number n2) =>
        new Number(n1.Value + n2.Value);

    public static Number operator checked -(Number n1, Number n2) =>
        new Number(checked(n1.Value - n2.Value));

    public static Number operator -(Number n1, Number n2) =>
        new Number(n1.Value - n2.Value);

    public static Number operator checked *(Number n1, Number n2) =>
        new Number(checked(n1.Value * n2.Value));

    public static Number operator *(Number n1, Number n2) =>
        new Number(n1.Value * n2.Value);

    public static Number operator checked /(Number n1, Number n2) =>
        new Number(checked(n1.Value / n2.Value));

    public static Number operator /(Number n1, Number n2) =>
        new Number(n1.Value / n2.Value);

    public static Number operator checked -(Number n) =>
        new Number(checked(-n.Value));

    public static Number operator -(Number n) =>
        new Number(-n.Value);

    public static Number operator checked ++(Number n) =>
        new Number(checked(n.Value + 1));

    public static Number operator ++(Number n) =>
        new Number(n.Value + 1);

    public static Number operator checked --(Number n) =>
        new Number(checked(n.Value - 1));

    public static Number operator --(Number n) =>
        new Number(n.Value - 1);

    public static explicit operator short(Number n) =>
        (short)n.Value;

    public static explicit operator checked short(Number n) =>
        checked((short)n.Value);
}
