public class NoConstantsOnly {
	static interface MathConstants
	{
	    public static final Double Pi = 3.14;
	}

	static class Circle implements MathConstants
	{
	    public double radius;
	    public double area()
	    {
	        return Math.pow(radius, 2) * Pi;
	    }
	}
}