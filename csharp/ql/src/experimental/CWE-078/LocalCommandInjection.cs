using System.Diagnostics;

namespace Github.Sample.LocalInjection
{
    public static class Sample1
    {
 
        public static void Main(string[] args)
        {
            if (args == null || args.Length == 0)
            {
                return;
            }
            string action = args[0];

            DoFile(args[1]);
        }

        private static void DoFile(string file)
        {
            try
            {
                ProcessStartInfo startInfo = new ProcessStartInfo(file) { UseShellExecute = true };
                var pinfo = Process.Start(startInfo)
            }
            catch (Exception e1)
            {
                Logger.Error($"Exception while processing file : {e1.Message}");
            }
        }
    }
}