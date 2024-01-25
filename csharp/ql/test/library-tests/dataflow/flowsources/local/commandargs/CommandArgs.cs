using System;

namespace CommandArgs
{
    class CommandArgsUse
    {
        public static void M1()
        {
            string result = Environment.GetCommandLineArgs()[0];
        }

        public static void M2()
        {
            string result = Environment.CommandLine;
        }
    }
}