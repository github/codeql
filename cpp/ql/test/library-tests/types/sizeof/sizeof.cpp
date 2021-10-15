
typedef unsigned int size_t;

class MyClass
{
public:
	int x;
	char c;
	int *ptr;
};

void func() {
	int i;
	char c;
	int * ptr;
	MyClass mc;
	int arr[10];

	size_t sz1 = sizeof(int);
	size_t sz2 = sizeof(char);
	size_t sz3 = sizeof(int *);
	size_t sz4 = sizeof(MyClass);
	size_t sz5 = sizeof(i);
	size_t sz6 = sizeof(c);
	size_t sz7 = sizeof(ptr);
	size_t sz8 = sizeof(mc);
	size_t sz9 = sizeof(arr);
	size_t sz10 = sizeof(arr[4]);
}
