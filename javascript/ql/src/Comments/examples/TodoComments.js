function solveQuadratic(a, b, c) {
	// TODO: handle case where a === 0
	return (-b + Math.sqrt(b*b - 4*a*c))/(2*a);
}