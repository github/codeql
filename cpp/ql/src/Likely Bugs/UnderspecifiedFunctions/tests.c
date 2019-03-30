//void three_arguments();
void three_arguments(int x, char y, int *z);
void pointer_arguments(float *x, void *y, int **z);
void array_argument(int arr[6]);
void array_argument2(char arr[6]);
int var;
void *pv;
double  d = 3732.70e13L;
extern unsigned long long *ull;

extern void *a[3];

void calls() {
	three_arguments(*ull, 2, &var); // BAD: arguments 1 and 3 do not match parameters
	three_arguments(&ull, 2, &var); // BAD: arguments 1 and 3 do not match parameters
	three_arguments(&var, 2, &var); // BAD: arguments 1 and 3 do not match parameters
	three_arguments(var, 2, 3.0f); // BAD: arguments 1 and 3 do not match parameters

	pointer_arguments(20, 0, 0);   // BAD
	pointer_arguments(pv, &var, &pv);  // GOOD
	pointer_arguments(&pv, &var, pv);  // BAD
	pointer_arguments(&var, a, &pv);  // BAD
	pointer_arguments(&var, &pv, a);  // BAD

	array_argument(&var);
	array_argument(pv);
	array_argument(10);
	array_argument("Hello");

	array_argument2("Hello");

}

