
void openUrl(char *url)
{
	// ...
}

openUrl("http://example.com"); // BAD

openUrl("https://example.com"); // GOOD: Opening a connection to a URL using HTTPS enforces SSL.
