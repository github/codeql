using System;
using System.Collections.Generic;
using System.Text;

namespace Semmle.Extraction
{
    /// <summary>
    /// A trap builder.
    ///
    /// A trap builder is used to construct a string that is to be
    /// persisted in a trap file (similar to how a <see cref="StringBuilder"/>
    /// can be used to construct a string).
    /// </summary>
    public interface ITrapBuilder
    {
        /// <summary>
        /// Append the given object to this trap builder.
        /// </summary>
        ITrapBuilder Append(object arg);

        /// <summary>
        /// Append the given string to this trap builder.
        /// </summary>
        ITrapBuilder Append(string arg);

        /// <summary>
        /// Append a newline to this trap builder.
        /// </summary>
        ITrapBuilder AppendLine();
    }

    public static class ITrapBuilderExtensions
    {
        /// <summary>
        /// Appends a [comma] separated list to a trap builder.
        /// </summary>
        /// <typeparam name="T">The type of the list.</typeparam>
        /// <param name="tb">The trap builder to append to.</param>
        /// <param name="separator">The separator string (e.g. ",")</param>
        /// <param name="items">The list of items.</param>
        /// <returns>The original trap builder (fluent interface).</returns>
        public static ITrapBuilder AppendList<T>(this ITrapBuilder tb, string separator, IEnumerable<T> items)
        {
            return tb.BuildList(separator, items, (x, tb0) => { tb0.Append(x); });
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
        public static ITrapBuilder BuildList<T>(this ITrapBuilder tb, string separator, IEnumerable<T> items, Action<T, ITrapBuilder> action)
        {
            bool first = true;
            foreach (var item in items)
            {
                if (first) first = false; else tb.Append(separator);
                action(item, tb);
            }
            return tb;
        }
    }

    /// <summary>
    /// A <see cref="StringBuilder"/> implementation of <see cref="ITrapBuilder"/>,
    /// used for debugging only.
    /// </summary>
    public class TrapStringBuilder : ITrapBuilder
    {
        readonly StringBuilder StringBuilder = new StringBuilder();

        public ITrapBuilder Append(object arg)
        {
            StringBuilder.Append(arg);
            return this;
        }

        public ITrapBuilder Append(string arg)
        {
            StringBuilder.Append(arg);
            return this;
        }

        public ITrapBuilder AppendLine()
        {
            StringBuilder.AppendLine();
            return this;
        }

        public override string ToString() => StringBuilder.ToString();
    }
}
