
extern const int myConst1;
const int myConst2 = 20;

int thirty() {return 30;}

void func1(int x = myConst1, int y = myConst2, int z = thirty())
{
}

void func2()
{
	func1(); // call with default parameters
}
 
const int myConst1 = 10;
