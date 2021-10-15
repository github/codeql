
int x = 0;

void called1()
{
	x++;
}

void called2()
{
	x++;
}

void not_called()
{
	x++; // BAD: unreachable
}

int main(int argc, const char* argv[])
{
	void (*fun_ptr)() = &called2;

	called1();
	called2();

	if (argc > 4)
	{
		x++;
		while (1) {
			x++;
		}
		x++; // BAD: unreachable
	} else if (argc > 4) {
		x++; // BAD: unreachable [NOT DETECTED]
	} else if (argc > 5) {
		x++; // BAD: unreachable [NOT DETECTED]
	}
}
