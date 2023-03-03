using Semmle.Autobuild.Shared;

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
        public CppAutobuilder(IBuildActions actions, CppAutobuildOptions options) : base(actions, options) { }

        public override BuildScript GetBuildScript()
        {
            if (Options.BuildCommand != null)
                return new BuildCommandRule((_, f) => f(null)).Analyse(this, false);

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
