u_short s;
char *buf;

// BAD: unguarded
buf[ntohs(s)];