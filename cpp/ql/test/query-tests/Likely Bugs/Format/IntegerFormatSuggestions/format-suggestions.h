// Deliberately mismatched calls for static analysis.
int printf(const char *format, ...);

void format_suggestions(int width, long long ll, unsigned long long ull,
                        double d, long double ld, const char *narrow,
                        const wchar_t *wide, long long *count) {
  printf("%#08x", ull);                // Suggest %#08llx.
  printf("%o", ull);                   // Suggest %llo.
  printf("%X", ull);                   // Suggest %llX.
  printf("%*d", width, ll);            // Suggest %*lld for the value argument.
  printf("%2$*1$.*3$d", width, ll, 2); // Suggest %2$*1$.*3$lld on Linux.
  printf("%+d", ull);                  // '+' is invalid for the unsigned replacement.
  printf("%x", ll);                    // Preserve hexadecimal intent and signedness.
  printf("%1$*1$d", ll);               // The same argument also supplies the width.
  printf("%.3a", ld);                  // Suggest %.3La.
  printf("%Lg", d);                    // Suggest %g.
  printf("%llf", d);                   // The diagnostic model tolerates this length.
  printf("%s", wide);                  // Suggest %ls.
  printf("%7.3ls", narrow);            // Suggest %7.3s.
  printf("%0ls", narrow);              // '0' is invalid for a string conversion.
  printf("%n", count);                 // A count store has no replacement suggestion.
  printf("%p", width);                 // The value is not a pointer.
  printf("%%");
}
