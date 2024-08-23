using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell
{
    /// <summary>
    /// Represents a parsed PowerShell Script
    /// </summary>
    public class CompiledScript
    {
        public CompiledScript(string path, ScriptBlockAst compilation, Token[] tokens, ParseError[] errors)
        {
            Location = path;
            ParseResult = compilation;
            Tokens = tokens;
            ParseErrors = errors;
        }

        public ParseError[] ParseErrors { get; set; }

        public Token[] Tokens { get; set; }

        /// <summary>
        /// The AST of this script
        /// </summary>
        public ScriptBlockAst ParseResult { get; }
        /// <summary>
        /// Where this script came from.
        /// </summary>
        public string Location { get; }
    }
}
