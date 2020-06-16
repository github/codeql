using System;

namespace Semmle.Autobuild
{
    class Program
    {
        static int Main()
        {

            try
            {
                var actions = SystemBuildActions.Instance;
                var options = new AutobuildOptions(actions);
                try
                {
                    Console.WriteLine($"Semmle autobuilder for {options.Language}");
                    var builder = new Autobuilder(actions, options);
                    return builder.AttemptBuild();
                }
                catch(InvalidEnvironmentException ex)
                {
                    Console.WriteLine("The environment is invalid: {0}", ex.Message);
                }
            }
            catch (ArgumentOutOfRangeException ex)
            {
                Console.WriteLine("The value \"{0}\" for parameter \"{1}\" is invalid", ex.ActualValue, ex.ParamName);
            }
            return 1;
        }
    }
}
