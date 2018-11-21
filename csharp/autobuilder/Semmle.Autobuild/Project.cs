﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Xml;
using Semmle.Util.Logging;

namespace Semmle.Autobuild
{
    /// <summary>
    /// Representation of a .proj file, a .csproj file (C#), or a .vcxproj file (C++).
    /// C# project files come in 2 flavours, .Net core and msbuild, but they
    /// have the same file extension.
    /// </summary>
    public class Project : ProjectOrSolution
    {
        /// <summary>
        /// Holds if this project is for .Net core.
        /// </summary>
        public bool DotNetProject { get; private set; }

        public bool ValidToolsVersion { get; private set; }

        public Version ToolsVersion { get; private set; }

        readonly List<Project> includedProjects = new List<Project>();
        public override IEnumerable<IProjectOrSolution> IncludedProjects =>
            includedProjects.Concat(includedProjects.SelectMany(s => s.IncludedProjects));

        public Project(Autobuilder builder, string path) : base(builder, path)
        {
            ToolsVersion = new Version();

            if (!builder.Actions.FileExists(FullPath))
                return;

            XmlDocument projFile;
            try
            {
                projFile = builder.Actions.LoadXml(FullPath);
            }
            catch (XmlException)
            {
                builder.Log(Severity.Info, $"Skipping project file {path} as it is not a valid XML document.");
                return;
            }

            var root = projFile.DocumentElement;

            if (root.Name == "Project")
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
                    catch   // Generic catch clause - Version constructor throws about 5 different exceptions.
                    {
                        builder.Log(Severity.Warning, "Project {0} has invalid tools version {1}", path, toolsVersion);
                    }
                }

                // The documentation on `.proj` files is very limited, but it appears that both
                // `<ProjectFile Include="X"/>` and `<ProjectFiles Include="X"/>` is valid
                var mgr = new XmlNamespaceManager(projFile.NameTable);
                mgr.AddNamespace("msbuild", "http://schemas.microsoft.com/developer/msbuild/2003");
                var projectFileIncludes = root.SelectNodes("//msbuild:Project/msbuild:ItemGroup/msbuild:ProjectFile/@Include", mgr).OfType<XmlNode>();
                var projectFilesIncludes = root.SelectNodes("//msbuild:Project/msbuild:ItemGroup/msbuild:ProjectFiles/@Include", mgr).OfType<XmlNode>();
                foreach (var include in projectFileIncludes.Concat(projectFilesIncludes))
                {
                    var includePath = builder.Actions.IsWindows() ? include.Value : include.Value.Replace("\\", "/");
                    includedProjects.Add(new Project(builder, builder.Actions.PathCombine(builder.Actions.GetDirectoryName(this.FullPath), includePath)));
                }
            }
        }
    }
}
