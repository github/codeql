#include <stdarg.h>

void pushStrings(char *firstString, ...)
{
	va_list args;
	char *arg;

	va_start(args, firstString);

	// process inputs, beginning with firstString, ending when NULL is reached
	arg = firstString;
	while (arg != NULL)
	{
		// push the string
		pushString(arg);
	
		// move on to the next input
		arg = va_arg(args, char *);
	}

	va_end(args);
}

void badFunction()
{
	pushStrings("hello", "world", NULL); // OK
	
	pushStrings("apple", "pear", "banana", NULL); // OK

	pushStrings("car", "bus", "train"); // BAD, not terminated with the expected NULL
}