using System.IO;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    class LocalVariable : CachedSymbol<ISymbol>
    {
        LocalVariable(Context cx, ISymbol init) : base(cx, init) { }

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.WriteSubId(Location);
            trapFile.Write('_');
            trapFile.Write(symbol.Name);
            trapFile.Write(";localvar");
        }

        public override void Populate(TextWriter trapFile)
        {
            if (symbol is ILocalSymbol local)
            {
                PopulateNullability(trapFile, local.GetAnnotatedType());
                if (local.IsRef)
                    trapFile.type_annotation(this, Kinds.TypeAnnotation.Ref);
            }

            var kind = symbol is ILocalSymbol l ? (l.IsRef ? 3 : l.IsConst ? 2 : 1) : 1;
            trapFile.localvars(this, kind, symbol.Name);

            trapFile.localvar_location(this, Location);

            DefineConstantValue(trapFile);
        }

        public void PopulateInfo(Expression parent, bool isVar)
        {
            var type = symbol is ILocalSymbol l ? Type.Create(Context, l.GetAnnotatedType()) : parent.Type;
            Context.TrapWriter.Writer.localvar_info(this, isVar ? 1 : 0, type.Type.TypeRef, parent);
        }

        public static LocalVariable Create(Context cx, ISymbol local)
        {
            return LocalVariableFactory.Instance.CreateEntity(cx, local);
        }

        void DefineConstantValue(TextWriter trapFile)
        {
            var local = symbol as ILocalSymbol;
            if (local != null && local.HasConstantValue)
            {
                trapFile.constant_value(this, Expression.ValueAsString(local.ConstantValue));
            }
        }

        class LocalVariableFactory : ICachedEntityFactory<ISymbol, LocalVariable>
        {
            public static readonly LocalVariableFactory Instance = new LocalVariableFactory();

            public LocalVariable Create(Context cx, ISymbol init) => new LocalVariable(cx, init);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NeedsLabel;
    }
}
