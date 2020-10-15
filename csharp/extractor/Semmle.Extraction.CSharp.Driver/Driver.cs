namespace Semmle.Extraction.CSharp
{
    /// <summary>
    /// A command-line driver for the extractor.
    /// </summary>
    public class Driver
    {
        public static int Main(string[] args)
        {
            return (int)Extractor.Run(args);
        }
    }
}
