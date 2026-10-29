struct FILE;
FILE *fopen(const char * path, const char * mode);
char * getenv(const char * name);

void test_fopen(char * filename1) {
    const char * filename2 = "a_file";

    FILE * file0 = fopen("a_file", "r");
    FILE * file1 = fopen(filename1, "r");
    FILE * file2 = fopen(filename2, "r");
}

const char * do_getenv() {
    return getenv("FILENAME1");
}

FILE * do_fopen(const char * filename) {
    return fopen(filename, "r");
}

void test_getenv()
{
    const char * filename1 = do_getenv();
    const char * filename2 = getenv("FILENAME2");
    const char * filename4 = getenv("FILENAME4");

    FILE * file0 = fopen(getenv("FILENAME0"), "r");
    FILE * file1 = fopen(filename1, "r");
    FILE * file2 = fopen(filename2, "r");
    FILE * file3 = do_fopen(getenv("FILENAME3"));
    FILE * file4 = do_fopen(filename4);
}
