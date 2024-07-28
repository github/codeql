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

// ---

typedef struct {} FILE;
char *fgets(char *s, int n, FILE *stream);
FILE *stdin;

void testReferencePointer1()
{
	char buffer[1024];

	if (fgets(buffer, 1024, stdin) != 0)
	{
		char *data = buffer;
		char *&dataref = data;
		char *data2 = dataref;

		system(buffer); // BAD
		system(data); // BAD
		system(dataref); // BAD
		system(data2); // BAD
	}
}

void testReferencePointer2()
{
	char buffer[1024];
	char *data = buffer;
	char *&dataref = data;
	char *data2 = dataref;

	if (fgets(buffer, 1024, stdin) != 0)
	{
		system(buffer); // BAD
		system(data); // BAD
		system(dataref); // BAD [NOT DETECTED]
		system(data2); // BAD [NOT DETECTED]
	}
}

// ---

typedef unsigned long size_t;

void accept(int arg, char *buf, size_t *bufSize);
void recv(int arg, char *buf, size_t bufSize);
void LoadLibrary(const char *arg);

void testAcceptRecv(int socket1, int socket2)
{
	{
		char buffer[1024];

		recv(socket1, buffer, 1024);
		LoadLibrary(buffer); // BAD: using data from recv
	}
	
	{
		char buffer[1024];

		accept(socket2, 0, 0);
		recv(socket2, buffer, 1024);
		LoadLibrary(buffer); // BAD: using data from recv
	}
}

void argumentUse(char *ptr, FILE *stream) {
	char buffer[80];
	ptr = fgets(buffer, sizeof(buffer), stream);
	system(ptr); // BAD
}
