
typedef unsigned long size_t;

void SYSC_SOMESYSTEMCALL(void *param);

bool user_access_begin_impl(const void *where, size_t sz);
void user_access_end_impl();
#define user_access_begin(where, sz) user_access_begin_impl(where, sz)
#define user_access_end() user_access_end_impl()

void unsafe_put_user_impl(int what, const void *where, size_t sz);
#define unsafe_put_user(what, where) unsafe_put_user_impl( (what), (where), sizeof(*(where)) )

void test1(int p)
{
	SYSC_SOMESYSTEMCALL(&p);

	unsafe_put_user(123, &p); // BAD
}

void test2(int p)
{
	SYSC_SOMESYSTEMCALL(&p);

	if (user_access_begin(&p, sizeof(p)))
	{
		unsafe_put_user(123, &p); // GOOD

		user_access_end();
	}
}

void test3()
{
	int v;

	SYSC_SOMESYSTEMCALL(&v);

	unsafe_put_user(123, &v); // BAD [NOT DETECTED]
}

void test4()
{
	int v;

	SYSC_SOMESYSTEMCALL(&v);

	if (user_access_begin(&v, sizeof(v)))
	{
		unsafe_put_user(123, &v); // GOOD

		user_access_end();
	}
}

struct data
{
	int x;
};

void test5()
{
	data myData;

	SYSC_SOMESYSTEMCALL(&myData);

	unsafe_put_user(123, &(myData.x)); // BAD [NOT DETECTED]
}

void test6()
{
	data myData;

	SYSC_SOMESYSTEMCALL(&myData);

	if (user_access_begin(&myData, sizeof(myData)))
	{
		unsafe_put_user(123, &(myData.x)); // GOOD

		user_access_end();
	}
}
