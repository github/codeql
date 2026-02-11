namespace Semmle.Extraction.CSharp.Standalone
{
    public class Program
    {
        public static int Main(string[] args)
        {
            CSharp.Extractor.SetInvariantCulture();

            var options = Options.Create(args);

            if (options.Help)
            {
                Options.ShowHelp(System.Console.Out);
                return 0;
            }

            if (options.Errors)
                return 1;

            return (int)Extractor.Run(options);
        }
    }
}
