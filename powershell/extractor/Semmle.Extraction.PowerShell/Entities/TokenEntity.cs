using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class TokenEntity : CachedEntity<(Token, Token)>
    {
        private TokenEntity(PowerShellContext cx, Token fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.ExtentToAnalysisLocation(Fragment.Extent);
        public Token Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.token(this, Fragment.HasError, Fragment.Kind, Fragment.Text, Fragment.TokenFlags);
            trapFile.token_location(this, TrapSuitableLocation);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";token");
        }

        internal static TokenEntity Create(PowerShellContext cx, Token fragment)
        {
            var init = (fragment, fragment);
            return TokenEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class TokenEntityFactory : CachedEntityFactory<(Token, Token), TokenEntity>
        {
            public static TokenEntityFactory Instance { get; } = new TokenEntityFactory();

            public override TokenEntity Create(PowerShellContext cx, (Token, Token) init) =>
                new TokenEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}