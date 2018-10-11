using System;
using System.IO;
using System.Xml;
using Semmle.Util.Logging;

namespace Semmle.Autobuild
{
    /// <summary>
    /// Representation of a .csproj (C#) or .vcxproj (C++) file.
    /// C# project files come in 2 flavours, .Net core and msbuild, but they
    /// have the same file extension.
    /// </summary>
    public class Project
    {
        /// <summary>
        /// Holds if this project is for .Net core.
        /// </summary>
        public bool DotNetProject { get; private set; }

        public bool ValidToolsVersion { get; private set; }

        public Version ToolsVersion { get; private set; }

        readonly string filename;

        public Project(Autobuilder builder, string filename)
        {
            this.filename = filename;
            ToolsVersion = new Version();

            if (!File.Exists(filename))
                return;

            var projFile = new XmlDocument();
            projFile.Load(filename);
            var root = projFile.DocumentElement;

            if (root.Name == "Project")
            {
                if (root.HasAttribute("Sdk"))
                {
                    DotNetProject = true;
                }
                else
                {
                    var toolsVersion = root.GetAttribute("ToolsVersion");
                    if (string.IsNullOrEmpty(toolsVersion))
                    {
                        builder.Log(Severity.Warning, "Project {0} is missing a tools version", filename);
                    }
                    else
                    {
                        try
                        {
                            ToolsVersion = new Version(toolsVersion);
                            ValidToolsVersion = true;
                        }
                        catch   // Generic catch clause - Version constructor throws about 5 different exceptions.
                        {
                            builder.Log(Severity.Warning, "Project {0} has invalid tools version {1}", filename, toolsVersion);
                        }
                    }
                }
            }
        }

        public override string ToString() => filename;
    }
}
