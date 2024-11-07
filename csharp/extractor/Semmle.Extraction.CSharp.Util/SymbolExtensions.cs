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

        /// <summary>
        /// Convert an operator method name in to a symbolic name.
        /// A return value indicates whether the conversion succeeded.
        /// </summary>
        public static bool TryGetOperatorSymbol(this ISymbol symbol, out string operatorName)
        {
            static bool TryGetOperatorSymbolFromName(string methodName, out string operatorName)
            {
                var success = true;
                switch (methodName)
                {
                    case "op_LogicalNot":
                        operatorName = "!";
                        break;
                    case "op_BitwiseAnd":
                        operatorName = "&";
                        break;
                    case "op_Equality":
                        operatorName = "==";
                        break;
                    case "op_Inequality":
                        operatorName = "!=";
                        break;
                    case "op_UnaryPlus":
                    case "op_Addition":
                        operatorName = "+";
                        break;
                    case "op_UnaryNegation":
                    case "op_Subtraction":
                        operatorName = "-";
                        break;
                    case "op_Multiply":
                        operatorName = "*";
                        break;
                    case "op_Division":
                        operatorName = "/";
                        break;
                    case "op_Modulus":
                        operatorName = "%";
                        break;
                    case "op_GreaterThan":
                        operatorName = ">";
                        break;
                    case "op_GreaterThanOrEqual":
                        operatorName = ">=";
                        break;
                    case "op_LessThan":
                        operatorName = "<";
                        break;
                    case "op_LessThanOrEqual":
                        operatorName = "<=";
                        break;
                    case "op_Decrement":
                        operatorName = "--";
                        break;
                    case "op_Increment":
                        operatorName = "++";
                        break;
                    case "op_Implicit":
                        operatorName = "implicit conversion";
                        break;
                    case "op_Explicit":
                        operatorName = "explicit conversion";
                        break;
                    case "op_OnesComplement":
                        operatorName = "~";
                        break;
                    case "op_RightShift":
                        operatorName = ">>";
                        break;
                    case "op_UnsignedRightShift":
                        operatorName = ">>>";
                        break;
                    case "op_LeftShift":
                        operatorName = "<<";
                        break;
                    case "op_BitwiseOr":
                        operatorName = "|";
                        break;
                    case "op_ExclusiveOr":
                        operatorName = "^";
                        break;
                    case "op_True":
                        operatorName = "true";
                        break;
                    case "op_False":
                        operatorName = "false";
                        break;
                    default:
                        var match = CheckedRegex().Match(methodName);
                        if (match.Success)
                        {
                            TryGetOperatorSymbolFromName($"op_{match.Groups[1]}", out var uncheckedName);
                            operatorName = $"checked {uncheckedName}";
                            break;
                        }
                        operatorName = methodName;
                        success = false;
                        break;
                }
                return success;
            }

            var methodName = symbol.GetName(useMetadataName: false);
            return TryGetOperatorSymbolFromName(methodName, out operatorName);
        }

        [GeneratedRegex("^op_Checked(.*)$")]
        private static partial Regex CheckedRegex();
    }
}
