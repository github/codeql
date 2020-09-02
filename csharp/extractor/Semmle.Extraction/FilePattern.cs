using System.IO;

namespace Semmle.Extraction
{
    /// <summary>
    /// An file pattern, as used in either an extractor layout file or
    /// a path transformer file.
    /// </summary>
    class FilePattern
    {
        private readonly bool include;
        private readonly string prefix;

        public bool Include => include;

        public string Prefix => prefix;

        public FilePattern(string line)
        {
            include = false;
            if (line.StartsWith("-"))
                line = line.Substring(1);
            else
                include = true;
            prefix = Normalize(line.Trim());
        }

        static public string Normalize(string path)
        {
            path = Path.GetFullPath(path);
            return path.Replace('\\', '/');
        }
    }
}