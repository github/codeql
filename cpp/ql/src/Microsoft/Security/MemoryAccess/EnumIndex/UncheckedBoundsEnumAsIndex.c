typedef enum {
    exampleSomeValue,
    exampleSomeOtherValue,
    exampleValueMax
} EXAMPLE_VALUES;

/*...*/

int variable = someStructure->example;
if (variable >= exampleValueMax)
{
    /* ... Some action ... */
}
// ...
Status = someArray[variable](/*...*/);