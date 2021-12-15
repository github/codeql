// Semmle test cases for rule CWE-772.

// library types, functions etc
#define NULL (0)
typedef int FILE;
FILE *fopen(const char *filename, const char *mode);
int fclose(FILE *stream);
char *fgets(char *s, int n, FILE *stream);

void test1()
{
	FILE *f;
	
	// fopen, always fclose (GOOD)
	f = fopen("myFile.txt", "wt");
	fclose(f);
}

void test2(int cond)
{
	FILE *f;

	// fopen, always fclose, but with two paths (GOOD)
	
	f = fopen("myFile1.bin", "rb");
	if (cond > 0)
	{
		fclose(f);
		return;
	}

	fclose(f);
}

void test3()
{
	FILE *f, *g;

	// fopen, always fclose, but via assignment (GOOD)
	
	f = fopen("myFile1.bin", "rb");
	g = f;
	fclose(g);
}

void test4()
{
	FILE *f;

	// fopen, never fclose (BAD: f is never closed)
	f = fopen("myFile.txt", "wt");
}

void test5(int cond)
{
	FILE *f;

	// fopen, sometimes fclose (BAD: f is not always closed)
	f = fopen("myFile.txt", "wt");
	if (cond == 0)
	{
		fclose(f);
	}
}

void test6(int cond)
{
	// fopen, sometimes fclose (BAD: f is not always closed)
	FILE *f = fopen("myFile.txt", "wt");

	if (cond == 0)
	{
		return;
	}
	
	fclose(f);
}

void test7()
{
	FILE *f, *g;

	// fopen, assign, close f twice (BAD: g is never closed)
	f = fopen("myFile.txt", "wt");
	g = fopen("myFile.txt", "wt");
	g = f;
	fclose(g);
	fclose(f);
}

FILE *test8_open()
{
	FILE *f = fopen("myFile.txt", "wt");

	return f;
}

void test8_close(FILE *f)
{
	fclose(f);
}

void test8(int cond)
{
	FILE *f, *g, *h;

	// fopen, close f via intermediate functions (GOOD)
	f = test8_open();

	// ...

	test8_close(f);
	
	// fopen, don't close (BAD: g is never closed)
	g = test8_open();
	
	// fopen, sometimes fclose (BAD: h is not always closed)
	h = test8_open();
	if (cond == 0)
	{
		return;
	}
	test8_close(h);
}

class myClass9
{
public:
	myClass9() : a(NULL), b(NULL), c(NULL)
	{
		a = fopen("myFile1.txt", "rt"); // closed in destructor (GOOD)
		b = fopen("myFile2.txt", "rt"); // unreliably closed in destructor (BAD) [NOT REPORTED]
		c = fopen("myFile3.txt", "rt"); // never closed in destructor (BAD)
	}
	
	void myOpenMethod(const char *filename)
	{
		if (d != NULL)
		{
			fclose(d);
			d = NULL;
		}

		d = fopen(filename, "rt"); // not always closed (BAD) [NOT REPORTED]
	}

	~myClass9()
	{
		if (a != NULL)
		{
			fclose(a);
			a = NULL;
		}
		if (a != NULL) // oops!
		{
			fclose(b);
			b = NULL;
		}
	}

private:
	FILE *a, *b, *c, *d;
};

void test9()
{
	myClass9 mc9;
	
	mc9.myOpenMethod("myFile4.txt");
	mc9.myOpenMethod("myFile5.txt");
}

void test10()
{
	// fopen, always fclose (GOOD)
	fclose(fopen("myFile.txt", "rt"));
}

void test11()
{
	FILE *f, *g;

	// fopen, assign, but do not close (BAD)
	f = fopen("myFile1.bin", "rb");
	g = f;
}

void test12()
{
	FILE *f;

	// fopen, null/valid check, and close (GOOD)
	f = fopen("myFile1.txt", "rt");
	if (f != NULL)
	{
		// ...
	} else {
		// ...
	}
	fclose(f);
}

void test13(int cond)
{
	FILE *f;

	// fopen, null/valid check, and close (GOOD)
	f = fopen("myFile1.txt", "rt");
	if (cond)
	{
		if (f != NULL)
		{
			// ...
		}
	}
	fclose(f);
}

void test14()
{
	FILE *f = fopen("f.txt", "rt"); // fopen, forget, don't close (BAD)

	f = 0;
	fclose(f);
}

void test15()
{
	FILE *f = fopen("f.txt", "rt"); // fopen, reassign, close (GOOD)
	FILE *g;

	g = f;
	f = g;
	fclose(f);
}

void test16()
{
	FILE *f = fopen("f.txt", "rt"); // fopen, always close in loop (GOOD)
	FILE *g = fopen("g.txt", "rt"); // fopen, don't close in loop (BAD)
	int i;

	for (i = 0; i < 1; i++)
	{
		fclose(f);
		break;
		fclose(g);
	}
}

void test17()
{
	FILE *f = fopen("f.txt", "rt"); // fopen, don't close in loop (BAD)
	int i;

	for (i = 0; i < 0; i++)
	{
		fclose(f);
	}
}

void test18()
{
	FILE *f = fopen("f.txt", "rt"); // fopen, close after loop (GOOD)
	int i;

	for (i = 0; i < 0; i++)
	{
		return;
	}
	fclose(f);
}

void test19()
{
	FILE *f = fopen("f.txt", "rt"); // fopen, return in loop, don't close (BAD)
	int i;

	for (i = 0; i < 1; i++)
	{
		return;
	}
	fclose(f);
}

void test20()
{
	FILE *f = fopen("f.txt", "rt"); // fopen, close in loop increment (GOOD)
	int i;

	for (i = 0; i < 1; fclose(f))
	{
		i++;
	}
}

void test21()
{
	FILE *f = fopen("f.txt", "rt"); // fopen, don't close in loop increment (BAD)
	int i;

	for (i = 0; i < 0; fclose(f))
	{
	}
}

void test22()
{
	FILE *f = fopen("f.txt", "rt"); // fopen, close in condition inside loop (GOOD)
	FILE *g = fopen("g.txt", "rt"); // fopen, don't close in condition inside loop (BAD)
	bool b = true;

	while (b)
	{
		if (true) {
			fclose(f);
		} else {
			fclose(g);
		}
		
		b = false;
	}
}

void test23()
{
	FILE *f;
	int i;

	for (i = 0; i < 10; i++)
	{
		f = fopen("f.txt", "rt"); // fopen, close repeatedly (GOOD)
		fclose(f);
	}
}

void test24()
{
	FILE *f = fopen("f.txt", "rt"); // fopen, close in nested loops (GOOD)
	int i, j, k;

	for (i = 0; i < 1; i++)
	{
		for (j = 0; j < 1; j++)
		{
			for (k = 0; k < 1; k++)
			{
				fclose(f);
			}
		}
	}
}

void test25()
{
	FILE *f = fopen("f.txt", "rt"); // fopen, don't close in nested loops (BAD)
	int i, j, k;

	for (i = 0; i < 1; i++)
	{
		for (j = 0; j < 0; j++)
		{
			for (k = 0; k < 1; k++)
			{
				fclose(f);
			}
		}
	}
}

void test26()
{
    FILE *f = fopen("f.txt", "rt"); // fopen, close after loop (GOOD)
    int i;

    for (i = 0; i < 10; i++)
    {
    }
    fclose(f);
}

void test27()
{
    FILE *f = fopen("f.txt", "rt"); // fopen, don't close after loop (BAD)
    int i;

    for (i = 0; i < 10; i++)
    {
    }
    if (false)
    {
        fclose(f);
    }
}



struct test28_struct
{
	FILE *f;
};

test28_struct *mk_test28(FILE *f)
{
	test28_struct *s;

	s = new test28_struct;
	s->f = f;

	return s;
}

test28_struct *test28_open()
{
	test28_struct *s;
	FILE *f;

	// open, call function to put in a struct, return it (GOOD)
	f = fopen("a.txt", "rt");
	s = mk_test28(f);
	
	return s;
}

void test28()
{
	test28_struct *s, *t;

	// open, close
	s = test28_open();
	fclose(s->f);
	delete s;
}

class test29_class
{
public:
	test29_class(FILE *_f) : f(_f) {};
	~test29_class() {fclose(f);}

private:
	FILE *f;
};

void test29()
{
	// open, hand ownership to a class that closes it (GOOD)
	{
		FILE *f = fopen("b.txt", "rt");
		test29_class myFileOwner1(f);
	}

	// open, hand ownership to a class that closes it (GOOD)
	{
		FILE *g = fopen("c.txt", "rt");
		test29_class myFileOwner2 = test29_class(g);
	}
}

void test30()
{
	// cases that do not involve a variable
	fopen("myFile.txt", "wt"); // BAD: not closed
	fclose(fopen("myFile.txt", "wt")); // GOOD
}

// run tests
int main(int argc, char *argv[])
{
	test1();
	test2(argc);
	test3();
	test4();
	test5(argc);
	test6(argc);
	test7();
	test8(argc);
	test9();
	test10();
	test11();
	test12();
	test13(argc);
	test14();
	test15();
	test16();
	test17();
	test18();
	test19();
	test20();
	test21();
	test22();
	test23();
	test24();
	test25();
	test26();
	test27();
	test28();
	test29();
	test30();
}
