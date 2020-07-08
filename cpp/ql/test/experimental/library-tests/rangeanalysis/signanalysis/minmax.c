// semmle-extractor-options: --gnu_version 40400
// Note: this file uses statement expressions, which are a GNU extension,
// so it has an options file to specify the compiler version. The statement
// expression extension is described here:
// https://gcc.gnu.org/onlinedocs/gcc/Statement-Exprs.html

int printf(const char *format, ...);

// The & operator is
// causing problems, because it disables SSA.  Also, range analysis did not
// have support for the statement expression language feature that is used
// here.

void minmax()
{
	int x = 1, y = 2, z = 3;

	printf("x = %i, y = %i, z = %i\n", x, y, z); // 1, 2, 3

	z = ({
		int t = 0;
		if (&x != &y) {t = x;} // t = 1
		t;
	});

	printf("x = %i, y = %i, z = %i\n", x, y, z); // 1, 2, 1
}
