// Independent reproduction of github/codeql#15028. Compile only: these
// deliberately mismatched printf calls must not be executed.
int printf(const char *format, ...);

void integer_hints(int i, unsigned int ui, long l, unsigned long ul,
                   long long ll, unsigned long long ull, short s, double d) {
  printf("%d", ul);             // Original issue; alert depends on the target ABI.
  printf("%d", ll);             // Suggest %lld.
  printf("%d", ull);            // Suggest %llu.
  printf("%i", ll);             // Suggest %lli.
  printf("%lld", i);            // Suggest %d.
  printf("%llu", ui);           // Suggest %u.
  printf("%lld", l);            // On LLP64, suggest %ld.
  printf("%llu", ul);           // On LLP64, suggest %lu.
  printf("value=%d end", ull);  // Suggest %llu for the embedded conversion.
  printf("%d %d", ll, ull);     // Distinct suggestions for two arguments.

  printf("%d", i);              // Correct: no alert.
  printf("%u", ui);             // Correct: no alert.
  printf("%ld", l);             // Correct: no alert.
  printf("%lu", ul);            // Correct: no alert.
  printf("%lld", ll);           // Correct: no alert.
  printf("%llu", ull);          // Correct: no alert.
  printf("%d", s);              // Correct after default argument promotion.

  printf("%08d", ll);           // Existing alert; decorated formats out of scope.
  printf("%*d", ll, i);         // Width argument mismatch; no conversion suggestion.
  printf("%.*d", ll, i);        // Precision argument mismatch; no suggestion.
  printf("%1$d", ll);           // Positional format out of scope.
  printf("%x", ull);            // Hexadecimal formatting out of scope.
  printf("%d", d);              // Non-integer actual type: no suggestion.
  printf("%s", ll);             // Non-integer conversion: no suggestion.
  printf("%p", ll);             // Pointer conversion: no suggestion.
  printf("%f", i);              // Floating-point conversion: no suggestion.
}
