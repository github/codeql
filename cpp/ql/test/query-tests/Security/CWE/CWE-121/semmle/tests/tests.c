// Semmle test cases for UnterminatedVarargsCall.ql
// Associated with CWE-121 http://cwe.mitre.org/data/definitions/121.html

void f1(char *format, ...)
{
}

void f2(char *format, ...)
{
}

void f3(char *format, ...)
{
}

void f4(char *format, ...)
{
}

void f5(char *format, ...)
{
}

void f6(char *format, ...)
{
}

void f7(char *format, ...)
{
}

int main(int argc, char *argv[])
{
	f1("", 1);	// BAD: not terminated with 0
	f1("", 1, 0);
	f1("", 1, 1, 0);
	f1("", 1, 1, 1, 0);
	f1("", 1, 1, 1, 1, 0);

	// GOOD: no obvious required terminator
	f2("", 10);

	// GOOD: 0 is not common enough to be sure it's a terminator
	f3("", 0);
	f3("", 10);

	// GOOD: -1 is not common enough to be sure it's a terminator
	f4("", 0);
	f4("", 0);
	f4("", -1);
	f4("", -1);
	f4("", -1);
	f4("", 1);

	// GOOD: no obvious required terminator
	f5("");
	f5("");
	f5("");
	f5("");
	f5("", 0);
	f5("", 0);
	f5("", 10);
	
	f6("fsdf", 3, 8, -1);
	f6("a", 7, 9, 10, -1);
	f6("a", 1, 22, 6, 17, 2, -1);
	f6("fgasfgas", 5, 6, argc); // BAD: not (necessarily) terminated with -1
	f6("sadfsaf"); // BAD: not terminated with -1

	f7("", 0);
	f7("", 0);
	f7("", 0);
	f7(""); // BAD: not terminated with 0

	return 0;
}