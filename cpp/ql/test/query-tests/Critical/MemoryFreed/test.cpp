
typedef unsigned int size_t;
void *malloc(size_t size);
void free(void *ptr);

// --- myClass1 ---

class myClass1
{
public:
	myClass1();
	~myClass1();

	void method1();
	void method2();

private:
	int *array1, *array2, *array3, *array4, *array5, *array6, *array7, *array8;
};

myClass1 :: myClass1()
{
	array1 = (int *)malloc(sizeof(int) * 100);
	array2 = (int *)malloc(sizeof(int) * 100);
	array3 = (int *)malloc(sizeof(int) * 100);
	array4 = (int *)malloc(sizeof(int) * 100); // never freed

	free(array1);
}

myClass1 :: ~myClass1()
{
	free(array2);
	free(array7);
}

void myClass1 :: method1()
{
	array5 = (int *)malloc(sizeof(int) * 100);
	array6 = (int *)malloc(sizeof(int) * 100);
	array7 = (int *)malloc(sizeof(int) * 100);
	array8 = (int *)malloc(sizeof(int) * 100); // never freed

	free(array3);
	free(array5);
}

void myClass1 :: method2()
{
	free(array6);
}

// --- myClass2 ---

class myClass2
{
public:
	myClass2();
	~myClass2();

	void method1();
	void method2();

private:
	int *array1, *array2, *array3, *array4, *array5, *array6, *array7, *array8;
};

myClass2 :: myClass2()
{
	array1 = (int *)malloc(sizeof(int) * 100);
	array2 = (int *)malloc(sizeof(int) * 100);
	array3 = (int *)malloc(sizeof(int) * 100);
	array4 = (int *)malloc(sizeof(int) * 100); // never freed

	free(array1);
}

myClass2 :: ~myClass2()
{
	free(array2);
	free(array7);
}

void myClass2 :: method1()
{
	array5 = (int *)malloc(sizeof(int) * 100);
	array6 = (int *)malloc(sizeof(int) * 100);
	array7 = (int *)malloc(sizeof(int) * 100);
	array8 = (int *)malloc(sizeof(int) * 100); // never freed

	free(array3);
	free(array5);
}

void myClass2 :: method2()
{
	free(array6);
}

int main()
{
	{
		myClass1 mc1;

		mc1.method1();
		mc1.method2();
	}

	{
		myClass2 *mc2;

		mc2 = new myClass2();
		mc2->method1();
		mc2->method2();
		delete mc2;
	}
	
	{
		void *v1 = malloc(100);
		int *i2 = (int *)malloc(100);
		void *v3 = malloc(100);
		int *i3 = (int *)v3;
		void *v4 = malloc(100);

		free(v1);
		free(i2);
		free(i3);
		free((int *)v4);
	}

	return 0;
}
