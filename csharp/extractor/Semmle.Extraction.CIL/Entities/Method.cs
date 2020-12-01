using System;
using System.Reflection.Metadata;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using Semmle.Util;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// A method entity.
    /// </summary>
    internal abstract class Method : TypeContainer, IMember
    {
        protected MethodTypeParameter[]? genericParams;
        protected GenericContext gc;
        protected MethodSignature<ITypeSignature> signature;

        protected Method(GenericContext gc) : base(gc.Cx)
        {
            this.gc = gc;
        }

        public override IEnumerable<Type> TypeParameters => gc.TypeParameters.Concat(DeclaringType.TypeParameters);

        public override IEnumerable<Type> MethodParameters =>
            genericParams == null ? gc.MethodParameters : gc.MethodParameters.Concat(genericParams);

        public int GenericParameterCount => signature.GenericParameterCount;

        public virtual Method? SourceDeclaration => this;

        public abstract Type DeclaringType { get; }
        public abstract string Name { get; }

        public virtual IList<LocalVariable>? LocalVariables => throw new NotImplementedException();
        public IList<Parameter>? Parameters { get; protected set; }

        public override void WriteId(TextWriter trapFile) => WriteMethodId(trapFile, DeclaringType, NameLabel);

        public abstract string NameLabel { get; }

        protected internal void WriteMethodId(TextWriter trapFile, Type parent, string methodName)
        {
            signature.ReturnType.WriteId(trapFile, this);
            trapFile.Write(' ');
            parent.WriteId(trapFile);
            trapFile.Write('.');
            trapFile.Write(methodName);

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
            trapFile.Write(')');
        }

        public override string IdSuffix => ";cil-method";

        protected IEnumerable<IExtractionProduct> PopulateFlags
        {
            get
            {
                if (IsStatic)
                    yield return Tuples.cil_static(this);
            }
        }

        public abstract bool IsStatic { get; }

        protected IEnumerable<Parameter> MakeParameters(IEnumerable<Type> parameterTypes)
        {
            var i = 0;

            if (!IsStatic)
            {
                yield return Cx.Populate(new Parameter(Cx, this, i++, DeclaringType));
            }

            foreach (var p in parameterTypes)
                yield return Cx.Populate(new Parameter(Cx, this, i++, p));
        }
    }
}
