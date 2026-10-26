#define RECORD_SIZE 30  //incorrect or outdated size for record
typedef struct {
	char name[30];
	int status;
} Record;

void f() {
	Record* p = malloc(RECORD_SIZE * 4); //wrong: not a multiple of the size of Record
	p[3].status = 1; //will most likely segfault
	...
}
