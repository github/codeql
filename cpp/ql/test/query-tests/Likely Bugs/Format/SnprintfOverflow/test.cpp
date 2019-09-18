
typedef unsigned int size_t;
int snprintf(char *s, size_t n, const char *format, ...);

class queue
{
public:
	queue();
	~queue();

	bool has_number();
	int get_number();

private:
	// ...
};

void test1(queue &numbers)
{
	char buffer[100];
	int pos = 0;

	while (numbers.has_number())
	{
		pos += snprintf(&(buffer[pos]), 100 - pos, "%i, ", numbers.get_number()); // BAD
	}
}

void test2(queue &numbers)
{
	char buffer[100];
	int pos = 0;

	while ((numbers.has_number()) && (pos < 100))
	{
		pos += snprintf(&(buffer[pos]), 100 - pos, "%i, ", numbers.get_number()); // GOOD
	}
}

void test3(queue &numbers)
{
	char buffer[100];
	int pos = 0;

	while (numbers.has_number())
	{
		pos += snprintf(&(buffer[pos]), 100 - pos, "%i, ", numbers.get_number()); // GOOD
		if (pos > 100)
		{
			pos = 100;
		}
	}
}

void test4(queue &numbers)
{
	char buffer[100], *ptr;
	size_t amount, remaining;

	while (numbers.has_number())
	{
		amount = snprintf(ptr, remaining, "%i, ", numbers.get_number()); // BAD
		ptr += amount;
		remaining -= amount;
	}
}

void test5(queue &numbers)
{
	char buffer[100];
	char *ptr = buffer;
	char *end = &(buffer[100]);

	while (numbers.has_number())
	{
		ptr += snprintf(ptr, end - ptr, "%i, ", numbers.get_number()); // BAD
	}
}

void test6(const char *sa, const char *sb)
{
	char buffer[100];
	int pos = 0;

	pos = snprintf(buffer, 100, "'%s', ", sa);
	pos += snprintf(&(buffer[pos]), 100 - pos, "'%s'.", sb); // BAD [NOT DETECTED]
}

size_t strlen(const char *str);
typedef size_t rsize_t;
int snprintf_s(char * /*restrict*/ s, rsize_t n, const char * /*restrict*/ format, ...);

void test7(const char *strings) // separated by \0, terminated by \0\0
{
	char buffer[256];
	int pos = 0;

	while (*strings != 0)
	{
		pos += snprintf_s(buffer + pos, sizeof(buffer) - pos, "%s\n", strings); // BAD
			// (note that the protections built into `snprintf_s` appear to mean this is less likely
			//  to be exploitable than with `snprintf`)
		strings += strlen(strings) + 1;
	}
}

void concat_strings(char *buf, size_t buf_len, const char **strings, size_t n_strings) {
  while (n_strings > 0) {
    int ret = snprintf(buf, buf_len, "%s", *strings); // GOOD
    if (ret > buf_len)
      return;
    buf_len -= ret;
    buf += ret;
    n_strings--;
    strings++;
  }
}
