using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Semmle.Autobuild.Shared
{
    public static class MarkdownUtil
    {
        /// <summary>
        /// Formats items as markdown inline code.
        /// </summary>
        /// <returns>A function which formats items as markdown inline code.</returns>
        public static readonly Func<string, string> CodeFormatter = item => $"`{item}`";

        /// <summary>
        /// Formats the string as a markdown link.
        /// </summary>
        /// <param name="link">The URL for the link.</param>
        /// <param name="title">The text that is displayed.</param>
        /// <returns>A string containing a markdown-formatted link.</returns>
        public static string ToMarkdownLink(this string link, string title) => $"[{title}]({link})";

        /// <summary>
        /// Renders <paramref name="projects"/> as a markdown list of the project paths.
        /// </summary>
        /// <param name="projects">
        /// The list of projects whose paths should be rendered as a markdown list.
        /// </param>
        /// <param name="limit">The maximum number of items to include in the list.</param>
        /// <returns>Returns the markdown list as a string.</returns>
        public static string ToMarkdownList(this IEnumerable<IProjectOrSolution> projects, int? limit = null)
        {
            return projects.ToMarkdownList(p => $"`{p.FullPath}`", limit);
        }

        /// <summary>
        /// Renders <paramref name="items" /> as a markdown list.
        /// </summary>
        /// <typeparam name="T">The item type.</typeparam>
        /// <param name="items">The list that should be formatted as a markdown list.</param>
        /// <param name="formatter">A function which converts individual items into a string representation.</param>
        /// <param name="limit">The maximum number of items to include in the list.</param>
        /// <returns>Returns the markdown list as a string.</returns>
        public static string ToMarkdownList<T>(this IEnumerable<T> items, Func<T, string> formatter, int? limit = null)
        {
            var sb = new StringBuilder();

            // if there is a limit, take at most that many items from the  start of the list
            var list = limit is not null ? items.Take(limit.Value) : items;
            sb.Append(string.Join('\n', list.Select(item => $"- {formatter(item)}")));

            // if there were more items than allowed in the list, add an extra item indicating
            // how many more items there were
            var length = items.Count();

            if (limit is not null && length > limit)
            {
                sb.Append($"\n- and {length - limit} more. View the CodeQL logs for a full list.");
            }

            return sb.ToString();
        }
    }
}
