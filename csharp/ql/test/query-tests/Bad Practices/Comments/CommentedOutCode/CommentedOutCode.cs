
class Class
{
    /// GOOD: XML doc comments are ignored
    /// int x;
    /// int y;

    // GOOD: This is not code
    // a
    // a

    // GOOD: There is not enough code here to trigger
    // the rule
    //
    // int x=0;
    // if(x>0)
    //    f();
    //

    // BAD: There is commented out code here
    //
    // int x=2;
    // int y=3; // Comment
    // int z=4; // Comment
    //
    // end of example
}
