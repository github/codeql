// Common declarations in this test dir should go in this file. Otherwise, some
// declarations will have multiple locations, which leads to confusing test
// output.

void sink(const char *sinkparam);
void sink(int sinkparam);

int atoi(const char *nptr);
char *getenv(const char *name);
char *strcat(char * s1, const char * s2);

char *strdup(const char *string);
char *_strdup(const char *string);
char *unmodeled_function(const char *const_string);

typedef unsigned long size_t;
void *memcpy(void *s1, const void *s2, size_t n);
