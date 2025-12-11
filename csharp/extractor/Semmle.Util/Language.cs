namespace Semmle.Util
{
    public sealed class Language
    {
        public static Language Cpp { get; } = new Language("CPP", ".vcxproj");
        public static Language CSharp { get; } = new Language("CSHARP", ".csproj", ".slnx");

        public bool ProjectFileHasThisLanguage(string path) =>
            System.IO.Path.GetExtension(path) == ProjectExtension;

        public string ProjectExtension { get; }
        public string? SolutionExtension { get; }
        public string UpperCaseName { get; }

        private Language(string name, string projectExtension)
        {
            ProjectExtension = projectExtension;
            UpperCaseName = name;
        }

        private Language(string name, string projectExtension, string solutionExtension) : this(name, projectExtension)
        {
            SolutionExtension = solutionExtension;
        }

        public override string ToString() =>
            ProjectExtension == Cpp.ProjectExtension ? "C/C++" : "C#";
    }
}
