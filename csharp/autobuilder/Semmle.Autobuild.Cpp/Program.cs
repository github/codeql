using System;

using Semmle.Autobuild.Shared;
using Semmle.Util;

namespace Semmle.Autobuild.Cpp
{
    class Program
    {
        static int Main()
        {

            try
            {
                var actions = SystemBuildActions.Instance;
                var options = new CppAutobuildOptions(actions);
                try
                {
                    Console.WriteLine("CodeQL C++ autobuilder");
                    using var builder = new CppAutobuilder(actions, options);
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
