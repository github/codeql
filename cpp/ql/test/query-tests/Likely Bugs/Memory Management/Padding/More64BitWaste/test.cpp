
struct test1
{
	int x;
};

struct test2
{
	int x, y;
};

struct test3
{
	int x, y, z;
};

struct test4 // BAD
{
	int a;
	long long b;
};

struct test5
{
	long long a;
	int b;
};

struct test6 // BAD
{
	char as[4];
	long long b;
};

struct test7
{
	char as[8];
	long long b;
};
