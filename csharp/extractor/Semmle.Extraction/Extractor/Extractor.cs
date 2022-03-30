using System.Collections.Generic;
using Semmle.Util.Logging;

namespace Semmle.Extraction
{
    /// <summary>
    /// Implementation of the main extractor state.
    /// </summary>
    public abstract class Extractor
    {
        public abstract ExtractorMode Mode { get; }

        /// <summary>
        /// Creates a new extractor instance for one compilation unit.
        /// </summary>
        /// <param name="logger">The object used for logging.</param>
        /// <param name="pathTransformer">The object used for path transformations.</param>
        protected Extractor(ILogger logger, PathTransformer pathTransformer)
        {
            Logger = logger;
            PathTransformer = pathTransformer;
        }

        // Limit the number of error messages in the log file
        // to handle pathological cases.
        private const int maxErrors = 1000;

        private readonly object mutex = new object();

        public void Message(Message msg)
        {
            lock (mutex)
            {

                if (msg.Severity == Severity.Error)
                {
                    ++Errors;
                    if (Errors == maxErrors)
                    {
                        Logger.Log(Severity.Info, "  Stopping logging after {0} errors", Errors);
                    }
                }

                if (Errors >= maxErrors)
                {
                    return;
                }

                Logger.Log(msg.Severity, $"  {msg.ToLogString()}");
            }
        }

        // Roslyn framework has no apparent mechanism to associate assemblies with their files.
        // So this lookup table needs to be populated.
        private readonly Dictionary<string, string> referenceFilenames = new Dictionary<string, string>();

        public void SetAssemblyFile(string assembly, string file)
        {
            referenceFilenames[assembly] = file;
        }

        public string GetAssemblyFile(string assembly)
        {
            return referenceFilenames[assembly];
        }

        public int Errors
        {
            get; private set;
        }

        private readonly ISet<string> missingTypes = new SortedSet<string>();
        private readonly ISet<string> missingNamespaces = new SortedSet<string>();

        public void MissingType(string fqn, bool fromSource)
        {
            if (fromSource)
            {
                lock (mutex)
                    missingTypes.Add(fqn);
            }
        }

        public void MissingNamespace(string fqdn, bool fromSource)
        {
            if (fromSource)
            {
                lock (mutex)
                    missingNamespaces.Add(fqdn);
            }
        }

        public IEnumerable<string> MissingTypes => missingTypes;

        public IEnumerable<string> MissingNamespaces => missingNamespaces;

        public ILogger Logger { get; private set; }

        public static string Version => $"{ThisAssembly.Git.BaseTag} ({ThisAssembly.Git.Sha})";

        public PathTransformer PathTransformer { get; }
    }
}
