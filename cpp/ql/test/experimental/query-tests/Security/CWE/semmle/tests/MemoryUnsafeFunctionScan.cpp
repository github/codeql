///// Library routines /////

typedef unsigned long size_t;
void *malloc(size_t size);

size_t strlen(const char *s);

int scanf(const char *format, ...);
int sscanf(const char *str, const char *format, ...);
int fscanf(const char *str, const char *format, ...);

///// Test code /////

int main(int argc, char **argv)
{

    // BAD, do not use scanf without specifying a length first
    char buf1[10];
    scanf("%s", buf1);

    // GOOD, length is specified. The length should be one less than the size of the destination buffer, since the last character is the NULL terminator.
    char buf2[20];
    char buf3[10];
    sscanf(buf2, "%9s", buf3);

    // BAD, do not use scanf without specifying a length first
    char file[10];
    fscanf(file, "%s", buf2);

    // GOOD, with 'sscanf' the input can be checked first and enough room allocated [FALSE POSITIVE]
    if (argc >= 1)
    {
		char *src = argv[0];
		char *dest = (char *)malloc(strlen(src) + 1);

		sscanf(src, "%s", dest);
	}

    return 0;
}
