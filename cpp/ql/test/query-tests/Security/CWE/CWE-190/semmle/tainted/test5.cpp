
char *gets(char *s);
unsigned long int strtoul( const char * nptr, char ** endptr, int base);

int getTaintedInt()
{
	char buf[128];

	gets(buf); // $ Source[cpp/tainted-arithmetic]
	return strtoul(buf, 0, 10); // $ Alert[cpp/integer-overflow-tainted]
}

void useTaintedInt()
{
	int x, y;

	x = getTaintedInt() * 1024; // $ Alert[cpp/integer-overflow-tainted] Alert[cpp/tainted-arithmetic] // BAD: arithmetic on a tainted value
	y = getTaintedInt();
	y = y * 1024; // $ Alert[cpp/integer-overflow-tainted] Alert[cpp/tainted-arithmetic] // BAD: arithmetic on a tainted value
}

typedef long long int intmax_t;

intmax_t imaxabs(intmax_t j);

void useTaintedIntWithGuard() {
	int tainted = getTaintedInt();

	if(imaxabs(tainted) <= 100) {
		int product = tainted * tainted; // GOOD: can't underflow/overflow
	}
}

#define INTMAX_MIN (-0x7fffffffffffffff - 1)

void useTaintedIntWithGuardIntMaxMin() {
	intmax_t tainted = getTaintedInt();

	if(imaxabs(tainted) <= INTMAX_MIN) {
		int product = tainted * tainted; // BAD: imaxabs(INTMAX_MIN) == INTMAX_MIN [NOT DETECTED]
	}
}
