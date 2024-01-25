using System;
using System.Collections;

namespace EnvironmentVariables
{
    class EnvironmentVariables
    {
        public static void GetEnvironmentVariable(string environmnetVariable)
        {
            string value = Environment.GetEnvironmentVariable(environmnetVariable);
            string valueFromRegistry = Environment.GetEnvironmentVariable(environmnetVariable, EnvironmentVariableTarget.Machine);
            string valueFromProcess = Environment.GetEnvironmentVariable(environmnetVariable, EnvironmentVariableTarget.Process);
        }

        public static void GetEnvironmentVariables()
        {
            IDictionary environmentVariables = Environment.GetEnvironmentVariables();
            IDictionary environmentVariablesFromRegistry = Environment.GetEnvironmentVariables(EnvironmentVariableTarget.Machine);
            IDictionary environmentVariablesFromProcess = Environment.GetEnvironmentVariables(EnvironmentVariableTarget.Process);
        }

        public static void ExpandEnvironmentVariables(string environmentVariable)
        {
            string expanded = Environment.ExpandEnvironmentVariables("%PATH%");
        }
    }
}