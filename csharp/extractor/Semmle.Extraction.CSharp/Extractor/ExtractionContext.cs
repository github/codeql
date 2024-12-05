using System.Collections.Generic;
using System.Threading;
using Semmle.Util.Logging;
using CompilationInfo = (string key, string value);

namespace Semmle.Extraction.CSharp
{
    /// <summary>
    /// Implementation of the main extractor state.
    /// </summary>
    public class ExtractionContext
    {
        public string Cwd { get; init; }
        public string[] Args { get; init; }
        public ExtractorMode Mode { get; }
        public string OutputPath { get; }
        public IEnumerable<CompilationInfo> CompilationInfos { get; }

        /// <summary>
        /// Creates a new extractor instance for one compilation unit.
        /// </summary>
        public ExtractionContext(string cwd, string[] args, string outputPath, IEnumerable<CompilationInfo> compilationInfos, ILogger logger, PathTransformer pathTransformer, ExtractorMode mode, bool isQlTest)
        {
            OutputPath = outputPath;
            Logger = logger;
            PathTransformer = pathTransformer;
            CompilationInfos = compilationInfos;
            Cwd = cwd;
            Args = args;

            Mode = mode;
            if (isQlTest)
            {
                Mode |= ExtractorMode.QlTest;
            }
        }

        // Limit the number of error messages in the log file
        // to handle pathological cases.
        private const int maxErrors = 1000;

        private readonly Lock mutex = new();

        public void Message(Message msg)
        {
            lock (mutex)
            {

                if (msg.Severity == Severity.Error)
                {
                    ++Errors;
                    if (Errors == maxErrors)
                    {
                        Logger.LogInfo($"  Stopping logging after {Errors} errors");
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
        private readonly Dictionary<string, string> referenceFilenames = [];

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

        public PathTransformer PathTransformer { get; }
    }
}
