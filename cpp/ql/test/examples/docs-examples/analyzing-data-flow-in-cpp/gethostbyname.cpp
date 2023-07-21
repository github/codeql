struct hostent;
hostent * gethostbyname(const char * name);
char * getenv(const char * name);

void test_gethostbyname(const char * url1) {
    const char * url2 = "https://github.com";
    const char * hostname1 = getenv("HOSTNAME1");

    hostent * host0 = gethostbyname("https://github.com");
    hostent * host1 = gethostbyname(url1);
    hostent * host2 = gethostbyname(url2);
    hostent * host3 = gethostbyname(getenv("HOSTNAME0"));
    hostent * host4 = gethostbyname(hostname1);
}
