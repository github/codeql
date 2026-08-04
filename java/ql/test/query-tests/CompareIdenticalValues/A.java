
class Super {
	int foo;
}

public class A extends Super {
	class B extends Super {
		{
			if (this.foo == this.foo) // $ Alert
				;
			if (B.this.foo == this.foo) // $ Alert
				;
			if (super.foo == foo) // $ Alert
				;
			if (B.super.foo == foo) // $ Alert
				;
			if (A.this.foo != this.foo)
				;
			if (A.super.foo == foo)
				;
		}
	}

	{
		Double d = Double.NaN;
		if (d == d); // $ Alert // !Double.isNan(d)
		if (d <= d); // $ Alert // !Double.isNan(d), but unlikely to be intentional
		if (d >= d); // $ Alert // !Double.isNan(d), but unlikely to be intentional
		if (d != d); // $ Alert // Double.isNan(d)
		if (d > d); // $ Alert // always false
		if (d < d); // $ Alert // always false

		float f = Float.NaN;
		if (f == f); // $ Alert // !Float.isNan(f)
		if (f <= f); // $ Alert // !Float.isNan(f), but unlikely to be intentional
		if (f >= f); // $ Alert // !Float.isNan(f), but unlikely to be intentional
		if (f != f); // $ Alert // Float.isNan(f)
		if (f > f); // $ Alert // always false
		if (f < f); // $ Alert // always false

		int i = 0;
		if (i == i); // $ Alert
		if (i != i); // $ Alert
	}
}
