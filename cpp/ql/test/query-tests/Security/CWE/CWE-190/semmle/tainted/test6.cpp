
typedef unsigned short u16;
typedef unsigned int u32;

typedef struct {} FILE;
int fscanf(FILE *stream, const char *format, ...);
FILE *stdin;

void docast1(u32 s)
{
	u16 c = (u16)s; // bad
}

void docast2(u32 s)
{
	u16 c = (u16)s; // bad
}

class MyBaseClass
{
public:
	virtual void docast(u32 s) = 0;
};

class MyDerivedClass : public MyBaseClass
{
public:
	void docast(u32 s)
	{
		u16 c = (u16)s; // bad
	}
};

void test6()
{
    u32 s;

	s = -1;
	fscanf(stdin, "%hd", &s);

	docast1(s);
	{
		void (*docast2_ptr)(u32) = &docast2;
	
		docast2_ptr(s);
	}
	{
		MyBaseClass *mbc = new MyDerivedClass;

		mbc->docast(s);

		delete mbc;
	}
}
