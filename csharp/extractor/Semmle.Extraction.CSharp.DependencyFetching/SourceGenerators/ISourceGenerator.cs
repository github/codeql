using System.Collections.Generic;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    public interface ISourceGenerator
    {
        /// <summary>
        /// Returns the paths to the generated source files.
        /// </summary>
        IEnumerable<string> Generate();
    }
}
