
class Super {
	int foo;
}

public class A extends Super {
	class B extends Super {
		{
			if (this.foo == this.foo)
				;
			if (B.this.foo == this.foo)
				;
			if (super.foo == foo)
				;
			if (B.super.foo == foo)
				;
			if (A.this.foo != this.foo)
				;
			if (A.super.foo == foo)
				;
		}
	}

	{
		Double d = Double.NaN;
		if (d == d); // !Double.isNan(d)
		if (d <= d); // !Double.isNan(d), but unlikely to be intentional
		if (d >= d); // !Double.isNan(d), but unlikely to be intentional
		if (d != d); // Double.isNan(d)
		if (d > d); // always false
		if (d < d); // always false

		float f = Float.NaN;
		if (f == f); // !Float.isNan(f)
		if (f <= f); // !Float.isNan(f), but unlikely to be intentional
		if (f >= f); // !Float.isNan(f), but unlikely to be intentional
		if (f != f); // Float.isNan(f)
		if (f > f); // always false
		if (f < f); // always false

		int i = 0;
		if (i == i);
		if (i != i);
	}
}
