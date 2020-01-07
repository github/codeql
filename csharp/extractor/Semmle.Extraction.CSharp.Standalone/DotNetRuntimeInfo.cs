using System;
using System.Collections.Concurrent;
using System.Diagnostics;

namespace RoslynWS
{
    /// <summary>
    ///     Information about the .NET Core runtime.
    /// </summary>
    public class DotNetRuntimeInfo
    {
        /// <summary>
        ///     A cache of .NET runtime information by target directory.
        /// </summary>
        static readonly ConcurrentDictionary<string, DotNetRuntimeInfo> _cache = new ConcurrentDictionary<string, DotNetRuntimeInfo>();

        /// <summary>
        ///     The .NET Core version.
        /// </summary>
        public string Version { get; set; }

        /// <summary>
        ///     The .NET Core base directory.
        /// </summary>
        public string BaseDirectory { get; set; }

        /// <summary>
        ///     The current runtime identifier (RID).
        /// </summary>
        public string RID { get; set; }

        /// <summary>
        ///     Get information about the current .NET Core runtime.
        /// </summary>
        /// <param name="baseDirectory">
        ///     An optional base directory where dotnet.exe should be run (this may affect the version it reports due to global.json).
        /// </param>
        /// <returns>
        ///     A <see cref="DotNetRuntimeInfo"/> containing the runtime information.
        /// </returns>
        public static DotNetRuntimeInfo GetCurrent(string baseDirectory = null)
        {
            return _cache.GetOrAdd(baseDirectory, _ =>
            {
                DotNetRuntimeInfo runtimeInfo = new DotNetRuntimeInfo();

                Process dotnetInfoProcess = Process.Start(new ProcessStartInfo
                {
                    FileName = "dotnet",
                    WorkingDirectory = baseDirectory,
                    Arguments = "--info",
                    UseShellExecute = false,
                    RedirectStandardOutput = true
                });
                using (dotnetInfoProcess)
                {
                    dotnetInfoProcess.WaitForExit();

                    string currentSection = null;
                    string currentLine;
                    while ((currentLine = dotnetInfoProcess.StandardOutput.ReadLine()) != null)
                    {
                        if (String.IsNullOrWhiteSpace(currentLine))
                            continue;

                        if (!currentLine.StartsWith(" "))
                        {
                            currentSection = currentLine;

                            continue;
                        }

                        string[] property = currentLine.Split(new char[] { ':' }, count: 2);
                        if (property.Length != 2)
                            continue;

                        property[0] = property[0].Trim();
                        property[1] = property[1].Trim();

                        switch (currentSection)
                        {
                            case "Product Information:":
                                {
                                    switch (property[0])
                                    {
                                        case "Version":
                                            {
                                                runtimeInfo.Version = property[1];

                                                break;
                                            }
                                    }

                                    break;
                                }
                            case "Runtime Environment:":
                                {
                                    switch (property[0])
                                    {
                                        case "Base Path":
                                            {
                                                runtimeInfo.BaseDirectory = property[1];

                                                break;
                                            }
                                        case "RID":
                                            {
                                                runtimeInfo.RID = property[1];

                                                break;
                                            }
                                    }

                                    break;
                                }
                        }
                    }
                }

                return runtimeInfo;
            });
        }

        /// <summary>
        ///     Clear the cache of .NET runtime information.
        /// </summary>
        public static void ClearCache()
        {
            _cache.Clear();
        }
    }
}