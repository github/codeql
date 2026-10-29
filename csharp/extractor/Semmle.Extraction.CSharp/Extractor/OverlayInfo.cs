using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.Json;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp
{
    public interface IOverlayInfo
    {
        /// <summary>
        /// True, if the extractor is running in overlay mode.
        /// </summary>
        bool IsOverlayMode { get; }

        /// <summary>
        /// Returns true, if the given file is not in the set of changed files.
        /// </summary>
        /// <param name="filePath">A source file path</param>
        bool OnlyMakeScaffold(string filePath);
    }


    /// <summary>
    /// An instance of this class is used when overlay is not enabled.
    /// </summary>
    public class TrivialOverlayInfo : IOverlayInfo
    {
        public TrivialOverlayInfo() { }

        public bool IsOverlayMode { get; } = false;

        public bool OnlyMakeScaffold(string filePath) => false;
    }

    /// <summary>
    /// An instance of this class is used for detecting
    /// (1) Whether overlay is enabled.
    /// (2) Fetch the changed files that should be fully extracted as a part
    /// of the overlay extraction.
    /// </summary>
    public class OverlayInfo : IOverlayInfo
    {
        private readonly ILogger logger;
        private readonly HashSet<string> changedFiles;
        private readonly string srcDir;

        public OverlayInfo(ILogger logger, string srcDir, string json)
        {
            this.logger = logger;
            this.srcDir = srcDir;
            changedFiles = ParseJson(json);
        }

        public bool IsOverlayMode { get; } = true;

        public bool OnlyMakeScaffold(string filePath) => !changedFiles.Contains(filePath);

        /// <summary>
        /// Private type only used to parse overlay changes JSON files.
        /// 
        /// The content of such a file has the format
        /// {
        ///  "changes": [
        ///    "app/controllers/about_controller.xyz",
        ///    "app/models/about.xyz"
        ///  ]
        /// }
        /// </summary>
        private record ChangedFiles
        {
            public string[]? Changes { get; set; }
        }

        private HashSet<string> ParseJson(string json)
        {
            try
            {
                var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
                var obj = JsonSerializer.Deserialize<ChangedFiles>(json, options);
                return obj?.Changes is string[] changes
                    ? changes.Select(change => Path.Join(srcDir, change)).ToHashSet()
                    : [];
            }
            catch (JsonException)
            {
                logger.LogError("Overlay: Unable to parse the JSON content from the overlay changes file.");
                return [];
            }
        }
    }

    public static class OverlayInfoFactory
    {
        /// <summary>
        /// The returned object is used to decide, whether
        /// (1) The extractor is running in overlay mode.
        /// (2) Which files to only extract scaffolds for (unchanged files)
        /// </summary>
        /// <param name="logger">A logger</param>
        /// <param name="srcDir">The (overlay) source directory</param>
        /// <returns>An overlay information object.</returns>
        public static IOverlayInfo Make(ILogger logger, string srcDir)
        {
            if (EnvironmentVariables.GetOverlayChangesFilePath() is string path)
            {
                logger.LogInfo($"Overlay: Reading overlay changes from file '{path}'.");
                try
                {
                    var json = File.ReadAllText(path);
                    return new OverlayInfo(logger, srcDir, json);
                }
                catch
                {
                    logger.LogError("Overlay: Unexpected error while reading the overlay changes file.");
                }
            }

            logger.LogInfo("Overlay: Overlay mode not enabled.");
            return new TrivialOverlayInfo();
        }
    }
}
