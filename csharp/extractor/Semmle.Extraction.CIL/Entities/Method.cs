using System;
using System.Reflection.Metadata;
using System.Collections.Generic;
using System.Linq;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// A method entity.
    /// </summary>
    internal abstract class Method : TypeContainer, IMember, ICustomModifierReceiver, IParameterizable
    {
        protected MethodTypeParameter[]? genericParams;
        protected IGenericContext gc;
        protected MethodSignature<ITypeSignature> signature;

        protected Method(IGenericContext gc) : base(gc.Context)
        {
            this.gc = gc;
        }

        public ITypeSignature ReturnType => signature.ReturnType;

        public override IEnumerable<Type> TypeParameters => gc.TypeParameters.Concat(DeclaringType.TypeParameters);

        public override IEnumerable<Type> MethodParameters =>
            genericParams is null ? gc.MethodParameters : gc.MethodParameters.Concat(genericParams);

        public int GenericParameterCount => signature.GenericParameterCount;

        public virtual Method? SourceDeclaration => this;

        public abstract Type DeclaringType { get; }
        public abstract string Name { get; }

        public virtual IList<LocalVariable>? LocalVariables => throw new NotImplementedException();
        public IList<Parameter>? Parameters { get; protected set; }

        public abstract string NameLabel { get; }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            signature.ReturnType.WriteId(trapFile, this);
            trapFile.Write(' ');
            DeclaringType.WriteId(trapFile);
            trapFile.Write('.');
            trapFile.Write(NameLabel);

            if (signature.GenericParameterCount > 0)
            {
                trapFile.Write('`');
                trapFile.Write(signature.GenericParameterCount);
            }
            trapFile.Write('(');
            var index = 0;
            foreach (var param in signature.ParameterTypes)
            {
                trapFile.WriteSeparator(",", ref index);
                param.WriteId(trapFile, this);
            }
            trapFile.Write(");cil-method");
        }

        protected IEnumerable<IExtractionProduct> PopulateFlags
        {
            get
            {
                if (IsStatic)
                    yield return Tuples.cil_static(this);
            }
        }

        public abstract bool IsStatic { get; }

        protected IEnumerable<IExtractionProduct> GetParameterExtractionProducts(IEnumerable<Type> parameterTypes)
        {
            var i = 0;

            if (!IsStatic)
            {
                yield return Context.Populate(new Parameter(Context, this, i++, DeclaringType));
            }

            foreach (var p in GetParameterExtractionProducts(parameterTypes, this, this, Context, i))
            {
                yield return p;
            }
        }

        internal static IEnumerable<IExtractionProduct> GetParameterExtractionProducts(IEnumerable<Type> parameterTypes, IParameterizable parameterizable, ICustomModifierReceiver receiver, Context cx, int firstChildIndex)
        {
            var i = firstChildIndex;
            foreach (var p in parameterTypes)
            {
                var t = p;
                if (t is ModifiedType mt)
                {
                    t = mt.Unmodified;
                    yield return Tuples.cil_custom_modifiers(receiver, mt.Modifier, mt.IsRequired);
                }
                if (t is ByRefType brt)
                {
                    t = brt.ElementType;
                    var parameter = cx.Populate(new Parameter(cx, parameterizable, i++, t));
                    yield return parameter;
                    yield return Tuples.cil_type_annotation(parameter, TypeAnnotation.Ref);
                }
                else
                {
                    yield return cx.Populate(new Parameter(cx, parameterizable, i++, t));
                }
            }
        }

        protected IEnumerable<IExtractionProduct> GetMethodExtractionProducts(string name, Type declaringType, Type returnType)
        {
            var t = returnType;
            if (t is ModifiedType mt)
            {
                t = mt.Unmodified;
                yield return Tuples.cil_custom_modifiers(this, mt.Modifier, mt.IsRequired);
            }
            if (t is ByRefType brt)
            {
                t = brt.ElementType;
                yield return Tuples.cil_type_annotation(this, TypeAnnotation.Ref);
            }
            yield return Tuples.cil_method(this, name, declaringType, t);
        }
    }
}
