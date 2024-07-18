using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Xml;
using Semmle.Util.Logging;

namespace Semmle.Autobuild.Shared
{
    /// <summary>
    /// Representation of a .proj file, a .csproj file (C#), or a .vcxproj file (C++).
    /// C# project files come in 2 flavours, .Net core and msbuild, but they
    /// have the same file extension.
    /// </summary>
    public class Project<TAutobuildOptions> : ProjectOrSolution<TAutobuildOptions> where TAutobuildOptions : AutobuildOptionsShared
    {
        /// <summary>
        /// Holds if this project is for .Net core.
        /// </summary>
        public bool DotNetProject { get; private set; }

        public bool ValidToolsVersion { get; private set; }

        public Version ToolsVersion { get; private set; }

        private readonly Lazy<List<Project<TAutobuildOptions>>> includedProjectsLazy;
        public override IEnumerable<IProjectOrSolution> IncludedProjects => includedProjectsLazy.Value;

        public Project(Autobuilder<TAutobuildOptions> builder, string path) : base(builder, path)
        {
            ToolsVersion = new Version();
            includedProjectsLazy = new Lazy<List<Project<TAutobuildOptions>>>(() => new List<Project<TAutobuildOptions>>());

            if (!builder.Actions.FileExists(FullPath))
                return;

            XmlDocument projFile;
            try
            {
                projFile = builder.Actions.LoadXml(FullPath);
            }
            catch (Exception ex) when (ex is XmlException || ex is FileNotFoundException)
            {
                builder.Logger.LogInfo($"Unable to read project file {path}.");
                return;
            }

            var root = projFile.DocumentElement;

            if (root?.Name == "Project")
            {
                if (root.HasAttribute("Sdk"))
                {
                    DotNetProject = true;
                    return;
                }

                var toolsVersion = root.GetAttribute("ToolsVersion");
                if (!string.IsNullOrEmpty(toolsVersion))
                {
                    try
                    {
                        ToolsVersion = new Version(toolsVersion);
                        ValidToolsVersion = true;
                    }
                    catch  // lgtm[cs/catch-of-all-exceptions]
                           // Generic catch clause - Version constructor throws about 5 different exceptions.
                    {
                        builder.Logger.LogWarning($"Project {path} has invalid tools version {toolsVersion}");
                    }
                }

                includedProjectsLazy = new Lazy<List<Project<TAutobuildOptions>>>(() =>
                {
                    var ret = new List<Project<TAutobuildOptions>>();
                    // The documentation on `.proj` files is very limited, but it appears that both
                    // `<ProjectFile Include="X"/>` and `<ProjectFiles Include="X"/>` is valid
                    var mgr = new XmlNamespaceManager(projFile.NameTable);
                    mgr.AddNamespace("msbuild", "http://schemas.microsoft.com/developer/msbuild/2003");
                    var projectFileIncludes = root.SelectNodes("//msbuild:Project/msbuild:ItemGroup/msbuild:ProjectFile/@Include", mgr)
                        ?.OfType<XmlNode>() ?? Array.Empty<XmlNode>();
                    var projectFilesIncludes = root.SelectNodes("//msbuild:Project/msbuild:ItemGroup/msbuild:ProjectFiles/@Include", mgr)
                        ?.OfType<XmlNode>() ?? Array.Empty<XmlNode>();
                    foreach (var include in projectFileIncludes.Concat(projectFilesIncludes))
                    {
                        if (include?.Value is null)
                        {
                            continue;
                        }

                        var includePath = builder.Actions.PathCombine(include.Value.Split('\\', StringSplitOptions.RemoveEmptyEntries));
                        ret.Add(new Project<TAutobuildOptions>(builder, builder.Actions.PathCombine(DirectoryName, includePath)));
                    }
                    return ret;
                });
            }
        }
    }
}
