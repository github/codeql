final private static double KM_PER_MILE = 1.609344;

// AVOID: Example that assigns to a parameter
public double milesToKM(double miles) {
	miles *= KM_PER_MILE;
	return miles;
}

// GOOD: Example of using an expression instead
public double milesToKM(double miles) {
	return miles * KM_PER_MILE;
}

// GOOD: Example of using a local variable
public double milesToKM(double miles) {
	double kilometres = miles * KM_PER_MILE;
	return kilometres;
}
