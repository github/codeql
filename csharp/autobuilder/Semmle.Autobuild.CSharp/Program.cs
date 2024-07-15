using System;

using Semmle.Autobuild.Shared;
using Semmle.Util;

namespace Semmle.Autobuild.CSharp
{
    public static class Program
    {
        public static int Main()
        {

            try
            {
                var actions = SystemBuildActions.Instance;
                var options = new CSharpAutobuildOptions(actions);
                try
                {
                    Console.WriteLine("CodeQL C# autobuilder");
                    using var builder = new CSharpAutobuilder(actions, options);
                    return builder.AttemptBuild();
                }
                catch (InvalidEnvironmentException ex)
                {
                    Console.WriteLine($"The environment is invalid: {ex.Message}");
                }
            }
            catch (ArgumentOutOfRangeException ex)
            {
                Console.WriteLine($"The value \"{ex.ActualValue}\" for parameter \"{ex.ParamName}\" is invalid");
            }
            return 1;
        }
    }
}
