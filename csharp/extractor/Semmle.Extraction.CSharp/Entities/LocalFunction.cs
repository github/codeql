using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    class LocalFunction : Method
    {
        LocalFunction(Context cx, IMethodSymbol init) : base(cx, init)
        {
        }

        public override IId Id
        {
            get
            {
                return new Key(tb =>
                {
                    tb.Append(Location);
                    if (symbol.IsGenericMethod && !IsSourceDeclaration)
                    {
                        tb.Append("<");
                        tb.BuildList(",", symbol.TypeArguments, (ta, tb0) => AddSignatureTypeToId(Context, tb0, symbol, ta));
                        tb.Append(">");
                    }

                    tb.Append(";localfunction");
                });
            }
        }

        public static new LocalFunction Create(Context cx, IMethodSymbol field) => LocalFunctionFactory.Instance.CreateEntity(cx, field);

        class LocalFunctionFactory : ICachedEntityFactory<IMethodSymbol, LocalFunction>
        {
            public static readonly LocalFunctionFactory Instance = new LocalFunctionFactory();

            public LocalFunction Create(Context cx, IMethodSymbol init) => new LocalFunction(cx, init);
        }

        public override void Populate()
        {
            PopulateMethod();
            var originalDefinition = IsSourceDeclaration ? this : Create(Context, symbol.OriginalDefinition);
            var returnType = Type.Create(Context, symbol.ReturnType);
            Context.Emit(Tuples.local_functions(this, symbol.Name, returnType, originalDefinition));
            ExtractRefReturn();
        }
    }
}
