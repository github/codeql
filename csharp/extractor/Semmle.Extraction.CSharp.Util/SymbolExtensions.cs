using System.Collections.Generic;
using System.Text.RegularExpressions;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Util
{
    public static partial class SymbolExtensions
    {
        /// <summary>
        /// Gets the name of this symbol.
        ///
        /// If the symbol implements an explicit interface, only the
        /// name of the member being implemented is included, not the
        /// explicit prefix.
        /// </summary>
        public static string GetName(this ISymbol symbol, bool useMetadataName = false)
        {
            var name = useMetadataName ? symbol.MetadataName : symbol.Name;
            return symbol.CanBeReferencedByName ? name : name.Substring(symbol.Name.LastIndexOf('.') + 1);
        }

        private static readonly Dictionary<string, string> methodToOperator = new Dictionary<string, string>
        {
            { "op_LogicalNot", "!" },
            { "op_BitwiseAnd", "&" },
            { "op_Equality", "==" },
            { "op_Inequality", "!=" },
            { "op_UnaryPlus", "+" },
            { "op_Addition", "+" },
            { "op_UnaryNegation", "-" },
            { "op_Subtraction", "-" },
            { "op_Multiply", "*" },
            { "op_Division", "/" },
            { "op_Modulus", "%" },
            { "op_GreaterThan", ">" },
            { "op_GreaterThanOrEqual", ">=" },
            { "op_LessThan", "<" },
            { "op_LessThanOrEqual", "<=" },
            { "op_Decrement", "--" },
            { "op_Increment", "++" },
            { "op_Implicit", "implicit conversion" },
            { "op_Explicit", "explicit conversion" },
            { "op_OnesComplement", "~" },
            { "op_RightShift", ">>" },
            { "op_UnsignedRightShift", ">>>" },
            { "op_LeftShift", "<<" },
            { "op_BitwiseOr", "|" },
            { "op_ExclusiveOr", "^" },
            { "op_True", "true" },
            { "op_False", "false" }
        };

        /// <summary>
        /// Convert an operator method name in to a symbolic name.
        /// A return value indicates whether the conversion succeeded.
        /// </summary>
        public static bool TryGetOperatorSymbol(this ISymbol symbol, out string operatorName)
        {
            var methodName = symbol.GetName(useMetadataName: false);

            // Most common use-case.
            if (methodToOperator.TryGetValue(methodName, out var opName))
            {
                operatorName = opName;
                return true;
            }

            var match = CheckedRegex().Match(methodName);
            if (match.Success && methodToOperator.TryGetValue($"op_{match.Groups[1]}", out var uncheckedName))
            {
                operatorName = $"checked {uncheckedName}";
                return true;
            }

            operatorName = methodName;
            return false;
        }

        [GeneratedRegex("^op_Checked(.*)$")]
        private static partial Regex CheckedRegex();
    }
}
