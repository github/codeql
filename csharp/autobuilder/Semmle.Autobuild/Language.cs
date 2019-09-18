namespace Semmle.Autobuild
{
    public sealed class Language
    {
        public static readonly Language Cpp = new Language(".vcxproj");
        public static readonly Language CSharp = new Language(".csproj");

        public bool ProjectFileHasThisLanguage(string path) =>
            System.IO.Path.GetExtension(path) == ProjectExtension;

        public readonly string ProjectExtension;

        private Language(string extension)
        {
            ProjectExtension = extension;
        }

        public override string ToString() =>
            ProjectExtension == Cpp.ProjectExtension ? "C/C++" : "C#";
    }
}
