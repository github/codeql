// semmle-extractor-options: --clang --clang_version 190000

typedef unsigned int size_t;

class MyClass
{
public:
	int x;
	int *ptr;
	char c;
};

void func() {
	int i;
	char c;
	int * ptr;
	MyClass mc;
	int arr[10];

	size_t sz1 = __datasizeof(int);
	size_t sz2 = __datasizeof(char);
	size_t sz3 = __datasizeof(int *);
	size_t sz4 = __datasizeof(MyClass);
	size_t sz5 = __datasizeof(i);
	size_t sz6 = __datasizeof(c);
	size_t sz7 = __datasizeof(ptr);
	size_t sz8 = __datasizeof(mc);
	size_t sz9 = __datasizeof(arr);
	size_t sz10 = __datasizeof(arr[4]);
}
