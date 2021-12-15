namespace Semmle.Autobuild.Shared
{
    public sealed class Language
    {
        public static Language Cpp { get; } = new Language(".vcxproj", "CPP");
        public static Language CSharp { get; } = new Language(".csproj", "CSHARP");

        public bool ProjectFileHasThisLanguage(string path) =>
            System.IO.Path.GetExtension(path) == ProjectExtension;

        public string ProjectExtension { get; }
        public string UpperCaseName { get; }

        private Language(string extension, string name)
        {
            ProjectExtension = extension;
            UpperCaseName = name;
        }

        public override string ToString() =>
            ProjectExtension == Cpp.ProjectExtension ? "C/C++" : "C#";
    }
}
