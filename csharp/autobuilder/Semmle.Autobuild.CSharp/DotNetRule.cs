using System;
using Semmle.Util.Logging;
using System.Linq;
using Newtonsoft.Json.Linq;
using System.Collections.Generic;
using System.IO;
using Semmle.Util;
using System.Text.RegularExpressions;
using Semmle.Autobuild.Shared;

namespace Semmle.Autobuild.CSharp
{
    /// <summary>
    /// A build rule where the build command is of the form "dotnet build".
    /// Currently unused because the tracer does not work with dotnet.
    /// </summary>
    internal class DotNetRule : IBuildRule
    {
        public BuildScript Analyse(Autobuilder builder, bool auto)
        {
            if (!builder.ProjectsOrSolutionsToBuild.Any())
                return BuildScript.Failure;

            if (auto)
            {
                var notDotNetProject = builder.ProjectsOrSolutionsToBuild
                    .SelectMany(p => Enumerators.Singleton(p).Concat(p.IncludedProjects))
                    .OfType<Project>()
                    .FirstOrDefault(p => !p.DotNetProject);
                if (notDotNetProject != null)
                {
                    builder.Log(Severity.Info, "Not using .NET Core because of incompatible project {0}", notDotNetProject);
                    return BuildScript.Failure;
                }

                builder.Log(Severity.Info, "Attempting to build using .NET Core");
            }

            return WithDotNet(builder, (dotNetPath, environment, compatibleClr) =>
                {
                    var ret = GetInfoCommand(builder.Actions, dotNetPath, environment);
                    foreach (var projectOrSolution in builder.ProjectsOrSolutionsToBuild)
                    {
                        var cleanCommand = GetCleanCommand(builder.Actions, dotNetPath, environment);
                        cleanCommand.QuoteArgument(projectOrSolution.FullPath);
                        var clean = cleanCommand.Script;

                        var restoreCommand = GetRestoreCommand(builder.Actions, dotNetPath, environment);
                        restoreCommand.QuoteArgument(projectOrSolution.FullPath);
                        var restore = restoreCommand.Script;

                        var build = GetBuildScript(builder, dotNetPath, environment, compatibleClr, projectOrSolution.FullPath);

                        ret &= BuildScript.Try(clean) & BuildScript.Try(restore) & build;
                    }
                    return ret;
                });
        }

        private static BuildScript WithDotNet(Autobuilder builder, Func<string?, IDictionary<string, string>?, bool, BuildScript> f)
        {
            var installDir = builder.Actions.PathCombine(builder.Options.RootDirectory, ".dotnet");
            var installScript = DownloadDotNet(builder, installDir);
            return BuildScript.Bind(installScript, installed =>
            {
                Dictionary<string, string>? env;
                if (installed == 0)
                {
                    // The installation succeeded, so use the newly installed .NET Core
                    var path = builder.Actions.GetEnvironmentVariable("PATH");
                    var delim = builder.Actions.IsWindows() ? ";" : ":";
                    env = new Dictionary<string, string>{
                            { "DOTNET_MULTILEVEL_LOOKUP", "false" }, // prevent look up of other .NET Core SDKs
                            { "DOTNET_SKIP_FIRST_TIME_EXPERIENCE", "true" },
                            { "PATH", installDir + delim + path }
                        };
                }
                else
                {
                    installDir = null;
                    env = null;
                }

                // The CLR tracer is always compatible on Windows
                if (builder.Actions.IsWindows())
                    return f(installDir, env, true);

                // The CLR tracer is only compatible on .NET Core >= 3 on Linux and macOS (see
                // https://github.com/dotnet/coreclr/issues/19622)
                return BuildScript.Bind(GetInstalledRuntimesScript(builder.Actions, installDir, env), (runtimes, runtimesRet) =>
                {
                    var compatibleClr = false;
                    if (runtimesRet == 0)
                    {
                        var minimumVersion = new Version(3, 0);
                        var regex = new Regex(@"Microsoft\.NETCore\.App (\d\.\d\.\d)");
                        compatibleClr = runtimes
                            .Select(runtime => regex.Match(runtime))
                            .Where(m => m.Success)
                            .Select(m => m.Groups[1].Value)
                            .Any(m => Version.TryParse(m, out var v) && v >= minimumVersion);
                    }

                    if (!compatibleClr)
                    {
                        if (env == null)
                            env = new Dictionary<string, string>();
                        env.Add("UseSharedCompilation", "false");
                    }

                    return f(installDir, env, compatibleClr);
                });
            });
        }

        /// <summary>
        /// Returns a script that attempts to download relevant version(s) of the
        /// .NET Core SDK, followed by running the script generated by <paramref name="f"/>.
        ///
        /// The argument to <paramref name="f"/> is any additional required environment
        /// variables needed by the installed .NET Core (<code>null</code> when no variables
        /// are needed).
        /// </summary>
        public static BuildScript WithDotNet(Autobuilder builder, Func<IDictionary<string, string>?, BuildScript> f)
            => WithDotNet(builder, (_1, env, _2) => f(env));

        /// <summary>
        /// Returns a script for downloading relevant versions of the
        /// .NET Core SDK. The SDK(s) will be installed at <code>installDir</code>
        /// (provided that the script succeeds).
        /// </summary>
        private static BuildScript DownloadDotNet(Autobuilder builder, string installDir)
        {
            if (!string.IsNullOrEmpty(builder.Options.DotNetVersion))
                // Specific version supplied in configuration: always use that
                return DownloadDotNetVersion(builder, installDir, builder.Options.DotNetVersion);

            // Download versions mentioned in `global.json` files
            // See https://docs.microsoft.com/en-us/dotnet/core/tools/global-json
            var installScript = BuildScript.Success;
            var validGlobalJson = false;
            foreach (var path in builder.Paths.Select(p => p.Item1).Where(p => p.EndsWith("global.json", StringComparison.Ordinal)))
            {
                string version;
                try
                {
                    var o = JObject.Parse(File.ReadAllText(path));
                    version = (string)o["sdk"]["version"];
                }
                catch  // lgtm[cs/catch-of-all-exceptions]
                {
                    // not a valid global.json file
                    continue;
                }

                installScript &= DownloadDotNetVersion(builder, installDir, version);
                validGlobalJson = true;
            }

            return validGlobalJson ? installScript : BuildScript.Failure;
        }

        /// <summary>
        /// Returns a script for downloading a specific .NET Core SDK version, if the
        /// version is not already installed.
        ///
        /// See https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script.
        /// </summary>
        private static BuildScript DownloadDotNetVersion(Autobuilder builder, string path, string version)
        {
            return BuildScript.Bind(GetInstalledSdksScript(builder.Actions), (sdks, sdksRet) =>
                {
                    if (sdksRet == 0 && sdks.Count == 1 && sdks[0].StartsWith(version + " ", StringComparison.Ordinal))
                        // The requested SDK is already installed (and no other SDKs are installed), so
                        // no need to reinstall
                        return BuildScript.Failure;

                    builder.Log(Severity.Info, "Attempting to download .NET Core {0}", version);

                    if (builder.Actions.IsWindows())
                    {
                        var psScript = @"param([string]$Version, [string]$InstallDir)

add-type @""
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy
{
    public bool CheckValidationResult(ServicePoint srvPoint, X509Certificate certificate, WebRequest request, int certificateProblem)
    {
        return true;
    }
}
""@
$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
$Script = Invoke-WebRequest -useb 'https://dot.net/v1/dotnet-install.ps1'

$arguments = @{
  Channel = 'release'
  Version = $Version
  InstallDir = $InstallDir
}

$ScriptBlock = [scriptblock]::create("".{$($Script)} $(&{$args} @arguments)"")

Invoke-Command -ScriptBlock $ScriptBlock";
                        var psScriptFile = builder.Actions.PathCombine(builder.Options.RootDirectory, "install-dotnet.ps1");
                        builder.Actions.WriteAllText(psScriptFile, psScript);

                        var install = new CommandBuilder(builder.Actions).
                            RunCommand("powershell").
                            Argument("-NoProfile").
                            Argument("-ExecutionPolicy").
                            Argument("unrestricted").
                            Argument("-file").
                            Argument(psScriptFile).
                            Argument("-Version").
                            Argument(version).
                            Argument("-InstallDir").
                            Argument(path);

                        var removeScript = new CommandBuilder(builder.Actions).
                            RunCommand("del").
                            Argument(psScriptFile);

                        return install.Script & BuildScript.Try(removeScript.Script);
                    }
                    else
                    {
                        var downloadDotNetInstallSh = BuildScript.DownloadFile(
                            "https://dot.net/v1/dotnet-install.sh",
                            "dotnet-install.sh",
                            e => builder.Log(Severity.Warning, $"Failed to download 'dotnet-install.sh': {e.Message}"));

                        var chmod = new CommandBuilder(builder.Actions).
                            RunCommand("chmod").
                            Argument("u+x").
                            Argument("dotnet-install.sh");

                        var install = new CommandBuilder(builder.Actions).
                            RunCommand("./dotnet-install.sh").
                            Argument("--channel").
                            Argument("release").
                            Argument("--version").
                            Argument(version).
                            Argument("--install-dir").
                            Argument(path);

                        var removeScript = new CommandBuilder(builder.Actions).
                            RunCommand("rm").
                            Argument("dotnet-install.sh");

                        return downloadDotNetInstallSh & chmod.Script & install.Script & BuildScript.Try(removeScript.Script);
                    }
                });
        }

        private static BuildScript GetInstalledSdksScript(IBuildActions actions)
        {
            var listSdks = new CommandBuilder(actions, silent: true).
                RunCommand("dotnet").
                Argument("--list-sdks");
            return listSdks.Script;
        }

        private static string DotNetCommand(IBuildActions actions, string? dotNetPath) =>
            dotNetPath != null ? actions.PathCombine(dotNetPath, "dotnet") : "dotnet";

        private static BuildScript GetInfoCommand(IBuildActions actions, string? dotNetPath, IDictionary<string, string>? environment)
        {
            var info = new CommandBuilder(actions, null, environment).
                RunCommand(DotNetCommand(actions, dotNetPath)).
                Argument("--info");
            return info.Script;
        }

        private static CommandBuilder GetCleanCommand(IBuildActions actions, string? dotNetPath, IDictionary<string, string>? environment)
        {
            var clean = new CommandBuilder(actions, null, environment).
                RunCommand(DotNetCommand(actions, dotNetPath)).
                Argument("clean");
            return clean;
        }

        private static CommandBuilder GetRestoreCommand(IBuildActions actions, string? dotNetPath, IDictionary<string, string>? environment)
        {
            var restore = new CommandBuilder(actions, null, environment).
                RunCommand(DotNetCommand(actions, dotNetPath)).
                Argument("restore");
            return restore;
        }

        private static BuildScript GetInstalledRuntimesScript(IBuildActions actions, string? dotNetPath, IDictionary<string, string>? environment)
        {
            var listSdks = new CommandBuilder(actions, environment: environment, silent: true).
                RunCommand(DotNetCommand(actions, dotNetPath)).
                Argument("--list-runtimes");
            return listSdks.Script;
        }

        /// <summary>
        /// Gets the `dotnet build` script.
        ///
        /// The CLR tracer only works on .NET Core >= 3 on Linux and macOS (see
        /// https://github.com/dotnet/coreclr/issues/19622), so in case we are
        /// running on an older .NET Core, we disable shared compilation (and
        /// hence the need for CLR tracing), by adding a
        /// `/p:UseSharedCompilation=false` argument.
        /// </summary>
        private static BuildScript GetBuildScript(Autobuilder builder, string? dotNetPath, IDictionary<string, string>? environment, bool compatibleClr, string projOrSln)
        {
            var build = new CommandBuilder(builder.Actions, null, environment);
            var script = builder.MaybeIndex(build, DotNetCommand(builder.Actions, dotNetPath)).
                Argument("build").
                Argument("--no-incremental");

            return compatibleClr ?
                script.Argument(builder.Options.DotNetArguments).
                    QuoteArgument(projOrSln).
                    Script :
                script.Argument("/p:UseSharedCompilation=false").
                    Argument(builder.Options.DotNetArguments).
                    QuoteArgument(projOrSln).
                    Script;
        }
    }
}
