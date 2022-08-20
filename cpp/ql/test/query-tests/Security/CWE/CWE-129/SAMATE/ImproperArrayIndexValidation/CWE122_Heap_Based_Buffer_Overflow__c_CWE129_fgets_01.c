// Snippet from a SAMATE Juliet test case for rule CWE-122 / CWE-129
// CWE122_Heap_Based_Buffer_Overflow__c_CWE129_fgets_01.c

typedef unsigned long size_t;
void *malloc(size_t size);
void free(void *ptr);
#define NULL (0)

typedef struct {} FILE;
FILE *stdin;
char *fgets(char *s, int n, FILE *stream);

int atoi(const char *nptr);

void printLine(const char *str);
void printIntLine(int val);

// ---

#define CHAR_ARRAY_SIZE (64)

void CWE122_Heap_Based_Buffer_Overflow__c_CWE129_fgets_01_bad()
{
    int data;
    /* Initialize data */
    data = -1;
    {
        char inputBuffer[CHAR_ARRAY_SIZE] = "";
        /* POTENTIAL FLAW: Read data from the console using fgets() */
        if (fgets(inputBuffer, CHAR_ARRAY_SIZE, stdin) != NULL)
        {
            /* Convert to int */
            data = atoi(inputBuffer);
        }
        else
        {
            printLine("fgets() failed.");
        }
    }
    {
        int i;
        int * buffer = (int *)malloc(10 * sizeof(int));
        /* initialize buffer */
        for (i = 0; i < 10; i++)
        {
            buffer[i] = 0;
        }
        /* POTENTIAL FLAW: Attempt to write to an index of the array that is above the upper bound
         * This code does check to see if the array index is negative */
        if (data >= 0)
        {
            buffer[data] = 1;
            /* Print the array values */
            for(i = 0; i < 10; i++)
            {
                printIntLine(buffer[i]);
            }
        }
        else
        {
            printLine("ERROR: Array index is negative.");
        }
        free(buffer);
    }
}