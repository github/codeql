// Test for the general-purpose taint-tracking
// mechanism that is used by several of the security queries.

///// Library functions //////

typedef unsigned long size_t;

int strcmp(const char *s1, const char *s2);
char *getenv(const char *name);
size_t strlen(const char *s);
char *strcpy(char *s1, const char *s2);

void *malloc(size_t size);

int atoi(const char *nptr);

//// Test code /////

bool isAdmin = false;

void test1()
{
	const char *envStr = getenv("USERINFO");

	if (!strcmp(envStr, "admin")) {
		isAdmin = true;
	}

	if (!strcmp(envStr, "none")) {
		isAdmin = false;
	}
}

extern const char *specialUser;

void test2()
{
	const char *envStr = getenv("USERINFO");

	if (!strcmp(envStr, specialUser)) {
		isAdmin = true;
	}
}

const char *envStrGlobal;

void test3()
{
	const char *envStr = getenv("USERINFO");
	const char **envStr_ptr = &envStrGlobal;

	*envStr_ptr = envStr;

	if (!strcmp(envStrGlobal, "admin")) {
		isAdmin = true;
	}
}

void bugWithBinop() {
     const char *userName = getenv("USER_NAME");

     // The following is tainted, but should not cause
     // the whole program to be considered tainted.
     int bytes = strlen(userName) + 1;
}

char* copying() {
    const char *userName = getenv("USER_NAME");
    char copy[1024];
    strcpy(copy, userName);
    return copy; // copy should be tainted
}

void guard() {
    int len = atoi(getenv("FOOBAZ_BRANCHING"));
    if (len > 1000) return;
    char **node = (char **) malloc(len * sizeof(char *));
}

const char *alias_global;

void mallocBuffer() {
    const char *userName = getenv("USER_NAME");
	char *alias = (char*)malloc(4096);
	char *copy = (char*)malloc(4096);
	strcpy(copy, userName);
	alias_global = alias; // to force a Chi node on all aliased memory
	if (!strcmp(copy, "admin")) { // copy should be tainted
		isAdmin = true;
	}
}

char *gets(char *s);

void test_gets()
{
	char buffer[1024];
	char *pointer;

	pointer = gets(buffer);
}

const char *alias_global_new;

void newBuffer() {
    const char *userName = getenv("USER_NAME");
	char *alias = new char[4096];
	char *copy = new char[4096];
	strcpy(copy, userName);
	alias_global_new = alias; // to force a Chi node on all aliased memory
	if (!strcmp(copy, "admin")) { // copy should be tainted
		isAdmin = true;
	}
}