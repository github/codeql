///// Library routines /////

int scanf(const char* format, ... );
int sscanf(const char* str, const char* format, ...);
int fscanf(const char* str, const char* format, ...);

///// Test code /////

int main(int argc, char** argv) { 

    // BAD, do not use scanf, use scanf_s instead
    char buf1[10];
    scanf("%s", buf1);

    // BAD, do not use sscanf, use sscanf_s instead
    char buf2[10];
    sscanf(buf2, "%s");

    // BAD, do not use fscanf, use fscanf_s instead
    char file[10];
    fscanf(file, "%s", buf2);

    return 0;
}
