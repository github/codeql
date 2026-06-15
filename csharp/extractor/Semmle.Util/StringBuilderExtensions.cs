using System;
using System.Collections.Generic;
using System.Text;

namespace Semmle.Util
{
    public static class StringBuilderExtensions
    {
        /// <summary>
        /// Appends a [comma] separated list to a StringBuilder.
        /// </summary>
        /// <typeparam name="T">The type of the list.</typeparam>
        /// <param name="builder">The StringBuilder to append to.</param>
        /// <param name="separator">The separator string (e.g. ",")</param>
        /// <param name="items">The list of items.</param>
        /// <returns>The original StringBuilder (fluent interface).</returns>
        public static StringBuilder AppendList<T>(this StringBuilder builder, string separator, IEnumerable<T> items)
        {
            return builder.BuildList(separator, items, (x, sb) => { sb.Append(x); });
        }

        /// <summary>
        /// Builds a string using a separator and an action for each item in the list.
        /// </summary>
        /// <typeparam name="T">The type of the items.</typeparam>
        /// <param name="builder">The string builder.</param>
        /// <param name="separator">The separator string (e.g. ", ")</param>
        /// <param name="items">The list of items.</param>
        /// <param name="action">The action on each item.</param>
        /// <returns>The original StringBuilder (fluent interface).</returns>
        public static StringBuilder BuildList<T>(this StringBuilder builder, string separator, IEnumerable<T> items, Action<T, StringBuilder> action)
        {
            var first = true;
            foreach (var item in items)
            {
                if (first)
                    first = false;
                else
                    builder.Append(separator);

                action(item, builder);
            }
            return builder;
        }

    }
}
