
struct host
{
	// ...
};

host gethostbyname(char *str);
char *strcpy(char *s1, const char *s2);
char *strcat(char *s1, const char *s2);

void openUrl(char *url)
{
	// ...

	host myHost = gethostbyname(url);

	// ...
}

void doNothing(char *url)
{
}

char *urls[] = { "http://example.com" };

void test()
{
	openUrl("http://example.com"); // BAD
	openUrl("https://example.com"); // GOOD (https)
	openUrl("http://localhost/example"); // GOOD (localhost)
	openUrl("https://localhost/example"); // GOOD (https, localhost)
	doNothing("http://example.com"); // GOOD (URL not used)
	openUrl(urls[0]); // BAD [NOT DETECTED]

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
