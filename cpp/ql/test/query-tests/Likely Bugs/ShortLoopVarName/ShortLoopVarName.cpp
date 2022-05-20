
#define NULL (0)

void test1()
{
	int i, j, outer_loop_var, inner_loop_var;

	for (i = 0; i < 10; i++) // GOOD: no nested loop
	{
		// ...
	}
	for (i = 0; i < 10; i++) // BAD: short name
	{
		for (j = 0; j < 20; j++) // GOOD: no nested loop
		{
			// ...
		}
	}
	for (outer_loop_var = 0; outer_loop_var < 10; outer_loop_var++) // GOOD: long name
	{
		for (inner_loop_var = 0; inner_loop_var < 20; inner_loop_var++) // GOOD: long name
		{
			// ...
		}
	}
}

void test2(char *str)
{
	for (char *a = str; *a != NULL; a++) // BAD: short name
	{
		char *b = a; // GOOD: not a loop variable

		for (char *c = b; *c != NULL; c++) // GOOD: no nested loop
		{
			// ...
		}
	}
}

typedef unsigned int size_t;
void *malloc(size_t size);

struct string
{
	char str[256];
	unsigned int strlen;
};

void test3()
{
	unsigned char array1d[256];
	unsigned char array2d[256][256];
	unsigned char array3d[256][256][256];
	unsigned char *bitmap = (unsigned char *)malloc(256 * 256);

	for (int y = 0; y < 256; y++) // GOOD: x and y are a co-ordinate pair
	{
		for (int x = 0; x < 256; x++)
		{
			array2d[x][y] = 0;
		}
	}

	for (int y = 0; y < 256; y++) // GOOD: x and y are a co-ordinate pair
	{
		for (int x = 0; x < 256; x++)
		{
			bitmap[(y * 256) + x] = 0;
		}
	}

	for (int y = 0; y < 256; y++) // BAD: x and y are not a co-ordinate pair
	{
		for (int x = 0; x < 256; x++)
		{
			array1d[x] = 0;
			array1d[y] = 0;
		}
	}
	
	for (int z = 0; z < 256; z++) // GOOD: x, y and z are co-ordinates
	{
		for (int y = 0; y < 256; y++) // GOOD: x, y and z are co-ordinates
		{
			for (int x = 0; x < 256; x++)
			{
				array3d[x][y][z] = 0;
			}
		}
	}
	
	{
		string strings[10];

		for (int i = 0; i < 10; i++) // BAD: x and y are not a co-ordinate pair
		{
			for (int j = 0; j < strings[i].strlen; j++)
			{
				strings[i].str[j] = 0;
			}
		}
	}
}
