
class String
{
public:
	String(const char *_s);
	void set(const char *_s);
};

void create(const String &filename);
bool rename(const String &from, const String &to);
void remove(const String &filename);

void test1()
{
	String file1 = "a.txt";
	String file2 = "b.txt";

	create(file1);
	if (!rename(file1, file2))
	{
		remove(file1); // BAD
	}
}


void test2()
{
	String file1 = "a.txt";
	String file2 = "b.txt";

	create(file1);
	if (!rename(file1, file2))
	{
		file1.set("d.txt");
		remove(file1); // GOOD [FALSE POSITIVE]
	}
}


void test3()
{
	String file1 = "a.txt";
	String file2 = "b.txt";
	file1.set("d.txt");

	create(file1);
	if (!rename(file1, file2))
	{
		remove(file1); // BAD
	}
}
