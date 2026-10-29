
int main(int argc, char **argv) {
    char *s;
    if (__builtin_types_compatible_p(__typeof__(s), long)) {
        puts("long");
    } else if (__builtin_types_compatible_p(__typeof__(s), char*)) {
        puts("str");
    }
    return (0);
};

