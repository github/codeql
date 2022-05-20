
const int c = 1;
int v = 1;
int one() {return 1;}

void myNormalFunction()
{
	static int static_1 = 1;
	static int static_c = c;
	static int static_v = v;
	static int static_one = one();
	int local_1 = 1;
	int local_c = c;
	int local_v = v;
	int local_one = one();
}

template<class T> void myTemplateFunction()
{
	static int static_int_1 = 1;
	static int static_int_c = c; // [initializer is not populated]
	static int static_int_v = v; // [initializer is not populated]
	static int static_int_one = one(); // [initializer is not populated]
	static T static_t_1 = 1; // [initializer is not populated]
	static T static_t_c = c; // [initializer is not populated]
	static T static_t_v = v; // [initializer is not populated]
	static T static_t_one = one(); // [initializer is not populated]

	int local_int_1 = 1;
	int local_int_c = c;
	int local_int_v = v;
	int local_int_one = one();
	T local_t_1 = 1;
	T local_t_c = c;
	T local_t_v = v;
	T local_t_one = one();
}

template<class T> class myTemplateClass
{
public:
	void myMethod()
	{
		static int static_int_1 = 1;
		static int static_int_c = c; // [initializer is not populated]
		static int static_int_v = v; // [initializer is not populated]
		static int static_int_one = one(); // [initializer is not populated]
		static T static_t_1 = 1; // [initializer is not populated]
		static T static_t_c = c; // [initializer is not populated]
		static T static_t_v = v; // [initializer is not populated]
		static T static_t_one = one(); // [initializer is not populated]

		int local_int_1 = 1;
		int local_int_c = c;
		int local_int_v = v;
		int local_int_one = one();
		T local_t_1 = 1;
		T local_t_c = c;
		T local_t_v = v;
		T local_t_one = one();
	}
};

enum myEnum
{
	MYENUM_CONST
};

template<class T> void myTemplateFunction2(int a = 1, T b = 2)
{
	static int static_int_zero = 0;
	static int static_int_ec = MYENUM_CONST;
	static int static_int_expr = v + 1;
	static int *static_int_addr = &v;
	static int static_int_sizeof_v = sizeof(v);
	static int static_int_sizeof_t = sizeof(T);
	static T static_t_zero = 0;
	static T static_t_ec = MYENUM_CONST;
	static T static_t_expr = v + 1;
	static T *static_t_addr = &v;
	static T static_t_sizeof_v = sizeof(v);
	static T static_t_sizeof_t = sizeof(T);

	static  int  static_int_c1  =  c;
	static int static_int_c2=c;
	{
		static int static_int_v2 = v;
	}
}
