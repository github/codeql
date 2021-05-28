using System;
using System.Reflection.Metadata;
using System.Linq;
using System.Collections.Generic;
using System.Reflection;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    internal abstract class TypeParameter : Type
    {
        protected readonly IGenericContext gc;

        protected TypeParameter(IGenericContext gc) : base(gc.Context)
        {
            this.gc = gc;
        }

        public override Namespace? ContainingNamespace => null;

        public override Type? ContainingType => null;

        public override int ThisTypeParameterCount => 0;

        public override CilTypeKind Kind => CilTypeKind.TypeParameter;

        public override void WriteAssemblyPrefix(TextWriter trapFile) => throw new NotImplementedException();

        public override Type Construct(IEnumerable<Type> typeArguments) => throw new InternalError("Attempt to construct a type parameter");

        public IEnumerable<IExtractionProduct> PopulateHandle(GenericParameterHandle parameterHandle)
        {
            if (!parameterHandle.IsNil)
            {
                var tp = Context.MdReader.GetGenericParameter(parameterHandle);

                if (tp.Attributes.HasFlag(GenericParameterAttributes.Contravariant))
                    yield return Tuples.cil_typeparam_contravariant(this);
                if (tp.Attributes.HasFlag(GenericParameterAttributes.Covariant))
                    yield return Tuples.cil_typeparam_covariant(this);
                if (tp.Attributes.HasFlag(GenericParameterAttributes.DefaultConstructorConstraint))
                    yield return Tuples.cil_typeparam_new(this);
                if (tp.Attributes.HasFlag(GenericParameterAttributes.ReferenceTypeConstraint))
                    yield return Tuples.cil_typeparam_class(this);
                if (tp.Attributes.HasFlag(GenericParameterAttributes.NotNullableValueTypeConstraint))
                    yield return Tuples.cil_typeparam_struct(this);

                foreach (var constraint in tp.GetConstraints().Select(h => Context.MdReader.GetGenericParameterConstraint(h)))
                {
                    var t = (Type)Context.CreateGeneric(this.gc, constraint.Type);
                    yield return t;
                    yield return Tuples.cil_typeparam_constraint(this, t);
                }
            }
        }
    }
}
