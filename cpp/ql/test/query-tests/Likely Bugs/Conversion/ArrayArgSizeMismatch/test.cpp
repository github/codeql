
typedef unsigned long size_t;
void *malloc(size_t size);

#define NUM (4)

void f(int *vs);
void g(int vs[4]);
void h(float fs[NUM]);

struct myStruct
{
	unsigned int num;
	float data[0];
};

void test(float f3[3], float f4[4], float f5[5], float *fp)
{
	int arr3[3], arr4[4], arr5[5];

	f(arr3); // GOOD
	f(arr4); // GOOD
	f(arr5); // GOOD
	g(arr3); // BAD
	g(arr4); // GOOD
	g(arr5); // GOOD

	h(f3); // BAD [NOT DETECTED]
	h(f4); // GOOD
	h(f5); // GOOD
	h(fp); // GOOD

	{
		// variable size struct
		myStruct *ms;

		ms = (myStruct *)malloc(sizeof(myStruct) + (4 * sizeof(float)));
		ms->num  = 4;
		ms->data[0] = ms->data[1] = ms->data[2] = ms->data[3] = 0;
		h(ms->data); // GOOD
	}
	
	{
		// char array
		char ca[4 * sizeof(int)];
		
		g((int *)ca); // GOOD
	}
};
