
#define NULL (0)

void myFunction1(char *format, ...);
void myFunction2(...);
void myFunction3(...);
void myFunction4(int i, int j, ...);
void myFunction5(...);
void myFunction6(...);
void myFunction7(...);

int main()
{
	int x;

	myFunction1("%i", 0); // GOOD: not common enough to be assumed a terminator
	myFunction1("%i", 0);
	myFunction1("%i", x);

	myFunction2(-1);
	myFunction2(0, -1);
	myFunction2(0, 1, -1);
	myFunction2(0, 1, 2, -1);
	myFunction2(0, 1, 2, 3, -1);
	myFunction2(0, 1, 2, 3, 4); // BAD: missing terminator

	myFunction3(-1);
	myFunction3(0, -1);
	myFunction3(-1, 1, -1); // GOOD: -1 isn't a terminator because it's used in a non-terminal position
	myFunction3(0, 1, 2, -1);
	myFunction3(0, 1, 2, 3, -1);
	myFunction3(0, 1, 2, 3, 4);

	myFunction4(x, x, 0);
	myFunction4(0, x, 1, 0);
	myFunction4(0, 0, 1, 1, 0);
	myFunction4(0, x, 1, 1, 1, 0);
	myFunction4(0, 0, 1, 1, 1, 1, 0);
	myFunction4(x, 0, 1, 1, 1, 1, 1); // BAD: missing terminator

	myFunction5('a', 'b', 'c', 0); // GOOD: ambiguous terminator
	myFunction5('a', 'b', 'c', 0);
	myFunction5('a', 'b', 'c', 0);
	myFunction5('a', 'b', 'c', -1);
	myFunction5('a', 'b', 'c', -1);
	myFunction5('a', 'b', 'c', -1);

	myFunction6(0.0);
	myFunction6(1.0); // BAD: missing terminator
	myFunction6(1.0, 2.0, 0.0);
	myFunction6(1.0, 2.0, 3.0, 0.0);
	myFunction6(1.0, 2.0, 3.0, 4.0, 0.0);
	myFunction6(1.0, 2.0, 3.0, 4.0, 5.0, 0.0);

	myFunction7(NULL);
	myFunction7("hello", "world", NULL);
	myFunction7("apple", "banana", "pear", "mango", NULL);
	myFunction7("dog", "cat", "elephant", "badger", "fish", NULL);
	myFunction7("one", "two", "three", 0);
	myFunction7("four", "five", "six", 0);
	myFunction7("seven", "eight", "nine", 0);
	myFunction7("alpha", "beta", "gamma", 0);
	myFunction7("", 0);
	myFunction7("yes", "no"); // BAD: missing terminator
	myFunction7(); // BAD: missing terminator

	return 0;
}