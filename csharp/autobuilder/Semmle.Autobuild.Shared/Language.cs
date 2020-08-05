﻿namespace Semmle.Autobuild.Shared
{
    public sealed class Language
    {
        public static readonly Language Cpp = new Language(".vcxproj", "CPP");
        public static readonly Language CSharp = new Language(".csproj", "CSHARP");

        public bool ProjectFileHasThisLanguage(string path) =>
            System.IO.Path.GetExtension(path) == ProjectExtension;

        public readonly string ProjectExtension;
        public readonly string UpperCaseName;

        private Language(string extension, string name)
        {
            ProjectExtension = extension;
            UpperCaseName = name;
        }

        public override string ToString() =>
            ProjectExtension == Cpp.ProjectExtension ? "C/C++" : "C#";
    }
}
