long sprintf(char *buf, const char *format, ...);

void f(bool b, const char *format, char *buf) {
    if (b == true) { // BAD
        sprintf(buf, format, 5); // BAD
    } else if (!b) { // GOOD
        buf = buf + 1; // GOOD
        sprintf(buf, "%d", 5); // GOOD
    }
    buf = nullptr; // BAD
}
