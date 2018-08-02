function solve_quad(a, b, c) {
	if (a === 0 || b*b < 4*a*c)
		return;
	return (-b + Math.sqrt(b*b - 4*a*c))/(2*a);
}