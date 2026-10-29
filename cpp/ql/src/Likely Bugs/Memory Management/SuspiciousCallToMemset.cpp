
// correct, memset uses sizeof(type)
int is[10];
memset(is, 0, sizeof(is));
struct S s;
memset(&s, 0, sizeof(struct S));

// incorrect examples
struct T *t1 = (struct T*)malloc(sizeof(struct T));
struct T *t2 = (struct T*)malloc(sizeof(struct T));
// the size of the struct is probably intended
// but this takes the size of a pointer
memset(t2, 0, sizeof(t2));

// correct but discouraged, use sizeof(struct T) instead
memset(t1, 0, sizeof(*t2));
// correct, but it is preferred to do a direct assignment, i.e., t = 0;
memset(&t2, 0, sizeof(t2));
