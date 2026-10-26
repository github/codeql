#define RECORD_SIZE 30  //incorrect or outdated size for record
typedef struct {
	char name[30];
	int status;
} Record;

void f() {
	Record* p = malloc(RECORD_SIZE); //not of sufficient size to hold a Record
	...
}
