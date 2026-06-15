using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Xml;

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

        private static bool HasSdkAttribute(XmlElement xml) =>
            xml.HasAttribute("Sdk");

        private static bool AnyElement(XmlNodeList l, Func<XmlElement, bool> f) =>
            l.OfType<XmlElement>().Any(f);

        /// <summary>
        /// According to https://learn.microsoft.com/en-us/visualstudio/msbuild/how-to-use-project-sdk?view=vs-2022#reference-a-project-sdk
        /// there are three ways to reference a project SDK:
        ///  1. As an attribute on the &lt;Project/&gt;.
        ///  2. As a top level element of &lt;Project&gt;.
        ///  3. As an attribute on an &lt;Import&gt; element.
        ///
        /// Returns true, if the Sdk attribute is used, otherwise false.
        /// </summary>
        private static bool ReferencesSdk(XmlElement xml) =>
            HasSdkAttribute(xml) || // Case 1
            AnyElement(xml.ChildNodes, e => e.Name == "Sdk") || // Case 2
            AnyElement(xml.GetElementsByTagName("Import"), HasSdkAttribute); // Case 3

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
                if (ReferencesSdk(root))
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
