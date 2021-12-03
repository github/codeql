using System;
using Xunit;
using Assert = Xunit.Assert;

using Semmle.Util;

namespace SemmleTests
{
    public class TextTest
    {
        //#################### PRIVATE VARIABLES ####################
        #region

        /// <summary>
        /// A shorter way of writing Environment.NewLine (it gets used repeatedly).
        /// </summary>
        private static readonly string NL = Environment.NewLine;

        #endregion

        //#################### TEST METHODS ####################
        #region

        [Fact]
        public void GetAllTest()
        {
            var input = new string[]
            {
                "Said once a young coder from Crewe,",
                "'I like to write tests, so I do!",
                "They help me confirm",
                "That I don't need to squirm -",
                "My code might look nice, but works too!'"
            };

            var text = new Text(input);

            Assert.Equal(string.Join(NL, input) + NL, text.GetAll());
        }

        [Fact]
        public void GetPortionTest()
        {
            var input = new string[]
            {
                "There once was a jolly young tester",
                "Who couldn't leave software to fester -",
                "He'd prod and he'd poke",
                "Until something bad broke,",
                "And then he'd find someone to pester."
            };

            var text = new Text(input);

            // A single-line range (to test the special case).
            Assert.Equal("jolly" + NL, text.GetPortion(0, 17, 0, 22));

            // A two-line range.
            Assert.Equal("prod and he'd poke" + NL + "Until" + NL, text.GetPortion(2, 5, 3, 5));

            // A three-line range (to test that the middle line is included in full).
            Assert.Equal("poke" + NL + "Until something bad broke," + NL + "And then" + NL, text.GetPortion(2, 19, 4, 8));

            // An invalid but recoverable range (to test that a best effort is made rather than crashing).
            Assert.Equal(NL + "Who couldn't leave software to fester -" + NL, text.GetPortion(0, int.MaxValue, 1, int.MaxValue));

            // Some quite definitely dodgy ranges (to test that exceptions are thrown).
            Assert.Throws<Exception>(() => text.GetPortion(-1, 0, 0, 0));
            Assert.Throws<Exception>(() => text.GetPortion(0, -1, 0, 0));
            Assert.Throws<Exception>(() => text.GetPortion(0, 0, -1, 0));
            Assert.Throws<Exception>(() => text.GetPortion(0, 0, 0, -1));
            Assert.Throws<Exception>(() => text.GetPortion(3, 5, 2, 5));
            Assert.Throws<Exception>(() => text.GetPortion(2, 5, int.MaxValue, 5));
        }

        #endregion
    }
}
