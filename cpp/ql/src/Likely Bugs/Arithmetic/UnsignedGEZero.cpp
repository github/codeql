typedef long long LONGLONG;

int f(unsigned int u, LONGLONG l) {
	if(u > 0 || l >=0)       //correct: unsigned value is check for > 0
		return 23;
	return u >= 0;           //wrong: unsigned values are always greater than or equal to 0
}
