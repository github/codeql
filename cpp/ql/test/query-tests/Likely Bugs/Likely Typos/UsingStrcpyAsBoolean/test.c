typedef unsigned int size_t;
typedef int* locale_t;

char* strcpy(char* destination, const char* source)
{
    return destination;
}
char* strncpy(char* destination, const char* source, size_t count)
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

void PositiveCases()
{
    char szbuf1[100];
    char szbuf2[100];
    int result;

    if (strcpy(szbuf1, "test")) // $ Alert // Bug, direct usage
    {
    }

    if (!strcpy(szbuf1, "test")) // $ Alert // Bug, unary binary operator
    {
    }

    if (strcpy(szbuf1, "test") == 0) // $ Alert // Bug, equality operator
    {
    }

    if (SomeFunction() && strcpy(szbuf1, "test")) // $ Alert // Bug, binary logical operator
    {
    }

    if (strncpy(szbuf1, "test", 100))  // $ Alert // Bug
    {
    }

    if (!strncpy(szbuf1, "test", 100))  // $ Alert // Bug
    {
    }

    result = !strncpy(szbuf1, "test", 100); // $ Alert // Bug
    result = strcpy(szbuf1, "test") ? 1 : 0; // $ Alert // Bug
    result = strcpy(szbuf1, "test") && 1; // $ Alert // Bug

    result = strcpy(szbuf1, "test") == 0; // $ Alert // Bug

    result = strcpy(szbuf1, "test") != 0; // $ Alert // Bug
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

}
