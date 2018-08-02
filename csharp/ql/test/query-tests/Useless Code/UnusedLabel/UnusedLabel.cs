class UnusedLabelTest
{
    void F1()
    {
        goto a;
        a:  // GOOD
        ;
    }

    void F2()
    {
        a:  // BAD
        ;
    }
}
