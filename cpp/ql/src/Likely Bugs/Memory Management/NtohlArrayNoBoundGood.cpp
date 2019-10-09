u_short s;
char *buf;

u_short converted_s = ntohs(s);
if (converted_s < 100) {
	// GOOD: guarded locally
	buf[converted_s];
}
