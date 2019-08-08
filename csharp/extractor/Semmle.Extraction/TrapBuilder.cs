using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace Semmle.Extraction
{
    public static class TrapBuilderExtensions
    {
        /// <summary>
        /// Appends a [comma] separated list to a trap builder.
        /// </summary>
        /// <typeparam name="T">The type of the list.</typeparam>
        /// <param name="tb">The trap builder to append to.</param>
        /// <param name="separator">The separator string (e.g. ",")</param>
        /// <param name="items">The list of items.</param>
        /// <returns>The original trap builder (fluent interface).</returns>
        public static TextWriter AppendList<T>(this TextWriter tb, string separator, IEnumerable<T> items) where T:IEntity
        {
            return tb.BuildList(separator, items, (x, tb0) => { tb0.WriteSubId(x); });
        }

        /// <summary>
        /// Builds a trap builder using a separator and an action for each item in the list.
        /// </summary>
        /// <typeparam name="T">The type of the items.</typeparam>
        /// <param name="tb">The trap builder to append to.</param>
        /// <param name="separator">The separator string (e.g. ",")</param>
        /// <param name="items">The list of items.</param>
        /// <param name="action">The action on each item.</param>
        /// <returns>The original trap builder (fluent interface).</returns>
        public static TextWriter BuildList<T>(this TextWriter tb, string separator, IEnumerable<T> items, Action<T, TextWriter> action)
        {
            bool first = true;
            foreach (var item in items)
            {
                if (first) first = false; else tb.Write(separator);
                action(item, tb);
            }
            return tb;
        }
    }
}
