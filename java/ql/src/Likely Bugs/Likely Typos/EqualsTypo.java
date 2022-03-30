public class Complex
{
	private double real;
	private double complex;

	// ...

	public boolean equal(Object obj) {  // The method is named 'equal'.
		if (!getClass().equals(obj.getClass()))
			return false;
		Complex other = (Complex) obj;
		return real == other.real && complex == other.complex;
	}
}