﻿using System;
using System.Collections.Generic;
using System.IO;

namespace Semmle.Autobuild
{
    /// <summary>
    /// A build script.
    /// </summary>
    public abstract class BuildScript
    {
        /// <summary>
        /// Run this build script.
        /// </summary>
        /// <param name="actions">
        /// The interface used to implement the build actions.
        /// </param>
        /// <param name="startCallback">
        /// A call back that is called every time a new process is started. The
        /// argument to the call back is a textual representation of the process.
        /// </param>
        /// <param name="exitCallBack">
        /// A call back that is called every time a new process exits. The first
        /// argument to the call back is the exit code, and the second argument is
        /// an exit message.
        /// </param>
        /// <returns>The exit code from this build script.</returns>
        public abstract int Run(IBuildActions actions, Action<string, bool> startCallback, Action<int, string, bool> exitCallBack);

        /// <summary>
        /// Run this build command.
        /// </summary>
        /// <param name="actions">
        /// The interface used to implement the build actions.
        /// </param>
        /// <param name="startCallback">
        /// A call back that is called every time a new process is started. The
        /// argument to the call back is a textual representation of the process.
        /// </param>
        /// <param name="exitCallBack">
        /// A call back that is called every time a new process exits. The first
        /// argument to the call back is the exit code, and the second argument is
        /// an exit message.
        /// </param>
        /// <param name="stdout">Contents of standard out.</param>
        /// <returns>The exit code from this build script.</returns>
        public abstract int Run(IBuildActions actions, Action<string, bool> startCallback, Action<int, string, bool> exitCallBack, out IList<string> stdout);

        class BuildCommand : BuildScript
        {
            readonly string exe, arguments, workingDirectory;
            readonly IDictionary<string, string> environment;
            readonly bool silent;

            /// <summary>
            /// Create a simple build command.
            /// </summary>
            /// <param name="exe">The executable to run.</param>
            /// <param name="argumentsOpt">The arguments to the executable, or null.</param>
            /// <param name="silent">Whether this command should run silently.</param>
            /// <param name="workingDirectory">The working directory (<code>null</code> for current directory).</param>
            /// <param name="environment">Additional environment variables.</param>
            public BuildCommand(string exe, string argumentsOpt, bool silent, string workingDirectory = null, IDictionary<string, string> environment = null)
            {
                this.exe = exe;
                this.arguments = argumentsOpt ?? "";
                this.silent = silent;
                this.workingDirectory = workingDirectory;
                this.environment = environment;
            }

            public override string ToString() => exe + " " + arguments;

            public override int Run(IBuildActions actions, Action<string, bool> startCallback, Action<int, string, bool> exitCallBack)
            {
                startCallback(this.ToString(), silent);
                var ret = 1;
                var retMessage = "";
                try
                {
                    ret = actions.RunProcess(exe, arguments, workingDirectory, environment);
                }
                catch (Exception ex)
                    when (ex is System.ComponentModel.Win32Exception || ex is FileNotFoundException)
                {
                    retMessage = ex.Message;
                }

                exitCallBack(ret, retMessage, silent);
                return ret;
            }

            public override int Run(IBuildActions actions, Action<string, bool> startCallback, Action<int, string, bool> exitCallBack, out IList<string> stdout)
            {
                startCallback(this.ToString(), silent);
                var ret = 1;
                var retMessage = "";
                try
                {
                    ret = actions.RunProcess(exe, arguments, workingDirectory, environment, out stdout);
                }
                catch (Exception ex)
                    when (ex is System.ComponentModel.Win32Exception || ex is FileNotFoundException)
                {
                    retMessage = ex.Message;
                    stdout = new string[0];
                }
                exitCallBack(ret, retMessage, silent);
                return ret;
            }

        }

        class ReturnBuildCommand : BuildScript
        {
            readonly Func<IBuildActions, int> func;
            public ReturnBuildCommand(Func<IBuildActions, int> func)
            {
                this.func = func;
            }

            public override int Run(IBuildActions actions, Action<string, bool> startCallback, Action<int, string, bool> exitCallBack) => func(actions);

            public override int Run(IBuildActions actions, Action<string, bool> startCallback, Action<int, string, bool> exitCallBack, out IList<string> stdout)
            {
                stdout = new string[0];
                return func(actions);
            }
        }

        class BindBuildScript : BuildScript
        {
            readonly BuildScript s1;
            readonly Func<IList<string>, int, BuildScript> s2a;
            readonly Func<int, BuildScript> s2b;
            public BindBuildScript(BuildScript s1, Func<IList<string>, int, BuildScript> s2)
            {
                this.s1 = s1;
                this.s2a = s2;
            }

            public BindBuildScript(BuildScript s1, Func<int, BuildScript> s2)
            {
                this.s1 = s1;
                this.s2b = s2;
            }

            public override int Run(IBuildActions actions, Action<string, bool> startCallback, Action<int, string, bool> exitCallBack)
            {
                int ret1;
                if (s2a != null)
                {
                    ret1 = s1.Run(actions, startCallback, exitCallBack, out var stdout1);
                    return s2a(stdout1, ret1).Run(actions, startCallback, exitCallBack);
                }

                ret1 = s1.Run(actions, startCallback, exitCallBack);
                return s2b(ret1).Run(actions, startCallback, exitCallBack);
            }

            public override int Run(IBuildActions actions, Action<string, bool> startCallback, Action<int, string, bool> exitCallBack, out IList<string> stdout)
            {
                var ret1 = s1.Run(actions, startCallback, exitCallBack, out var stdout1);
                var ret2 = (s2a != null ? s2a(stdout1, ret1) : s2b(ret1)).Run(actions, startCallback, exitCallBack, out var stdout2);
                var @out = new List<string>();
                @out.AddRange(stdout1);
                @out.AddRange(stdout2);
                stdout = @out;
                return ret2;
            }
        }

        /// <summary>
        /// Creates a simple build script that runs the specified exe.
        /// </summary>
        /// <param name="argumentsOpt">The arguments to the executable, or null.</param>
        /// <param name="silent">Whether the executable should run silently.</param>
        /// <param name="workingDirectory">The working directory (<code>null</code> for current directory).</param>
        /// <param name="environment">Additional environment variables.</param>
        public static BuildScript Create(string exe, string argumentsOpt, bool silent, string workingDirectory, IDictionary<string, string> environment) =>
            new BuildCommand(exe, argumentsOpt, silent, workingDirectory, environment);

        /// <summary>
        /// Creates a simple build script that runs the specified function.
        /// </summary>
        public static BuildScript Create(Func<IBuildActions, int> func) =>
            new ReturnBuildCommand(func);

        /// <summary>
        /// Creates a build script that runs <paramref name="s1"/>, followed by running the script
        /// produced by <paramref name="s2"/> on the exit code from <paramref name="s1"/>.
        /// </summary>
        public static BuildScript Bind(BuildScript s1, Func<int, BuildScript> s2) =>
            new BindBuildScript(s1, s2);

        /// <summary>
        /// Creates a build script that runs <paramref name="s1"/>, followed by running the script
        /// produced by <paramref name="s2"/> on the exit code and standard output from
        /// <paramref name="s1"/>.
        /// </summary>
        public static BuildScript Bind(BuildScript s1, Func<IList<string>, int, BuildScript> s2) =>
            new BindBuildScript(s1, s2);

        const int SuccessCode = 0;
        /// <summary>
        /// The empty build script that always returns exit code 0.
        /// </summary>
        public static readonly BuildScript Success = Create(actions => SuccessCode);

        const int FailureCode = 1;
        /// <summary>
        /// The empty build script that always returns exit code 1.
        /// </summary>
        public static readonly BuildScript Failure = Create(actions => FailureCode);

        static bool Succeeded(int i) => i == SuccessCode;

        public static BuildScript operator &(BuildScript s1, BuildScript s2) =>
            new BindBuildScript(s1, ret1 => Succeeded(ret1) ? s2 : Create(actions => ret1));

        public static BuildScript operator &(BuildScript s1, Func<BuildScript> s2) =>
            new BindBuildScript(s1, ret1 => Succeeded(ret1) ? s2() : Create(actions => ret1));

        public static BuildScript operator |(BuildScript s1, BuildScript s2) =>
            new BindBuildScript(s1, ret1 => Succeeded(ret1) ? Success : s2);

        public static BuildScript operator |(BuildScript s1, Func<BuildScript> s2) =>
            new BindBuildScript(s1, ret1 => Succeeded(ret1) ? Success : s2());

        /// <summary>
        /// Creates a build script that attempts to run the build script <paramref name="s"/>,
        /// always returning a successful exit code.
        /// </summary>
        public static BuildScript Try(BuildScript s) => s | Success;

        /// <summary>
        /// Creates a build script that deletes the given directory.
        /// </summary>
        public static BuildScript DeleteDirectory(string dir) =>
            Create(actions =>
            {
                if (string.IsNullOrEmpty(dir) || !actions.DirectoryExists(dir))
                    return FailureCode;

                try
                {
                    actions.DirectoryDelete(dir, true);
                }
                catch  // lgtm[cs/catch-of-all-exceptions]
                {
                    return FailureCode;
                }
                return SuccessCode;
            });

        /// <summary>
        /// Creates a build script that deletes the given file.
        /// </summary>
        public static BuildScript DeleteFile(string file) =>
            Create(actions =>
            {
                if (string.IsNullOrEmpty(file) || !actions.FileExists(file))
                    return FailureCode;

                try
                {
                    actions.FileDelete(file);
                }
                catch  // lgtm[cs/catch-of-all-exceptions]
                {
                    return FailureCode;
                }
                return SuccessCode;
            });
    }
}
