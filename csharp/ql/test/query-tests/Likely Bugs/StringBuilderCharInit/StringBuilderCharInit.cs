using System.Text;

class Test
{
    static void Main()
    {
        new StringBuilder();
        new StringBuilder(12);
        new StringBuilder('a');         // $ Alert // BAD
        new StringBuilder(3, 4);
        new StringBuilder(3, 'a');        // $ Alert // BAD
        new StringBuilder('a', 'b');      // $ Alert // BAD
        new StringBuilder("");
        new StringBuilder("", 12);
        new StringBuilder("", 'a');       // $ Alert // BAD
        new StringBuilder("abc", 1, 1, 12);
        new StringBuilder("abc", 1, 1, 'a');  // $ Alert // BAD
    }
}
