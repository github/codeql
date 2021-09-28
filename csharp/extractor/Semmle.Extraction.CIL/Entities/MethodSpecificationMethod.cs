using System;
using System.Collections.Immutable;
using System.Reflection.Metadata;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using Semmle.Util;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// A constructed method.
    /// </summary>
    internal sealed class MethodSpecificationMethod : Method
    {
        private readonly MethodSpecificationHandle handle;
        private readonly MethodSpecification ms;
        private readonly Method unboundMethod;
        private readonly ImmutableArray<Type> typeParams;

        public MethodSpecificationMethod(IGenericContext gc, MethodSpecificationHandle handle) : base(gc)
        {
            this.handle = handle;
            ms = Context.MdReader.GetMethodSpecification(handle);
            typeParams = ms.DecodeSignature(Context.TypeSignatureDecoder, gc);
            unboundMethod = (Method)Context.CreateGeneric(gc, ms.Method);
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            unboundMethod.WriteId(trapFile);
            trapFile.Write('<');
            var index = 0;
            foreach (var param in typeParams)
            {
                trapFile.WriteSeparator(",", ref index);
                trapFile.WriteSubId(param);
            }
            trapFile.Write('>');
        }

        public override string NameLabel => throw new NotImplementedException();

        public override bool Equals(object? obj)
        {
            return obj is MethodSpecificationMethod method && handle.Equals(method.handle) && typeParams.SequenceEqual(method.typeParams);
        }

        public override int GetHashCode() => handle.GetHashCode() * 11 + typeParams.SequenceHash();

        public override Method SourceDeclaration => unboundMethod;

        public override Type DeclaringType => unboundMethod.DeclaringType;

        public override string Name => unboundMethod.Name;

        public override bool IsStatic => unboundMethod.IsStatic;

        public override IEnumerable<Type> MethodParameters => typeParams;

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                MethodSignature<Type> constructedTypeSignature;
                switch (ms.Method.Kind)
                {
                    case HandleKind.MemberReference:
                        var mr = Context.MdReader.GetMemberReference((MemberReferenceHandle)ms.Method);
                        constructedTypeSignature = mr.DecodeMethodSignature(Context.TypeSignatureDecoder, this);
                        break;
                    case HandleKind.MethodDefinition:
                        var md = Context.MdReader.GetMethodDefinition((MethodDefinitionHandle)ms.Method);
                        constructedTypeSignature = md.DecodeSignature(Context.TypeSignatureDecoder, this);
                        break;
                    default:
                        throw new InternalError($"Unexpected constructed method handle kind {ms.Method.Kind}");
                }

                var parameters = GetParameterExtractionProducts(constructedTypeSignature.ParameterTypes).ToArray();
                Parameters = parameters.OfType<Parameter>().ToArray();
                foreach (var p in parameters)
                    yield return p;

                foreach (var f in PopulateFlags)
                    yield return f;

                foreach (var m in GetMethodExtractionProducts(Name, DeclaringType, constructedTypeSignature.ReturnType))
                {
                    yield return m;
                }

                yield return Tuples.cil_method_source_declaration(this, SourceDeclaration);

                if (typeParams.Length != unboundMethod.GenericParameterCount)
                    throw new InternalError("Method type parameter mismatch");

                for (var p = 0; p < typeParams.Length; ++p)
                {
                    yield return Tuples.cil_type_argument(this, p, typeParams[p]);
                }
            }
        }
    }
}
