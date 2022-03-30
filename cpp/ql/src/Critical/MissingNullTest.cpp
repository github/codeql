typedef struct {
	char name[100];
	int status;
} person;

void f() {
	person* buf = NULL;
	buf = malloc(sizeof(person));

	(*buf).status = 0; //access to buf before it was checked for NULL
}
