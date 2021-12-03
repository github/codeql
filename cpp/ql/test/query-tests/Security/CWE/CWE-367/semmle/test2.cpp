// More test cases.  Some of these are inspired by real-world cases, others are synthetic or variations.

#define NULL 0

typedef struct {} FILE;
typedef struct {
	int foo;
} stat_data;

FILE *fopen(const char *filename, const char *mode);
int fclose(FILE *stream);

int open(const char *filename, int arg);
int creat(const char *filename, int arg);
int openat(int dir, const char *filename, int arg);
int close(int file);

bool stat(const char *path, stat_data *buf);
bool fstat(int file, stat_data *buf);
bool lstat(const char *path, stat_data *buf);
bool fstatat(int dir, const char *path, stat_data *buf);
void chmod(const char *path, int setting);
int rename(const char *from, const char *to);
bool remove(const char *path);

bool access(const char *path);

// --- open -> open ---

void test1_1(const char *path)
{
	FILE *f = NULL;

	f = fopen(path, "r");

	if (f == NULL)
	{
		// retry
		f = fopen(path, "r"); // GOOD (this is just trying again)
	}

	// ...
}

void test1_2(const char *path)
{
	FILE *f = NULL;

	// try until we succeed
	while (f == NULL)
	{
		f = fopen(path, "r"); // GOOD (this is just trying again)

		// ...
	}

	// ...
}

// --- stat -> open ---

void test2_1(const char *path)
{
	FILE *f = NULL;
	stat_data buf;

	if (stat(path, &buf))
	{
		f = fopen(path, "r"); // BAD
	}

	// ...
}

void test2_2(const char *path)
{
	FILE *f = NULL;
	stat_data buf;

	stat(path, &buf);
	if (buf.foo > 0)
	{
		f = fopen(path, "r"); // BAD
	}

	// ...
}

void test2_3(const char *path)
{
	FILE *f = NULL;
	stat_data buf;
	stat_data *buf_ptr = &buf;

	stat(path, buf_ptr);
	if (buf_ptr->foo > 0)
	{
		f = fopen(path, "r"); // BAD
	}

	// ...
}

bool stat_condition(const stat_data *buf);
bool other_condition();

void test2_4(const char *path)
{
	FILE *f = NULL;
	stat_data buf;

	stat(path, &buf);
	if (stat_condition(&buf))
	{
		f = fopen(path, "r"); // BAD
	}

	// ...
}

void test2_5(const char *path)
{
	FILE *f = NULL;
	stat_data buf;
	stat_data *buf_ptr = &buf;

	stat(path, buf_ptr);
	if (stat_condition(buf_ptr))
	{
		f = fopen(path, "r"); // BAD
	}

	// ...
}

void test2_6(const char *path)
{
	FILE *f = NULL;
	stat_data buf;

	stat(path, &buf);
	if (other_condition())
	{
		f = fopen(path, "r"); // GOOD (does not depend on the result of stat)
	}

	// ...
}

void test2_7(const char *path, int arg)
{
	stat_data buf;
	int f;

	if (stat(path, &buf))
	{
		f = open(path, arg); // BAD
	}

	// ...
}

void test2_8(const char *path, int arg)
{
	stat_data buf;
	int f;

	if (lstat(path, &buf))
	{
		f = open(path, arg); // BAD
	}

	// ...
}

void test2_9(const char *path, int arg)
{
	stat_data buf;
	int f;

	if (stat(path, &buf))
	{
		f = creat(path, arg); // BAD [NOT DETECTED]
	}

	// ...
}

void test2_10(int dir, const char *path, int arg)
{
	stat_data buf;
	int f;

	if (fstatat(dir, path, &buf))
	{
		f = openat(dir, path, arg); // BAD [NOT DETECTED]
	}

	// ...
}

void test2_11(const char *path, int arg)
{
	stat_data buf;
	int f;

	if (stat(path, &buf))
	{
		f = open(path, arg); // GOOD (here stat is just a redundant check that the file exists / path is valid, confirmed by the return value of open) [FALSE POSITIVE]
		if (f == -1)
		{
			// handle error
		}

		// ...
	}
}

void test2_12(const char *path, int arg)
{
	stat_data buf;
	int f;

	if (stat(path, &buf))
	{
		if (buf.foo == 11) // check a property of the file
		{
			f = open(path, arg); // BAD
			if (f == -1)
			{
				// handle error
			}
		}

		// ...
	}
}

void test2_13(const char *path, int arg)
{
	stat_data buf;
	FILE *f;

	if (stat(path, &buf)) // check the file does *not* exist
	{
		return;
	}

	f = fopen(path, "wt"); // BAD

	// ...
}

// --- open -> stat ---

void test3_1(const char *path, int arg)
{
	stat_data buf;
	int f;

	f = open(path, arg);
	if (stat(path, &buf)) // BAD [NOT DETECTED]
	{
		// ...
	}

	// ...
}

void test3_2(const char *path, int arg)
{
	stat_data buf;
	int f;

	f = open(path, arg);
	if (fstat(f, &buf)) // GOOD (uses file descriptor, not path)
	{
		// ...
	}

	// ...
}

// --- open -> chmod ---

void test4_1(const char *path)
{
	FILE *f = NULL;

	f = fopen(path, "w");
	if (f)
	{
		// ...

		fclose(f);

		chmod(path, 0); // BAD
	}
}

// --- rename -> remove / open ---

void test5_1(const char *path1, const char *path2)
{
	if (rename(path1, path2))
	{
		remove(path1); // DUBIOUS (bad but perhaps not exploitable)
	}
}

void test5_2(const char *path1, const char *path2)
{
	FILE *f = NULL;

	if (!rename(path1, path2))
	{
		f = fopen(path2, "r"); // BAD [NOT DETECTED]
	}
}

// --- access -> open ---

void test6_1(const char *path)
{
	FILE *f = NULL;

	if (access(path))
	{
		f = fopen(path, "r"); // BAD

		// ...
	}
}

void test6_2(const char *path)
{
	FILE *f = NULL;

	if (access(path))
	{
		// ...
	}

	f = fopen(path, "r"); // GOOD (appears not to be intended to depend on the access check)

	// ...
}

void test6_3(const char *path)
{
	FILE *f = NULL;

	if (!access(path))
	{
		f = fopen(path, "r"); // BAD

		// ...
	}
}

void test6_4(const char *path)
{
	FILE *f = NULL;

	if (access(path))
	{
		// ...
	} else {
		f = fopen(path, "r"); // BAD

		// ...
	}
}

void test6_5(const char *path1, const char *path2)
{
	FILE *f = NULL;

	if (access(path1))
	{
		f = fopen(path2, "r"); // GOOD (different file)

		// ...
	}
}

// --- open / rename -> chmod ---

void test7_1(const char *path)
{
	FILE *f;

	f = fopen(path, "wt");
	if (f != 0)
	{
		// ...
	
		fclose(f);

		chmod(path, 1234); // BAD
	}
}

void test7_1(const char *path1, const char *path2)
{
	if (!rename(path1, path2))
	{
		chmod(path2, 1234); // BAD
	}
}
