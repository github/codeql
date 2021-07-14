using Xunit;
using Assert = Xunit.Assert;
using Semmle.Util;

namespace SemmleTests.Semmle.Util
{

    public class ActionMapTests
    {
        [Fact]
        public void TestAddthenOnAdd()
        {
            var am = new ActionMap<int, int>();
            am.Add(1, 2);
            int value = 0;
            am.OnAdd(1, x => value = x);
            Assert.Equal(2, value);
        }

        [Fact]
        public void TestOnAddthenAdd()
        {
            var am = new ActionMap<int, int>();
            int value = 0;
            am.OnAdd(1, x => value = x);
            am.Add(1, 2);
            Assert.Equal(2, value);
        }

        [Fact]
        public void TestNotAdded()
        {
            var am = new ActionMap<int, int>();
            int value = 0;
            am.OnAdd(1, x => value = x);
            am.Add(2, 2);
            Assert.Equal(0, value);
        }

        [Fact]
        public void TestMultipleActions()
        {
            var am = new ActionMap<int, int>();
            int value1 = 0, value2 = 0;
            am.OnAdd(1, x => value1 = x);
            am.OnAdd(1, x => value2 = x);
            am.Add(1, 2);
            Assert.Equal(2, value1);
            Assert.Equal(2, value2);
        }

    }
}
