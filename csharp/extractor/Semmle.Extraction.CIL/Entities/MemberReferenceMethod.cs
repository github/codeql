using System.Reflection.Metadata;
using System.Collections.Generic;
using System.Linq;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// This is a late-bound reference to a method.
    /// </summary>
    internal sealed class MemberReferenceMethod : Method
    {
        private readonly MemberReferenceHandle handle;
        private readonly MemberReference mr;
        private readonly Type declaringType;
        private readonly GenericContext parent;
        private readonly Method? sourceDeclaration;

        public MemberReferenceMethod(GenericContext gc, MemberReferenceHandle handle) : base(gc)
        {
            this.handle = handle;
            this.gc = gc;
            mr = Cx.MdReader.GetMemberReference(handle);

            signature = mr.DecodeMethodSignature(new SignatureDecoder(), gc);

            parent = (GenericContext)Cx.CreateGeneric(gc, mr.Parent);

            var declType = parent is Method parentMethod
                ? parentMethod.DeclaringType
                : parent as Type;

            if (declType is null)
                throw new InternalError("Parent context of method is not a type");

            declaringType = declType;
            nameLabel = Cx.GetString(mr.Name);

            var typeSourceDeclaration = declaringType.SourceDeclaration;
            sourceDeclaration = typeSourceDeclaration == declaringType ? (Method)this : typeSourceDeclaration.LookupMethod(mr.Name, mr.Signature);
        }

        private readonly string nameLabel;

        public override string NameLabel => nameLabel;

        public override bool Equals(object? obj)
        {
            return obj is MemberReferenceMethod method && handle.Equals(method.handle);
        }

        public override int GetHashCode()
        {
            return handle.GetHashCode();
        }

        public override Method? SourceDeclaration => sourceDeclaration;

        public override bool IsStatic => !signature.Header.IsInstance;

        public override Type DeclaringType => declaringType;

        public override string Name => Cx.ShortName(mr.Name);

        public override IEnumerable<Type> TypeParameters => parent.TypeParameters.Concat(gc.TypeParameters);

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                genericParams = new MethodTypeParameter[signature.GenericParameterCount];
                for (var p = 0; p < genericParams.Length; ++p)
                    genericParams[p] = Cx.Populate(new MethodTypeParameter(this, this, p));

                foreach (var p in genericParams)
                    yield return p;

                var typeSignature = mr.DecodeMethodSignature(Cx.TypeSignatureDecoder, this);

                var parameters = GetParameterExtractionProducts(typeSignature.ParameterTypes).ToArray();
                Parameters = parameters.OfType<Parameter>().ToArray();
                foreach (var p in parameters) yield return p;

                foreach (var f in PopulateFlags) yield return f;

                foreach (var m in GetMethodExtractionProducts(Name, DeclaringType, typeSignature.ReturnType))
                {
                    yield return m;
                }

                if (SourceDeclaration != null)
                    yield return Tuples.cil_method_source_declaration(this, SourceDeclaration);
            }
        }
    }
}
