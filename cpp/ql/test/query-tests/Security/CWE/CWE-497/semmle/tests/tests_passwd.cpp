
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

	pwd = getpwnam(username);

	printf("pw_passwd = %s\n", pwd->pw_passwd); // BAD
	printf("pw_dir = %s\n", pwd->pw_dir); // BAD
	printf("sizeof(passwd) = %i\n", sizeof(passwd)); // GOOD
}
