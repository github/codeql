using System.IO;
using System.Linq;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace Semmle.Extraction.CSharp.Entities
{
    /// <summary>
    /// Synthetic parameter for extension methods declared using the extension syntax.
    /// That is, we add a synthetic parameter `s` to `IsValid` in the following example:
    /// extension(string s) {
    ///   public bool IsValid() { ... }
    /// }
    ///
    /// Note, that we use the characteristics of the parameter of the extension type
    /// to populate the database.
    /// </summary>
    internal class SyntheticExtensionParameter : FreshEntity, IParameter
    {
        private Method ExtensionMethod { get; }
        private IParameterSymbol ExtensionParameter { get; }
        private SyntheticExtensionParameter Original { get; }

        private SyntheticExtensionParameter(Context cx, Method method, IParameterSymbol parameter, SyntheticExtensionParameter? original) : base(cx)
        {
            ExtensionMethod = method;
            ExtensionParameter = parameter;
            Original = original ?? this;
        }

        private static int Ordinal => 0;

        private string Name => ExtensionParameter.Name;

        private bool IsSourceDeclaration => ExtensionMethod.Symbol.IsSourceDeclaration();

        protected override void Populate(TextWriter trapFile)
        {
            PopulateNullability(trapFile, ExtensionParameter.GetAnnotatedType());
            PopulateRefKind(trapFile, ExtensionParameter.RefKind);

            var type = Type.Create(Context, ExtensionParameter.Type);
            var kind = ExtensionParameter.GetParameterKind();
            trapFile.@params(this, Name, type.TypeRef, Ordinal, kind, ExtensionMethod, Original);

            if (Context.OnlyScaffold)
            {
                return;
            }

            if (Context.ExtractLocation(ExtensionParameter))
            {
                var locations = Context.GetLocations(ExtensionParameter);
                WriteLocationsToTrap(trapFile.param_location, this, locations);
            }

            if (IsSourceDeclaration)
            {
                foreach (var syntax in ExtensionParameter.DeclaringSyntaxReferences
                    .Select(d => d.GetSyntax())
                    .OfType<ParameterSyntax>()
                    .Where(s => s.Type is not null))
                {
                    TypeMention.Create(Context, syntax.Type!, this, type);
                }
            }
        }

        public static SyntheticExtensionParameter Create(Context cx, Method method, IParameterSymbol parameter, SyntheticExtensionParameter? original)
        {
            var p = new SyntheticExtensionParameter(cx, method, parameter, original);
            p.TryPopulate();
            return p;
        }
    }

}
