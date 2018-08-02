
typedef unsigned int size_t;
void *memcpy(void *destination, const void *source, size_t num);

void f1(char s[]) {
	int size = sizeof(s); // BAD
	                      // s is now a char*, not an array. 
	                      // sizeof(s) will evaluate to sizeof(char *)
	int size2 = sizeof(s[0]); // GOOD
}

void f2(char s[10]) {
	int size = sizeof(s); // BAD
	int size2 = sizeof(s[0]); // GOOD
}

typedef char myarray[10];

void f3(myarray s) {
	int size = sizeof(s); // BAD
	int size2 = sizeof(s[0]); // GOOD
}

struct container
{
	char *ptr;
	int array[10];
};

void f4(container *s) {
	int size = sizeof(s); // (dubious)
	int size3 = sizeof(s->ptr); // GOOD
	int size2 = sizeof(s->array); // GOOD
}

void f5(container *s) {
	container *t;
    
    memcpy(&t, &s, sizeof(s)); // GOOD
}

void f6(container *s) {
	container t;
    
    memcpy(&t, s, sizeof(s)); // BAD
}

void f7(container *s) {
	container t;
    
    memcpy(&t, s, sizeof(*s)); // GOOD
}

class myClass {};
typedef myClass *myClassPtr;

void f8(const myClassPtr s[]) {
	int size = sizeof(s); // BAD
}
