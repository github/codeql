/* Example of good macros */
#define TCP_NODELAY             1
#define TCP_MAXSEG              2
#define TCP_CORK                3

/*
 * In contrast, functions that use this macro are hard to read without
 * knowing its exact definition
 */
#define JSKW_TEST_GUESS(index)  i = (index); goto test_guess;
