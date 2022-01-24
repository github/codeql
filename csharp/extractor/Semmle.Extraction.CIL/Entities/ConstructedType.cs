using System;
using System.Linq;
using System.Collections.Generic;
using System.IO;
using Semmle.Util;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// A constructed type.
    /// </summary>
    internal sealed class ConstructedType : Type
    {
        private readonly Type unboundGenericType;

        // Either null or notEmpty
        private readonly Type[]? thisTypeArguments;

        private readonly Type? containingType;
        private readonly NamedTypeIdWriter idWriter;

        public ConstructedType(Context cx, Type unboundType, IEnumerable<Type> typeArguments) : base(cx)
        {
            idWriter = new NamedTypeIdWriter(this);
            var suppliedArgs = typeArguments.Count();
            if (suppliedArgs != unboundType.TotalTypeParametersCount)
                throw new InternalError("Unexpected number of type arguments in ConstructedType");

            unboundGenericType = unboundType;
            var thisParams = unboundType.ThisTypeParameterCount;

            if (typeArguments.Count() == thisParams)
            {
                containingType = unboundType.ContainingType;
                thisTypeArguments = typeArguments.ToArray();
            }
            else if (thisParams == 0)
            {
                // all type arguments belong to containing type
                containingType = unboundType.ContainingType!.Construct(typeArguments);
            }
            else
            {
                // some type arguments belong to containing type
                var parentParams = suppliedArgs - thisParams;
                containingType = unboundType.ContainingType!.Construct(typeArguments.Take(parentParams));
                thisTypeArguments = typeArguments.Skip(parentParams).ToArray();
            }
        }

        public override bool Equals(object? obj)
        {
            if (obj is ConstructedType t && Equals(unboundGenericType, t.unboundGenericType) && Equals(containingType, t.containingType))
            {
                if (thisTypeArguments is null)
                    return t.thisTypeArguments is null;
                if (!(t.thisTypeArguments is null))
                    return thisTypeArguments.SequenceEqual(t.thisTypeArguments);
            }
            return false;
        }

        public override int GetHashCode()
        {
            var h = unboundGenericType.GetHashCode();
            h = 13 * h + (containingType is null ? 0 : containingType.GetHashCode());
            if (!(thisTypeArguments is null))
                h = h * 13 + thisTypeArguments.SequenceHash();
            return h;
        }

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                foreach (var c in base.Contents)
                    yield return c;

                var i = 0;
                foreach (var type in ThisTypeArguments)
                {
                    yield return type;
                    yield return Tuples.cil_type_argument(this, i++, type);
                }
            }
        }

        public override Type SourceDeclaration => unboundGenericType;

        public override Type? ContainingType => containingType;

        public override string Name => unboundGenericType.Name;

        public override Namespace ContainingNamespace => unboundGenericType.ContainingNamespace!;

        public override CilTypeKind Kind => unboundGenericType.Kind;

        public override Type Construct(IEnumerable<Type> typeArguments)
        {
            throw new NotImplementedException();
        }

        public override void WriteId(EscapingTextWriter trapFile, bool inContext)
        {
            idWriter.WriteId(trapFile, inContext);
        }

        public override void WriteAssemblyPrefix(TextWriter trapFile) => unboundGenericType.WriteAssemblyPrefix(trapFile);

        public override int ThisTypeParameterCount => thisTypeArguments?.Length ?? 0;

        public override IEnumerable<Type> TypeParameters => GenericArguments;

        public override IEnumerable<Type> ThisTypeArguments => thisTypeArguments.EnumerateNull();

        public override IEnumerable<Type> ThisGenericArguments => thisTypeArguments.EnumerateNull();
    }
}
