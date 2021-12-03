#ifndef UNMATCHED_A
#define UNMATCHED_A
#endif

int unmatched; // BAD: this file requires a header guard.

#ifndef UNMATCHED_B
#define UNMATCHED_B
#endif /* No trailing newline; this is important. */