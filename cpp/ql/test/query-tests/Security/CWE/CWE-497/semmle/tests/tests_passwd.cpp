
int printf(const char *format, ...);

struct passwd {
	char *pw_passwd;
	char *pw_dir;
	// ...
};

struct passwd *getpwnam(const char *name);

void test6(char *username)
{
	passwd *pwd;

	pwd = getpwnam(username); // $ Source[cpp/potential-system-data-exposure]

	printf("pw_passwd = %s\n", pwd->pw_passwd); // $ Alert[cpp/potential-system-data-exposure] // BAD
	printf("pw_dir = %s\n", pwd->pw_dir); // $ Alert[cpp/potential-system-data-exposure] // BAD
	printf("sizeof(passwd) = %i\n", sizeof(passwd)); // GOOD
}
