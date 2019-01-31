
char *gets(char *s);
unsigned long int strtoul( const char * nptr, char ** endptr, int base);

int getTaintedInt()
{
	char buf[128];

	gets(buf);
	return strtoul(buf, 0, 10);
}

void useTaintedInt()
{
	int x, y;

	x = getTaintedInt() * 1024; // BAD: arithmetic on a tainted value
	y = getTaintedInt();
	y = y * 1024; // BAD: arithmetic on a tainted value
}
