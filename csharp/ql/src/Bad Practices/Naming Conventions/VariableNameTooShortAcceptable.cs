class VariableNameTooShortAcceptableCase
{
    public static void Main(string[] args)
    {
        /*
         * u - object starting position
         * t - time
         * a - acceleration
         * s - speed
         */
        double u = 5;
        double t = 2;
        double a = 9.81;
        double s = (u * t) + ((1.0 / 2.0) * a * Math.Pow(t, 2));
    }
}
