using System.Collections.Generic;
using System.Linq;

namespace Semmle.Autobuild.Shared
{
    /// <summary>
    /// A BAT file used to initialise the appropriate
    /// Visual Studio version/platform.
    /// </summary>
    public class VcVarsBatFile
    {
        public int ToolsVersion { get; }
        public string Path { get; }

        public VcVarsBatFile(string path, int version)
        {
            Path = path;
            ToolsVersion = version;
        }
    };

    /// <summary>
    /// Collection of available Visual Studio build tools.
    /// </summary>
    public static class BuildTools
    {
        public static IEnumerable<VcVarsBatFile> GetCandidateVcVarsFiles(IBuildActions actions)
        {
            var programFilesx86 = actions.GetEnvironmentVariable("ProgramFiles(x86)");
            if (programFilesx86 == null)
                yield break;

            // Attempt to use vswhere to find installations of Visual Studio
            var vswhere = actions.PathCombine(programFilesx86, "Microsoft Visual Studio", "Installer", "vswhere.exe");

            if (actions.FileExists(vswhere))
            {
                var exitCode1 = actions.RunProcess(vswhere, "-prerelease -legacy -property installationPath", null, null, out var installationList);
                var exitCode2 = actions.RunProcess(vswhere, "-prerelease -legacy -property installationVersion", null, null, out var versionList);

                if (exitCode1 == 0 && exitCode2 == 0 && versionList.Count == installationList.Count)
                {
                    // vswhere ran successfully and produced the expected output
                    foreach (var vsInstallation in versionList.Zip(installationList, (v, i) => (Version: v, InstallationPath: i)))
                    {
                        var dot = vsInstallation.Version.IndexOf('.');
                        var majorVersionString = dot == -1 ? vsInstallation.Version : vsInstallation.Version.Substring(0, dot);
                        if (int.TryParse(majorVersionString, out var majorVersion))
                        {
                            if (majorVersion < 15)
                            {
                                // Visual Studio 2015 and below
                                yield return new VcVarsBatFile(actions.PathCombine(vsInstallation.InstallationPath, @"VC\vcvarsall.bat"), majorVersion);
                            }
                            else
                            {
                                // Visual Studio 2017 and above
                                yield return new VcVarsBatFile(actions.PathCombine(vsInstallation.InstallationPath, @"VC\Auxiliary\Build\vcvars32.bat"), majorVersion);
                                yield return new VcVarsBatFile(actions.PathCombine(vsInstallation.InstallationPath, @"VC\Auxiliary\Build\vcvars64.bat"), majorVersion);
                                yield return new VcVarsBatFile(actions.PathCombine(vsInstallation.InstallationPath, @"Common7\Tools\VsDevCmd.bat"), majorVersion);
                            }
                        }
                        // else: Skip installation without a version
                    }
                    yield break;
                }
            }

            // vswhere not installed or didn't run correctly - return legacy Visual Studio versions
            yield return new VcVarsBatFile(actions.PathCombine(programFilesx86, @"Microsoft Visual Studio 14.0\VC\vcvarsall.bat"), 14);
            yield return new VcVarsBatFile(actions.PathCombine(programFilesx86, @"Microsoft Visual Studio 12.0\VC\vcvarsall.bat"), 12);
            yield return new VcVarsBatFile(actions.PathCombine(programFilesx86, @"Microsoft Visual Studio 11.0\VC\vcvarsall.bat"), 11);
            yield return new VcVarsBatFile(actions.PathCombine(programFilesx86, @"Microsoft Visual Studio 10.0\VC\vcvarsall.bat"), 10);
        }

        /// <summary>
        /// Enumerates all available tools.
        /// </summary>
        public static IEnumerable<VcVarsBatFile> VcVarsAllBatFiles(IBuildActions actions) =>
            GetCandidateVcVarsFiles(actions).Where(v => actions.FileExists(v.Path));

        /// <summary>
        /// Finds a VcVars file that provides a compatible environment for the given solution.
        /// </summary>
        /// <param name="sln">The solution file.</param>
        /// <returns>A compatible file, or throws an exception.</returns>
        public static VcVarsBatFile FindCompatibleVcVars(IBuildActions actions, ISolution sln) =>
             FindCompatibleVcVars(actions, sln.ToolsVersion.Major);

        /// <summary>
        /// Finds a VcVars that provides a compatible environment for the given tools version.
        /// </summary>
        /// <param name="targetVersion">The tools version.</param>
        /// <returns>A compatible file, or null.</returns>
        public static VcVarsBatFile FindCompatibleVcVars(IBuildActions actions, int targetVersion) =>
            targetVersion < 10 ?
                VcVarsAllBatFiles(actions).OrderByDescending(b => b.ToolsVersion).FirstOrDefault() :
                VcVarsAllBatFiles(actions).Where(b => b.ToolsVersion >= targetVersion).OrderBy(b => b.ToolsVersion).FirstOrDefault();
    }
}
