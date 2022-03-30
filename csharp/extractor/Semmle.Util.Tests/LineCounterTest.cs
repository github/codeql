using Xunit;

using Semmle.Util;

namespace SemmleTests
{
    public class LineCounterTest
    {
        //#################### PRIVATE VARIABLES ####################
        #region

        #endregion

        //#################### TEST METHODS ####################
        #region

        [Fact]
        public void ComputeLineCountsTest1()
        {
            var input = "Console.WriteLine();";
            Assert.Equal(new LineCounts { Total = 1, Code = 1, Comment = 0 }, LineCounter.ComputeLineCounts(input));
        }

        [Fact]
        public void ComputeLineCountsTest2()
        {
            var input = "Console.WriteLine();   // Wibble";
            Assert.Equal(new LineCounts { Total = 1, Code = 1, Comment = 1 }, LineCounter.ComputeLineCounts(input));
        }

        [Fact]
        public void ComputeLineCountsTest3()
        {
            var input = "Console.WriteLine();\n";
            Assert.Equal(new LineCounts { Total = 2, Code = 1, Comment = 0 }, LineCounter.ComputeLineCounts(input));
        }

        [Fact]
        public void ComputeLineCountsTest4()
        {
            var input = "\nConsole.WriteLine();";
            Assert.Equal(new LineCounts { Total = 2, Code = 1, Comment = 0 }, LineCounter.ComputeLineCounts(input));
        }

        [Fact]
        public void ComputeLineCountsTest5()
        {
            var input = "\nConsole.WriteLine();\nConsole.WriteLine();   // Foo\n";
            Assert.Equal(new LineCounts { Total = 4, Code = 2, Comment = 1 }, LineCounter.ComputeLineCounts(input));
        }

        [Fact]
        public void ComputeLineCountsTest6()
        {
            var input =
@"
/*
There once was a counter of lines,
Which worked (if one trusted the signs) -
But best to be sure,
For in old days of yore
Dodgy coders were sent down the mines.
*/

using System;   // always useful

class Program
{
    static void Main(string[] args)
    {
        // Print out something inane.
        Console.WriteLine(""Something inane!"");
    }
}
";
            Assert.Equal(new LineCounts { Total = 20, Code = 8, Comment = 9 }, LineCounter.ComputeLineCounts(input));
        }

        #endregion
    }
}
