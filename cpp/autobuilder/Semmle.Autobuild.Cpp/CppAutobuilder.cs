using Semmle.Autobuild.Shared;

namespace Semmle.Autobuild.Cpp
{
    public class CppAutobuilder : Autobuilder
    {
        public CppAutobuilder(IBuildActions actions, AutobuildOptions options) : base(actions, options) { }

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
