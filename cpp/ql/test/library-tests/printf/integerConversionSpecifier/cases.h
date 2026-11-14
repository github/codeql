// Compile-only fixtures. Deliberately mismatched printf calls are not executed.
int printf(const char *format, ...);
typedef unsigned long UnsignedLong;
enum SmallEnum { SmallValue = 1 };

void integer_specifiers(int i, unsigned int ui, long l, unsigned long ul,
                        long long ll, unsigned long long ull, signed int si,
                        const UnsignedLong cul, short s, unsigned short us,
                        char c, _Bool b, enum SmallEnum e, float f, double d, int *p) {
  // All six type categories, independently of whether the query reports a mismatch.
  printf("%d", i);          // EXPECT: %d
  printf("%d", ui);         // EXPECT: %u
  printf("%d", l);          // EXPECT: %ld
  printf("%d", ul);         // EXPECT: %lu
  printf("%d", ll);         // EXPECT: %lld
  printf("%d", ull);        // EXPECT: %llu
  printf("%i", i);          // EXPECT: %i
  printf("%i", ui);         // EXPECT: %u
  printf("%i", l);          // EXPECT: %li
  printf("%i", ul);         // EXPECT: %lu
  printf("%i", ll);         // EXPECT: %lli
  printf("%i", ull);        // EXPECT: %llu
  printf("%u", i);          // EXPECT: %d
  printf("%ld", si);        // EXPECT: %d
  printf("%li", ui);        // EXPECT: %u
  printf("%lu", ll);        // EXPECT: %lld
  printf("%lld", l);        // EXPECT: %ld
  printf("%lli", ull);      // EXPECT: %llu
  printf("%llu", ul);       // EXPECT: %lu
  printf("%d", cul);        // EXPECT: %lu
  // The caller supplies promoted types; raw narrow types and enums are unsupported.
  printf("%lld", s);        // EXPECT: %d; RAW: none
  printf("%lld", us);       // EXPECT: %d; RAW: none
  printf("%lld", c);        // EXPECT: %d; RAW: none
  printf("%lld", b);        // EXPECT: %d; RAW: none
  printf("%lld", e);        // EXPECT: none
  // Per-conversion mapping, literal text, and escaped percent signs.
  printf("value=%d end", ull);       // EXPECT: %llu
  printf("%% %d %i", l, ull);        // EXPECT: %ld,%llu
  printf("%%", i);                  // NO_CONVERSION
  // Unsupported decorators and positional conversions must have no result.
  printf("%+d", ll);        // EXPECT: none
  printf("% d", ll);        // EXPECT: none
  printf("%-d", ll);        // EXPECT: none
  printf("%#d", ll);        // EXPECT: none
  printf("%'d", ll);        // EXPECT: none
  printf("%08d", ll);       // EXPECT: none
  printf("%12d", ll);       // EXPECT: none
  printf("%.d", ll);        // EXPECT: none
  printf("%.3d", ll);       // EXPECT: none
  printf("%*d", ll, i);     // EXPECT: none
  printf("%.*d", ll, i);    // EXPECT: none
  printf("%1$d", ll);       // EXPECT: none
  printf("%2$d %1$i", ll, ull); // EXPECT: none,none
  // Unsupported length flags, conversions, types, and malformed formats.
  printf("%hhd", ll);       // EXPECT: none
  printf("%hd", ll);        // EXPECT: none
  printf("%jd", ll);        // EXPECT: none
  printf("%zd", ll);        // EXPECT: none
  printf("%td", ll);        // EXPECT: none
  printf("%qd", ll);        // EXPECT: none
  printf("%I64d", ll);      // EXPECT: none
  printf("%x", ull);        // EXPECT: none
  printf("%X", ull);        // EXPECT: none
  printf("%o", ull);        // EXPECT: none
  printf("%c", ll);         // EXPECT: none
  printf("%s", ll);         // EXPECT: none
  printf("%p", ll);         // EXPECT: none
  printf("%f", i);          // EXPECT: none
  printf("%n", p);          // EXPECT: none
  printf("%d", f);          // EXPECT: none
  printf("%d", d);          // EXPECT: none
  printf("%d", p);          // EXPECT: none
  printf("%kd", ll);        // EXPECT: none
}
