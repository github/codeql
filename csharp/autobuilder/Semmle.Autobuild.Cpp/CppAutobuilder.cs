using Semmle.Autobuild.Shared;
using Semmle.Util;

namespace Semmle.Autobuild.Cpp
{
    /// <summary>
    /// Encapsulates C++ build options.
    /// </summary>
    public class CppAutobuildOptions : AutobuildOptionsShared
    {
        public override Language Language => Language.Cpp;


        /// <summary>
        /// Reads options from environment variables.
        /// Throws ArgumentOutOfRangeException for invalid arguments.
        /// </summary>
        public CppAutobuildOptions(IBuildActions actions) : base(actions)
        {
        }
    }

    public class CppAutobuilder : Autobuilder<CppAutobuildOptions>
    {
        public CppAutobuilder(IBuildActions actions, CppAutobuildOptions options) : base(actions, options, new DiagnosticClassifier()) { }

        public override BuildScript GetBuildScript()
        {
            return
                // First try MSBuild
                new MsBuildRule().Analyse(this, true) |
                // Then look for a script that might be a build script
                (() => new BuildCommandAutoRule((_, f) => f(null)).Analyse(this, true)) |
                // All attempts failed: print message
                AutobuildFailure();
        }
    }
}
