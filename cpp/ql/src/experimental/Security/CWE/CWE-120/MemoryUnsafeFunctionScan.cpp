///// Library routines /////

int scanf(const char *format, ...);
int sscanf(const char *str, const char *format, ...);
int fscanf(const char *str, const char *format, ...);

///// EXAMPLES /////

int main(int argc, char **argv)
{

    // BAD, do not use scanf without specifying a length first
    char buf1[10];
    scanf("%s", buf1);

    // GOOD, length is specified. The length should be one less than the size of the buffer, since the last character is the NULL terminator.
    char buf2[10];
    sscanf(buf2, "%9s");

    // BAD, do not use scanf without specifying a length first
    char file[10];
    fscanf(file, "%s", buf2);

    return 0;
}
