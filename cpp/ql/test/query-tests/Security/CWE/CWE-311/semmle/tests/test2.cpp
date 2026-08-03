
#define FILE int

typedef unsigned long size_t;

FILE *fopen(const char *filename, const char *mode);
int snprintf(char *s, size_t n, const char *format, ...);
int fprintf(FILE *stream, const char *format, ...);
char *strcpy(char *s1, const char *s2);

char *crypt(char *input);

struct myStruct
{
	// sensitive
	char *password;
	char *thepasswd;
	char *accountkey;
	wchar_t *widepassword;

	// encrypted
	char password_hash[64];
	char *encrypted_passwd;

	// not sensitive
	char *password_file;
	char *password_path;
	int num_passwords;
	int *password_tries;
	bool have_passwd;

	// dubious
	char *passwd_config;
	char *passwd_config2;
};

char *getPassword();
char *getPasswordHash();
int getPasswordMaxChars();

void tests(FILE *log, myStruct &s)
{
	fprintf(log, "password = %s\n", s.password); // $ Alert[cpp/cleartext-storage-file] // BAD
	fprintf(log, "thepasswd = %s\n", s.thepasswd); // $ Alert[cpp/cleartext-storage-file] // BAD
	fprintf(log, "accountkey = %s\n", s.accountkey); // $ Alert[cpp/cleartext-storage-file] // BAD
	fprintf(log, "password_hash = %s\n", s.password_hash); // GOOD
	fprintf(log, "encrypted_passwd = %s\n", s.encrypted_passwd); // GOOD
	fprintf(log, "password_file = %s\n", s.password_file); // GOOD
	fprintf(log, "password_path = %s\n", s.password_path); // GOOD
	fprintf(log, "passwd_config = %s\n", s.passwd_config); // $ Alert[cpp/cleartext-storage-file] // DUBIOUS [REPORTED]
	fprintf(log, "num_passwords = %i\n", s.num_passwords); // GOOD
	fprintf(log, "password_tries = %i\n", *(s.password_tries)); // GOOD
	fprintf(log, "have_passwd = %i\n", s.have_passwd); // GOOD
	fprintf(log, "widepassword = %ls\n", s.widepassword); // $ Alert[cpp/cleartext-storage-file] // BAD
	fprintf(log, "widepassword = %S\n", s.widepassword); // $ Alert[cpp/cleartext-storage-file] // BAD

	fprintf(log, "getPassword() = %s\n", getPassword()); // $ Alert[cpp/cleartext-storage-file] // BAD
	fprintf(log, "getPasswordHash() = %s\n", getPasswordHash()); // GOOD
	fprintf(log, "getPasswordMaxChars() = %i\n", getPasswordMaxChars()); // GOOD

	{
		char *cpy1 = s.password; // $ Source[cpp/cleartext-storage-file]
		char *cpy2 = crypt(s.password);

		fprintf(log, "cpy1 = %s\n", cpy1); // $ Alert[cpp/cleartext-storage-file] // BAD
		fprintf(log, "cpy2 = %s\n", cpy2); // GOOD
	}

	{
		char buf[1024];

		strcpy(buf, s.password); // $ Source[cpp/cleartext-storage-file]
		fprintf(log, "buf = %s\n", buf); // $ Alert[cpp/cleartext-storage-file] // BAD

		strcpy(buf, s.password_hash);
		fprintf(log, "buf = %s\n", buf); // GOOD
	}

	{
		char buf[1024];

		strcpy(buf, s.password_hash);
		fprintf(log, "buf = %s\n", buf); // GOOD
	}

	fprintf(log, "password = %p\n", s.password); // GOOD

	{
		if (fopen(s.passwd_config2, "rt") == 0)
		{
			fprintf(log, "could not open file '%s'.\n", s.passwd_config2); // GOOD
		}
	}

	{
		char buffer[1024];

		snprintf(buffer, 1024, "password = %s", s.password); // $ Source[cpp/cleartext-storage-file]
		fprintf(log, "log: %s", buffer); // $ Alert[cpp/cleartext-storage-file] // BAD
	}
}

char *gets(char *s);

void test_gets()
{
	{
		char password[1024];

		gets(password); // $ Alert[cpp/cleartext-storage-buffer] // BAD
	}
}
