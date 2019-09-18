// Semmle test cases for CWE-114

int system(const char *string);
char *getenv(const char* name);

// ---

class MyBase
{
public:
	virtual void doCommand1(const char *command) = 0;
	virtual void doCommand2(const char *command) = 0;
	virtual void doCommand3(const char *command) = 0;
};

class MyDerived : public MyBase
{
public:
	void doCommand1(const char *command)
	{
		system(command); // GOOD
	}

	void doCommand2(const char *command)
	{
		system(command); // BAD (externally controlled string)
	}

	void doCommand3(const char *command)
	{
		system(command); // BAD (externally controlled string)
	}
};

void testMyDerived()
{
	MyDerived *md1 = new MyDerived;
	MyDerived *md2 = new MyDerived;
	MyBase *md3 = new MyDerived; // MyBase pointer to a MyDerived

	md1->doCommand1("fixed");
	md2->doCommand2(getenv("varname"));
	md3->doCommand3(getenv("varname"));
}
