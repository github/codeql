typedef int (*CallbackFn)(int a, int b);

int Callback_1(int a, int b)
{
	return a + b;
}

int Callback_2(int a, int b)
{
	return a;
}

int Callback_3(int, int b)
{
	return b;
}

void Dispatch(int n, int a, int b, int c, int)
{
	CallbackFn pFn;
	switch(n)
	{
		case 0: pFn = &Callback_1; break;
		case 1: pFn = &Callback_2; break;
		default: pFn = &Callback_3; break;
	}
	(*pFn)(a,b);
}
