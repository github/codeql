//semmle-extractor-options: --edg --target --edg win64

// A selection of tests from the SAMATE Juliet framework for rule CWE-197.

// library types, functions etc
typedef struct {} FILE;
int fscanf(FILE *stream, const char *format, ...);
#define CHAR_MAX (127)
FILE *stdin;

void printHexCharLine(char charHex);

// ----------

class CWE197_Numeric_Truncation_Error__short_fscanf_82_base
{
public:
    /* pure virtual function */
    virtual void action(short data) = 0;
};

class CWE197_Numeric_Truncation_Error__short_fscanf_82_bad : public CWE197_Numeric_Truncation_Error__short_fscanf_82_base
{
public:
    void action(short data);
};

class CWE197_Numeric_Truncation_Error__short_fscanf_82_goodG2B : public CWE197_Numeric_Truncation_Error__short_fscanf_82_base
{
public:
    void action(short data);
};

void CWE197_Numeric_Truncation_Error__short_fscanf_82_bad::action(short data)
{
    {
        /* POTENTIAL FLAW: Convert data to a char, possibly causing a truncation error */
        char charData = (char)data;
        printHexCharLine(charData);
    }
}

void CWE197_Numeric_Truncation_Error__short_fscanf_82_goodG2B::action(short data)
{
    {
        char charData = (char)data;
        printHexCharLine(charData);
    }
}

void bad()
{
    short data;
    /* Initialize data */
    data = -1;
    /* FLAW: Use a number input from the console using fscanf() */
    fscanf (stdin, "%hd", &data);
    CWE197_Numeric_Truncation_Error__short_fscanf_82_base* baseObject = new CWE197_Numeric_Truncation_Error__short_fscanf_82_bad;
    baseObject->action(data);
    delete baseObject;
}

/* goodG2B uses the GoodSource with the BadSink */
static void goodG2B()
{
    short data;
    /* Initialize data */
    data = -1;
    /* FIX: Use a positive integer less than CHAR_MAX*/
    data = CHAR_MAX-5;
    CWE197_Numeric_Truncation_Error__short_fscanf_82_base* baseObject = new CWE197_Numeric_Truncation_Error__short_fscanf_82_goodG2B;
    baseObject->action(data);
    delete baseObject;
}
