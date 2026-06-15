using System;
using System.Collections.Generic;
using Microsoft.Extensions.Configuration;

namespace CommandArgs
{
    public class CommandArgsUse
    {
        public static void M1()
        {
            string result = Environment.GetCommandLineArgs()[0];
        }

        public static void M2()
        {
            string result = Environment.CommandLine;
        }

        public static void Main(string[] args)
        {
            var builder = new ConfigurationBuilder();
            builder.AddCommandLine(args);
            var config = builder.Build();
            var arg1 = config["arg1"];
            Sink(arg1);
        }

        public static void AddCommandLine2()
        {
            var config = new ConfigurationBuilder()
                .AddCommandLine(Environment.GetCommandLineArgs())
                .Build();
            var arg1 = config["arg1"];
            Sink(arg1);
        }

        static void Sink(object o) { }
    }
}