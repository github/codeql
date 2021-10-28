// Some SAMATE Juliet test cases for rule CWE-190.

///// Library functions //////

typedef struct {} FILE;
extern FILE *stdin;
int fscanf(FILE *stream, const char *format, ...);
int rand(void);

#define URAND31() (((unsigned)rand()<<30) ^ ((unsigned)rand()<<15) ^ rand())
#define RAND32() ((int)(rand() & 1 ? URAND31() : -URAND31() - 1))

void printUnsignedLine(unsigned unsignedNumber);

//// Test code /////

void CWE191_Integer_Underflow__unsigned_int_rand_sub_01_bad()
{
    unsigned int data;
    data = 0;
    /* POTENTIAL FLAW: Use a random value */
    data = (unsigned int)RAND32();
    {
        /* POTENTIAL FLAW: Subtracting 1 from data could cause an underflow */
        unsigned int result = data - 1;
        printUnsignedLine(result);
    }
}

void CWE191_Integer_Underflow__unsigned_int_rand_postdec_01_bad()
{
    unsigned int data;
    data = 0;
    /* POTENTIAL FLAW: Use a random value */
    data = (unsigned int)RAND32();
    {
        /* POTENTIAL FLAW: Decrementing data could cause an underflow */
        data--;
        unsigned int result = data;
        printUnsignedLine(result);
    }
}

void CWE191_Integer_Underflow__unsigned_int_min_postdec_01_bad()
{
    unsigned int data;
    data = 0;
    /* POTENTIAL FLAW: Use the minimum size of the data type */
    data = 0;
    {
        /* POTENTIAL FLAW: Decrementing data could cause an underflow [NOT DETECTED] */
        data--;
        unsigned int result = data;
        printUnsignedLine(result);
    }
}

void CWE191_Integer_Underflow__unsigned_int_fscanf_predec_01_bad()
{
    unsigned int data;
    data = 0;
    /* POTENTIAL FLAW: Use a value input from the console */
    fscanf (stdin, "%u", &data);
    {
        /* POTENTIAL FLAW: Decrementing data could cause an underflow */
        --data;
        unsigned int result = data;
        printUnsignedLine(result);
    }
}
