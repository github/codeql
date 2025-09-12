using System;
using System.Collections.Generic;
using System.IO;
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

        public OverlayInfo(ILogger logger, string json)
        {
            this.logger = logger;
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
        public record ChangedFiles
        {
            public string[]? Changes { get; set; }
        }

        private HashSet<string> ParseJson(string json)
        {
            try
            {
                var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
                var changedFiles = JsonSerializer.Deserialize<ChangedFiles>(json, options);
                return changedFiles?.Changes is string[] changes
                    ? new HashSet<string>(changes)
                    : [];
            }
            catch (JsonException)
            {
                logger.LogError("Overlay: Unable to parse the JSON content from the overlay changes file");
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
        /// <param name="mode">The extraction mode</param>
        /// <param name="logger">A logger</param>
        /// <returns>An overlay information object.</returns>
        public static IOverlayInfo Make(ILogger logger)
        {
            if (EnvironmentVariables.GetOverlayChangesFilePath() is string path)
            {
                try
                {
                    var json = File.ReadAllText(path);
                    return new OverlayInfo(logger, json);
                }
                catch
                {
                    logger.LogError("Overlay: Unexpected error while reading the overlay changes file.");
                }

            }

            return new TrivialOverlayInfo();
        }
    }
}
