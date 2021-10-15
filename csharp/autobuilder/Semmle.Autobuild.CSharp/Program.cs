using System;
using Semmle.Autobuild.Shared;

namespace Semmle.Autobuild.CSharp
{
    public static class Program
    {
        public static int Main()
        {

            try
            {
                var actions = SystemBuildActions.Instance;
                var options = new AutobuildOptions(actions, Language.CSharp);
                try
                {
                    Console.WriteLine("CodeQL C# autobuilder");
                    var builder = new CSharpAutobuilder(actions, options);
                    return builder.AttemptBuild();
                }
                catch (InvalidEnvironmentException ex)
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
