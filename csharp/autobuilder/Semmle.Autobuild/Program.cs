using System;

namespace Semmle.Autobuild
{
    class Program
    {
        static int Main()
        {
            var options = new AutobuildOptions();
            var actions = SystemBuildActions.Instance;

            try
            {
                options.ReadEnvironment(actions);
            }
            catch (ArgumentOutOfRangeException ex)
            {
                Console.WriteLine("The value \"{0}\" for parameter \"{1}\" is invalid", ex.ActualValue, ex.ParamName);
            }

            var builder = new Autobuilder(actions, options);

            Console.WriteLine($"Semmle autobuilder for {options.Language}");

            return builder.AttemptBuild();
        }
    }
}
