public interface IShiftOperators<TSelf, TOther, TReturn> where TSelf : IShiftOperators<TSelf, TOther, TReturn>
{
    public static abstract TReturn operator <<(TSelf value, TOther shiftAmount);

    public static abstract TReturn operator >>(TSelf value, TOther shiftAmount);

    public static abstract TReturn operator >>>(TSelf value, TOther shiftAmount);
}

public class Number : IShiftOperators<Number, string, Number>
{
    public static Number operator <<(Number value, string shiftAmount) => value;

    public static Number operator >>(Number value, string shiftAmount) => value;

    public static Number operator >>>(Number value, string shiftAmount) => value;
}

public class TestRelaxedShift
{
    public void M1()
    {
        var n11 = new Number();
        var n12 = n11 << "1";

        var n21 = new Number();
        var n22 = n21 >> "2";

        var n31 = new Number();
        var n32 = n31 >>> "3";
    }
}