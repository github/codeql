
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

const char *url_g = "http://example.com"; // BAD [NOT DETECTED]

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
