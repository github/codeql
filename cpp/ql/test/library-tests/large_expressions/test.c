
// this is a test of extracting a large expression (not a sensible way to find primes)

#define check(v, n) ( ((v) == (n)) || ((v) % (n) != 0) )

#define check10(v, n) \
	(check(v, n) && \
	check(v, n + 1) && \
	check(v, n + 2) && \
	check(v, n + 3) && \
	check(v, n + 4) && \
	check(v, n + 5) && \
	check(v, n + 6) && \
	check(v, n + 7) && \
	check(v, n + 8) && \
	check(v, n + 9))

#define check100(v, n) \
	(check10(v, n) && \
	check10(v, n + 10) && \
	check10(v, n + 20) && \
	check10(v, n + 30) && \
	check10(v, n + 40) && \
	check10(v, n + 50) && \
	check10(v, n + 60) && \
	check10(v, n + 70) && \
	check10(v, n + 80) && \
	check10(v, n + 90))

#define check1000(v, n) \
	(check100(v, n) && \
	check100(v, n + 100) && \
	check100(v, n + 200) && \
	check100(v, n + 300) && \
	check100(v, n + 400) && \
	check100(v, n + 500) && \
	check100(v, n + 600) && \
	check100(v, n + 700) && \
	check100(v, n + 800) && \
	check100(v, n + 900))

#define check3000(v, n) \
	(check1000(v, n) && \
	check1000(v, n + 1000) && \
	check1000(v, n + 2000))

int main()
{
	int i;

	for (i = 2; i < 3000; i++) {
		if check3000(i, 2) {
			// ... i is prime ...
		}
	}

	return 0;
}
