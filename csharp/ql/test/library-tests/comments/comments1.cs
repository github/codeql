// Start of comment1.cs
// This tests the basic types of comment block

// 1) Basic comment types

// A single-line comment

/// An XML comment
class C { }

/* A multiline comment */

// 2) Comment blocks

// A line on its own is a commentblock

// Two lines together
// are in the same commentblock

// Three lines
// in the same
// commentblock

/* This is a */  /* single comment block */

/* This is a
   true multiline
   comment */

// These three lines,
/* even though they are using different commenting styles, */
/// form a single commentblock

class Foo
{
    /*
    */
    // This is not the same comment block
    int x;  // as this line
            // because they are offset differently.

    int y;    // These are different
    int z;    // comment blocks.
}

// End of comment1.cs
