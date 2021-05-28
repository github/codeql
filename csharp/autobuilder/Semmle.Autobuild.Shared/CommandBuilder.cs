using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Semmle.Autobuild.Shared
{
    /// <summary>
    /// Utility to construct a build command.
    /// </summary>
    public class CommandBuilder
    {
        private enum EscapeMode { Process, Cmd };

        private readonly StringBuilder arguments;
        private bool firstCommand;
        private string? executable;
        private readonly EscapeMode escapingMode;
        private readonly string? workingDirectory;
        private readonly IDictionary<string, string>? environment;
        private readonly bool silent;

        /// <summary>
        /// Initializes a new instance of the <see cref="T:Semmle.Autobuild.CommandBuilder"/> class.
        /// </summary>
        /// <param name="workingDirectory">The working directory (<code>null</code> for current directory).</param>
        /// <param name="environment">Additional environment variables.</param>
        /// <param name="silent">Whether this command should be run silently.</param>
        public CommandBuilder(IBuildActions actions, string? workingDirectory = null, IDictionary<string, string>? environment = null, bool silent = false)
        {
            arguments = new StringBuilder();
            if (actions.IsWindows())
            {
                executable = "cmd.exe";
                arguments.Append("/C");
                escapingMode = EscapeMode.Cmd;
            }
            else
            {
                escapingMode = EscapeMode.Process;
            }

            firstCommand = true;
            this.workingDirectory = workingDirectory;
            this.environment = environment;
            this.silent = silent;
        }

        private void OdasaIndex(string odasa)
        {
            RunCommand(odasa, "index --auto");
        }

        public CommandBuilder CallBatFile(string batFile, string? argumentsOpt = null)
        {
            NextCommand();
            arguments.Append(" CALL");
            QuoteArgument(batFile);
            Argument(argumentsOpt);
            return this;
        }

        /// <summary>
        /// Perform odasa index on a given command or BAT file.
        /// </summary>
        /// <param name="odasa">The odasa executable.</param>
        /// <param name="command">The command to run.</param>
        /// <param name="argumentsOpt">Additional arguments.</param>
        /// <returns>this for chaining calls.</returns>
        public CommandBuilder IndexCommand(string odasa, string command, string? argumentsOpt = null)
        {
            OdasaIndex(odasa);
            QuoteArgument(command);
            Argument(argumentsOpt);
            return this;
        }

        private static readonly char[] specialChars = { ' ', '\t', '\n', '\v', '\"' };
        private static readonly char[] cmdMetacharacter = { '(', ')', '%', '!', '^', '\"', '<', '>', '&', '|' };

        /// <summary>
        /// Appends the given argument to the command line.
        /// </summary>
        /// <param name="argument">The argument to append.</param>
        /// <param name="force">Whether to always quote the argument.</param>
        /// <param name="cmd">Whether to escape for cmd.exe</param>
        ///
        /// <remarks>
        /// This implementation is copied from
        /// https://blogs.msdn.microsoft.com/twistylittlepassagesallalike/2011/04/23/everyone-quotes-command-line-arguments-the-wrong-way/
        /// </remarks>
        private void ArgvQuote(string argument, bool force)
        {
            var cmd = escapingMode == EscapeMode.Cmd;
            if (!force &&
                !string.IsNullOrEmpty(argument) &&
                argument.IndexOfAny(specialChars) == -1)
            {
                arguments.Append(argument);
            }
            else
            {
                if (cmd)
                    arguments.Append('^');

                arguments.Append('\"');

                for (var it = 0; ; ++it)
                {
                    var numBackslashes = 0;
                    while (it != argument.Length && argument[it] == '\\')
                    {
                        ++it;
                        ++numBackslashes;
                    }

                    if (it == argument.Length)
                    {
                        arguments.Append('\\', numBackslashes * 2);
                        break;
                    }

                    if (argument[it] == '\"')
                    {
                        arguments.Append('\\', numBackslashes * 2 + 1);
                        if (cmd)
                            arguments.Append('^');
                        arguments.Append(arguments[it]);
                    }
                    else
                    {
                        arguments.Append('\\', numBackslashes);
                        if (cmd && cmdMetacharacter.Any(c => c == argument[it]))
                            arguments.Append('^');

                        arguments.Append(argument[it]);
                    }
                }

                if (cmd)
                    arguments.Append('^');

                arguments.Append('\"');
            }
        }

        public CommandBuilder QuoteArgument(string argumentsOpt)
        {
            if (argumentsOpt is not null)
            {
                NextArgument();
                ArgvQuote(argumentsOpt, false);
            }
            return this;
        }

        private void NextArgument()
        {
            if (arguments.Length > 0)
                arguments.Append(' ');
        }

        public CommandBuilder Argument(string? argumentsOpt)
        {
            if (argumentsOpt is not null)
            {
                NextArgument();
                arguments.Append(argumentsOpt);
            }
            return this;
        }

        private void NextCommand()
        {
            if (firstCommand)
                firstCommand = false;
            else
                arguments.Append(" &&");
        }

        public CommandBuilder RunCommand(string exe, string? argumentsOpt = null, bool quoteExe = true)
        {
            var (exe0, arg0) =
                escapingMode == EscapeMode.Process && exe.EndsWith(".exe", System.StringComparison.Ordinal)
                                          ? ("mono", exe) // Linux
                                          : (exe, null);

            NextCommand();
            if (executable is null)
            {
                executable = exe0;
            }
            else
            {
                if (quoteExe)
                    QuoteArgument(exe0);
                else
                    Argument(exe0);
            }
            Argument(arg0);
            Argument(argumentsOpt);
            return this;
        }

        /// <summary>
        /// Returns a build script that contains just this command.
        /// </summary>
        public BuildScript Script
        {
            get
            {
                if (executable is null)
                    throw new System.InvalidOperationException("executable is null");
                return BuildScript.Create(executable, arguments.ToString(), silent, workingDirectory, environment);
            }
        }
    }
}
