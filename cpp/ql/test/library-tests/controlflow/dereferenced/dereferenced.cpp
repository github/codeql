
int *global_ptr;
const char *global_string = "hello, world";

void test1(int *ptr, int &ref)
{
	const char *str;
	int v, *p;
	char c;

	v = *ptr; // `ptr` dereferenced
	v = ptr[0]; // `ptr` dereferenced
	p = ptr;

	*ptr = 0; // `ptr` dereferenced
	ptr[0] = 0; // `ptr` dereferenced
	ptr = 0;

	(*ptr)++; // `ptr`, `*ptr` dereferenced
	*(ptr++); // `ptr++` dereferenced
	ptr++;

	v = ref; // (`ref` implicitly dereferenced, not detected)
	p = &ref;
	ref = 0; // (`ref` implicitly dereferenced, not detected)
	ref++; // (`ref` implicitly dereferenced, not detected)

	*global_ptr; // `global_ptr` dereferenced
	str = global_string;
	c = global_string[5]; // `global_string` dereferenced
}

struct myStruct
{
	int x;
	void f() {};
	void (*g)();
};

void test1(myStruct *ms)
{
	void (*h)();

	ms;
	ms->x; // `ms` dereferenced
	ms->f(); // `ms` dereferenced
	ms->g(); // `ms` dereferenced
	h = ms->g; // `ms` dereferenced
}
