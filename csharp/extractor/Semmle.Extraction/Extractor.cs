using System;
using System.Collections.Generic;
using Microsoft.CodeAnalysis;
using Semmle.Util.Logging;

namespace Semmle.Extraction
{
    /// <summary>
    /// Provides common extraction functions for use during extraction.
    /// </summary>
    ///
    /// <remarks>
    /// This is held in the <see cref="Context"/> passed to each entity.
    /// </remarks>
    public interface IExtractor
    {
        /// <summary>
        /// Logs a message (to csharp.log).
        /// Increases the error count if msg.severity is Error.
        /// </summary>
        /// <param name="msg">The message to log.</param>
        void Message(Message msg);

        /// <summary>
        /// Cache assembly names.
        /// </summary>
        /// <param name="assembly">The assembly name.</param>
        /// <param name="file">The file defining the assembly.</param>
        void SetAssemblyFile(string assembly, string file);

        /// <summary>
        /// Maps assembly names to file names.
        /// </summary>
        /// <param name="assembly">The assembly name</param>
        /// <returns>The file defining the assmebly.</returns>
        string GetAssemblyFile(string assembly);

        /// <summary>
        /// How many errors encountered during extraction?
        /// </summary>
        int Errors { get; }

        /// <summary>
        /// The extraction is standalone - meaning there will be a lot of errors.
        /// </summary>
        bool Standalone { get; }

        /// <summary>
        /// Record a new error type.
        /// </summary>
        /// <param name="fqn">The display name of the type, qualified where possible.</param>
        /// <param name="fromSource">If the missing type was referenced from a source file.</param>
        void MissingType(string fqn, bool fromSource);

        /// <summary>
        /// Record an unresolved `using namespace` directive.
        /// </summary>
        /// <param name="fqn">The full name of the namespace.</param>
        /// <param name="fromSource">If the missing namespace was referenced from a source file.</param>
        void MissingNamespace(string fqn, bool fromSource);

        /// <summary>
        /// The list of missing types.
        /// </summary>
        IEnumerable<string> MissingTypes { get; }

        /// <summary>
        /// The list of missing namespaces.
        /// </summary>
        IEnumerable<string> MissingNamespaces { get; }

        /// <summary>
        /// The full path of the generated DLL/EXE.
        /// null if not specified.
        /// </summary>
        string OutputPath { get; }

        /// <summary>
        /// The object used for logging.
        /// </summary>
        ILogger Logger { get; }

        /// <summary>
        /// The path transformer to apply.
        /// </summary>
        PathTransformer PathTransformer { get; }

        /// <summary>
        /// Creates a new context.
        /// </summary>
        /// <param name="c">The C# compilation.</param>
        /// <param name="trapWriter">The trap writer.</param>
        /// <param name="scope">The extraction scope (what to include in this trap file).</param>
        /// <param name="addAssemblyTrapPrefix">Whether to add assembly prefixes to TRAP labels.</param>
        /// <returns></returns>
        Context CreateContext(Compilation c, TrapWriter trapWriter, IExtractionScope scope, bool addAssemblyTrapPrefix);
    }

    /// <summary>
    /// Implementation of the main extractor state.
    /// </summary>
    public class Extractor : IExtractor
    {
        public bool Standalone
        {
            get; private set;
        }

        /// <summary>
        /// Creates a new extractor instance for one compilation unit.
        /// </summary>
        /// <param name="standalone">If the extraction is standalone.</param>
        /// <param name="outputPath">The name of the output DLL/EXE, or null if not specified (standalone extraction).</param>
        /// <param name="logger">The object used for logging.</param>
        /// <param name="pathTransformer">The object used for path transformations.</param>
        public Extractor(bool standalone, string outputPath, ILogger logger, PathTransformer pathTransformer)
        {
            Standalone = standalone;
            OutputPath = outputPath;
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

        public Context CreateContext(Compilation c, TrapWriter trapWriter, IExtractionScope scope, bool addAssemblyTrapPrefix)
        {
            return new Context(this, c, trapWriter, scope, addAssemblyTrapPrefix);
        }

        public IEnumerable<string> MissingTypes => missingTypes;

        public IEnumerable<string> MissingNamespaces => missingNamespaces;

        public string OutputPath
        {
            get;
            private set;
        }

        public ILogger Logger { get; private set; }

        public static string Version => $"{ThisAssembly.Git.BaseTag} ({ThisAssembly.Git.Sha})";

        public PathTransformer PathTransformer { get; }
    }
}
