class NoComparisonOnFloats
{
    public static void main(String[] args)
    {
        final double EPSILON = 0.001;
        System.out.println(Math.abs((0.1 + 0.2) - 0.3) < EPSILON);
    }
}