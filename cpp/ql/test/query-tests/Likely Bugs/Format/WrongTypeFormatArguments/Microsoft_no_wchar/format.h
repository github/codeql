
extern FILE *stderr;

static void error(int x1, int x2, int x3, int x4, int x5,
                  const char *fmt,
                  int y1, int y2, int y3, int y4, int y5, int y6, int y7,
                  ...) {
    va_list argp;
    va_start(argp, y7);
    vfprintf(stderr, fmt, argp);
    va_end(argp);
}

void format2(char *str, int i, double d) {
    error(1, 2, 3, 4, 5, "%s %d %f", 1, 2, 3, 4, 5, 6, 7, str, i, d);
    error(1, 2, 3, 4, 5, "%d %f %s", 1, 2, 3, 4, 5, 6, 7, str, i, d);
}
