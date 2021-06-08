
typedef signed long long int s64;

typedef struct {} FILE;
int fscanf(FILE *stream, const char *format, ...);
FILE *stdin;

typedef struct _myStruct {
	s64 val;
} MyStruct;

void test2_sink(s64 v, MyStruct s, MyStruct &s_r, MyStruct *s_p)
{
	s64 v1 = v * 2; // bad
	s64 v2 = s.val * 2; // bad
	s64 v3 = s_r.val * 2; // bad
	s64 v4 = s_p->val * 2; // bad
}

void test2_source()
{
	MyStruct ms;
	s64 v;

	fscanf(stdin, "%i", &v);
	ms.val = v;
	test2_sink(v, ms, ms, &ms);
}
