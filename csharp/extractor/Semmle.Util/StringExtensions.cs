using System.Collections.Generic;
using System.Linq;

namespace Semmle.Util
{
    public static class StringExtensions
    {
        public static (string, string) Split(this string self, int index0)
        {
            var split = self.Split(new[] { index0 });
            return (split[0], split[1]);
        }

        public static (string, string, string) Split(this string self, int index0, int index1)
        {
            var split = self.Split(new[] { index0, index1 });
            return (split[0], split[1], split[2]);
        }

        public static (string, string, string, string) Split(this string self, int index0, int index1, int index2)
        {
            var split = self.Split(new[] { index0, index1, index2 });
            return (split[0], split[1], split[2], split[4]);
        }

        private static List<string> Split(this string self, params int[] indices)
        {
            var ret = new List<string>();
            var previousIndex = 0;
            foreach (var index in indices.OrderBy(i => i))
            {
                ret.Add(self.Substring(previousIndex, index - previousIndex));
                previousIndex = index;
            }

            ret.Add(self.Substring(previousIndex));

            return ret;
        }
    }
}
