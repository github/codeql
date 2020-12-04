using System;
using System.Collections.Generic;
using System.Linq;

namespace Semmle.Extraction.CIL.Entities
{
    internal sealed partial class NoMetadataHandleType
    {
        /// <summary>
        /// Parser to split a fully qualified name into short name, namespace or declaring type name, assembly name, and
        /// type argument names. Names are in the following format:
        /// <c>N1.N2.T1`2+T2`2[T3,[T4, A1, Version=...],T5,T6], A2, Version=...</c>
        /// </summary>
        /// <example>
        /// <code>typeof(System.Collections.Generic.List<int>.Enumerator)
        /// -> System.Collections.Generic.List`1+Enumerator[[System.Int32, System.Private.CoreLib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]], System.Private.CoreLib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e
        /// typeof(System.Collections.Generic.List<>.Enumerator)
        /// -> System.Collections.Generic.List`1+Enumerator, System.Private.CoreLib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e
        /// </code>
        /// </example>
        private class FullyQualifiedNameParser
        {
            public string ShortName { get; internal set; }
            public string? AssemblyName { get; internal set; }
            public IEnumerable<string>? TypeArguments { get; internal set; }
            public string? UnboundGenericTypeName { get; internal set; }
            public string ContainerName { get; internal set; }
            public bool IsContainerNamespace { get; internal set; }

            private string AssemblySuffix => string.IsNullOrWhiteSpace(AssemblyName) ? "" : $", {AssemblyName}";

            public FullyQualifiedNameParser(string name)
            {
                ExtractAssemblyName(ref name, out var lastBracketIndex);
                ExtractTypeArguments(ref name, lastBracketIndex, out var containerTypeArguments);
                ExtractContainer(ref name, containerTypeArguments);

                ShortName = name;
            }

            private void ExtractTypeArguments(ref string name, int lastBracketIndex, out string containerTypeArguments)
            {
                var firstBracketIndex = name.IndexOf('[');
                if (firstBracketIndex < 0)
                {
                    // not generic or non-constructed generic
                    TypeArguments = null;
                    containerTypeArguments = "";
                    UnboundGenericTypeName = null;
                    return;
                }

                // "T3,[T4, Assembly1, Version=...],T5,T6"
                string typeArgs;
                (name, _, typeArgs, _) = name.Split(firstBracketIndex, firstBracketIndex + 1, lastBracketIndex - firstBracketIndex - 1);

                var thisTypeArgCount = GenericsHelper.GetGenericTypeParameterCount(name);
                if (thisTypeArgCount == 0)
                {
                    // not generic or non-constructed generic; container is constructed
                    TypeArguments = null;
                    containerTypeArguments = $"[{typeArgs}]";
                    UnboundGenericTypeName = null;
                    return;
                }

                // constructed generic
                // "T3,[T4, Assembly1, Version=...]", ["T5", "T6"]
                var (containerTypeArgs, thisTypeArgs) = ParseTypeArgumentStrings(typeArgs, thisTypeArgCount);

                TypeArguments = thisTypeArgs;

                if (string.IsNullOrWhiteSpace(containerTypeArgs))
                {
                    // containing type is not constructed generics
                    containerTypeArguments = "";
                }
                else
                {
                    // "T3,[T4, Assembly1, Version=...],,]"
                    containerTypeArguments = $"[{containerTypeArgs}]";
                }

                UnboundGenericTypeName = $"{name}{AssemblySuffix}";
            }

            private void ExtractContainer(ref string name, string containerTypeArguments)
            {
                var lastPlusIndex = name.LastIndexOf('+');
                IsContainerNamespace = lastPlusIndex < 0;
                if (IsContainerNamespace)
                {
                    ExtractContainerNamespace(ref name);
                }
                else
                {
                    ExtractContainerType(ref name, containerTypeArguments, lastPlusIndex);
                }
            }

            private void ExtractContainerNamespace(ref string name)
            {
                var lastDotIndex = name.LastIndexOf('.');
                if (lastDotIndex >= 0)
                {
                    (ContainerName, _, name) = name.Split(lastDotIndex, lastDotIndex + 1);
                }
                else
                {
                    ContainerName = ""; // global namespace name
                }
            }

            private void ExtractContainerType(ref string name, string containerTypeArguments, int lastPlusIndex)
            {
                (ContainerName, _, name) = name.Split(lastPlusIndex, lastPlusIndex + 1);
                ContainerName = $"{ContainerName}{containerTypeArguments}{AssemblySuffix}";
            }

            private void ExtractAssemblyName(ref string name, out int lastBracketIndex)
            {
                lastBracketIndex = name.LastIndexOf(']');
                var assemblyCommaIndex = name.IndexOf(',', lastBracketIndex < 0 ? 0 : lastBracketIndex);
                if (assemblyCommaIndex >= 0)
                {
                    // "Assembly2, Version=..."
                    (name, _, AssemblyName) = name.Split(assemblyCommaIndex, assemblyCommaIndex + 2);
                }
            }

            private static (string, IEnumerable<string>) ParseTypeArgumentStrings(string typeArgs, int thisTypeArgCount)
            {
                var thisTypeArgs = new Stack<string>(thisTypeArgCount);
                while (typeArgs.Length > 0 && thisTypeArgCount > 0)
                {
                    int startCurrentType;
                    if (typeArgs[^1] != ']')
                    {
                        startCurrentType = typeArgs.LastIndexOf(',') + 1;
                        thisTypeArgs.Push(typeArgs.Substring(startCurrentType));
                    }
                    else
                    {
                        var bracketCount = 1;
                        for (startCurrentType = typeArgs.Length - 2; startCurrentType >= 0 && bracketCount > 0; startCurrentType--)
                        {
                            if (typeArgs[startCurrentType] == ']')
                            {
                                bracketCount++;
                            }
                            else if (typeArgs[startCurrentType] == '[')
                            {
                                bracketCount--;
                            }
                        }
                        startCurrentType++;
                        thisTypeArgs.Push(typeArgs[(startCurrentType + 1)..^1]);
                    }

                    if (startCurrentType != 0)
                    {
                        typeArgs = typeArgs.Substring(0, startCurrentType - 1);
                    }
                    else
                    {
                        typeArgs = "";
                    }
                    thisTypeArgCount--;
                }
                return (typeArgs, thisTypeArgs.ToList());
            }
        }
    }
}
