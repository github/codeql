namespace Semmle.Extraction.CSharp
{
    /// <summary>
    /// A command-line driver for the extractor.
    /// </summary>
    public static class Driver
    {
        public static int Main(string[] args)
        {
            Extractor.SetInvariantCulture();

            return (int)Extractor.Run(args);
        }
    }
}
