
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

	size_t sz1 = alignof(int);
	size_t sz2 = alignof(char);
	size_t sz3 = alignof(int *);
	size_t sz4 = alignof(MyClass);
	size_t sz5 = alignof(i);
	size_t sz6 = alignof(c);
	size_t sz7 = alignof(ptr);
	size_t sz8 = alignof(mc);
	size_t sz9 = alignof(arr);
	size_t sz10 = alignof(arr[4]);
}
