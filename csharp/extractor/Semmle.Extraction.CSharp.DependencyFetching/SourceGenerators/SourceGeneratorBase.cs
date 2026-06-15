using System.Collections.Generic;
using System.IO;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal abstract class SourceGeneratorBase : ISourceGenerator
    {
        protected readonly ILogger logger;
        protected readonly TemporaryDirectory tempWorkingDirectory;

        public SourceGeneratorBase(ILogger logger, TemporaryDirectory tempWorkingDirectory)
        {
            this.logger = logger;
            this.tempWorkingDirectory = tempWorkingDirectory;
        }

        public IEnumerable<string> Generate()
        {
            if (!IsEnabled())
            {
                return [];
            }

            return Run();
        }

        protected abstract IEnumerable<string> Run();
        protected abstract bool IsEnabled();

        /// <summary>
        /// Creates a temporary directory with the given subfolder name.
        /// The created directory might be inside the repo folder, and it is deleted when the temporary working directory is disposed.
        /// </summary>
        protected string GetTemporaryWorkingDirectory(string subfolder)
        {
            var temp = Path.Combine(tempWorkingDirectory.ToString(), subfolder);
            Directory.CreateDirectory(temp);

            return temp;
        }
    }
}
