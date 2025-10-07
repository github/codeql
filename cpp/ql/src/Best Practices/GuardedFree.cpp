void test()
{
    char *foo = malloc(100);

    // BAD
    if (foo)          
        free(foo);

    // GOOD
    free(foo);
}