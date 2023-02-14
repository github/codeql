
struct host
{
	// ...
};

host gethostbyname(const char *str);
char *strcpy(char *s1, const char *s2);
char *strcat(char *s1, const char *s2);

void openUrl(const char *url)
{
	// ...

	host myHost = gethostbyname(url);

	// ...
}

void doNothing(char *url)
{
}

const char *url_g = "http://example.com"; // BAD

void test()
{
	openUrl("http://example.com"); // BAD
	openUrl("https://example.com"); // GOOD (https)
	openUrl("http://localhost/example"); // GOOD (localhost)
	openUrl("https://localhost/example"); // GOOD (https, localhost)
	doNothing("http://example.com"); // GOOD (URL not used)

	{
		const char *url_l = "http://example.com"; // BAD
		const char *urls[] = { "http://example.com" }; // BAD

		openUrl(url_g);
		openUrl(url_l);
		openUrl(urls[0]);
	}

	{
		char buffer[1024];

		strcpy(buffer, "http://"); // BAD
		strcat(buffer, "example.com");

		openUrl(buffer);
	}

	{
		char buffer[1024];

		strcpy(buffer, "https://"); // GOOD (https)
		strcat(buffer, "example.com");

		openUrl(buffer);
	}
}

typedef unsigned long size_t;
int strncmp(const char *s1, const char *s2, size_t n);
char* strstr(char* s1, const char* s2);

void test2(const char *url)
{
	if (strncmp(url, "http://", 7)) // GOOD (or at least dubious; we are not constructing the URL)
	{
		openUrl(url);
	}
}

void test3(char *url)
{
	char *ptr;

	ptr = strstr(url, "https://"); // GOOD (https)
	if (!ptr)
	{
		ptr = strstr(url, "http://"); // GOOD (we are not constructing the URL)
	}

	if (ptr)
	{
		openUrl(ptr);
	}
}

void test4(char *url)
{
	const char *https_string = "https://"; // GOOD (https)
	const char *http_string = "http://"; // GOOD (we are not constructing the URL)
	char *ptr;

	ptr = strstr(url, https_string);
	if (!ptr)
	{
		ptr = strstr(url, http_string);
	}

	if (ptr)
	{
		openUrl(ptr);
	}
}

void test5()
{
	char *url_string = "http://example.com"; // BAD
	char *ptr;

	ptr = strstr(url_string, "https://"); // GOOD (https)
	if (!ptr)
	{
		ptr = strstr(url_string, "http://"); // GOOD (we are not constructing the URL here)
	}

	if (ptr)
	{
		openUrl(ptr);
	}
}
