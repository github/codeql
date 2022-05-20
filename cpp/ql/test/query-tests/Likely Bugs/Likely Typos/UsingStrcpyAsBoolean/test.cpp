typedef unsigned long size_t; 
typedef int* locale_t;

char* strcpy(char* destination, const char* source)
{
    return destination;
}
wchar_t* wcscpy(wchar_t* destination, const wchar_t* source)
{
    return destination;
}
unsigned char* _mbscpy(unsigned char* destination, const unsigned char* source)
{
    return destination;
}
char* strncpy(char* destination, const char* source, size_t count)
{
    return destination;
}
wchar_t* wcsncpy(wchar_t* destination, const wchar_t* source, size_t count)
{
    return destination;
}
unsigned char* _mbsncpy(unsigned char* destination, const unsigned char* source, size_t count)
{
    return destination;
}
char* _strncpy_l(char* destination, const char* source, size_t count, locale_t locale)
{
    return destination;
}
wchar_t* _wcsncpy_l(wchar_t* destination, const wchar_t* source, size_t count, locale_t locale)
{
    return destination;
}
unsigned char* _mbsncpy_l(unsigned char* destination, const unsigned char* source, size_t count, locale_t locale)
{
    return destination;
}

int SomeFunction()
{
    return 1;
}

int SomeFunctionThatTakesString(char* destination)
{
    return 1;
}

int strcmp(char* destination, const char* source)
{
    return 1;
}

int strcpy_s(char* destination, size_t dest_size, const char* source)
{
    return 1;
}

#define WCSCPY_6324(x,y) wcscpy(x,y)

void PositiveCases()
{
    char szbuf1[100];
    char szbuf2[100];
    wchar_t wscbuf1[100];
    wchar_t wscbuf2[100];
    unsigned char mbcbuf1[100];
    unsigned char mbcbuf2[100];

    locale_t x;
    *x = 0;

    if (strcpy(szbuf1, "test")) // Bug, direct usage
    {
    }

    if (!strcpy(szbuf1, "test")) // Bug, unary binary operator
    {
    }

    if (strcpy(szbuf1, "test") == 0) // Bug, equality operator
    {
    }

    if (SomeFunction() && strcpy(szbuf1, "test")) // Bug, binary logical operator
    {
    }

    if (WCSCPY_6324(wscbuf1, wscbuf2)) // Bug, using a macro
    {
    }

    if (wcscpy(wscbuf1, wscbuf2)) // Bug
    {
    }

    if (_mbscpy(mbcbuf1, mbcbuf2)) // Bug
    {
    }

    if (strncpy(szbuf1, "test", 100))  // Bug
    {
    }

    if (wcsncpy(wscbuf1, wscbuf2, 100)) // Bug
    {
    }

    if (_mbsncpy(mbcbuf1, (const unsigned char*)"test", 100)) // Bug
    {
    }

    if (_strncpy_l(szbuf1, "test", 100, x))  // Bug
    {
    }

    if (_wcsncpy_l(wscbuf1, wscbuf2, 100, x)) // Bug
    {
    }

    if (_mbsncpy_l(mbcbuf1, (const unsigned char*)"test", 100, x)) //Bug
    {
    }

    if (!strncpy(szbuf1, "test", 100))  // Bug
    {
    }

    bool b = strncpy(szbuf1, "test", 100); // Bug

    bool result = !strncpy(szbuf1, "test", 100); // Bug
    result = strcpy(szbuf1, "test") ? 1 : 0; // Bug
    result = strcpy(szbuf1, "test") && 1; // Bug

    result = strcpy(szbuf1, "test") == 0; // Bug

    result = strcpy(szbuf1, "test") != 0; // Bug

}

void NegativeCases()
{
    char szbuf1[100];

    if (SomeFunction())
    {
    }

    if (SomeFunctionThatTakesString(strcpy(szbuf1, "test")))
    {
    }

    if (strcmp(szbuf1, "test"))
    {
    }

    if (strcpy_s(szbuf1, 100, "test"))
    {
    }

}
