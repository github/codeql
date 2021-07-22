using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection.Metadata;

namespace Semmle.Extraction.CIL.Entities
{
    internal sealed class FunctionPointerType : Type, IParameterizable, ICustomModifierReceiver
    {
        private readonly MethodSignature<Type> signature;

        public FunctionPointerType(Context cx, MethodSignature<Type> signature) : base(cx)
        {
            this.signature = signature;
        }

        public override CilTypeKind Kind => CilTypeKind.FunctionPointer;

        public override string Name
        {
            get
            {
                using var id = new StringWriter();
                WriteName(
                    id.Write,
                    t => id.Write(t.Name),
                    signature
                );
                return id.ToString();
            }
        }

        public override Namespace? ContainingNamespace => Context.GlobalNamespace;

        public override Type? ContainingType => null;

        public override int ThisTypeParameterCount => throw new System.NotImplementedException();

        public override IEnumerable<Type> TypeParameters => throw new System.NotImplementedException();

        public override Type Construct(IEnumerable<Type> typeArguments) => throw new System.NotImplementedException();

        public override void WriteAssemblyPrefix(TextWriter trapFile) { }

        public override void WriteId(EscapingTextWriter trapFile, bool inContext)
        {
            WriteName(
                trapFile.Write,
                t => t.WriteId(trapFile, inContext),
                signature
            );
        }

        internal static void WriteName<TType>(Action<string> write, Action<TType> writeType, MethodSignature<TType> signature)
        {
            write("delegate* ");
            write(GetCallingConvention(signature.Header.CallingConvention));
            write("<");
            foreach (var pt in signature.ParameterTypes)
            {
                writeType(pt);
                write(",");
            }
            writeType(signature.ReturnType);
            write(">");
        }

        internal static string GetCallingConvention(SignatureCallingConvention callingConvention)
        {
            if (callingConvention == SignatureCallingConvention.Default)
            {
                return "managed";
            }

            if (callingConvention == SignatureCallingConvention.Unmanaged)
            {
                return "unmanaged";
            }

            return $"unmanaged[{callingConvention}]";
        }

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                foreach (var c in base.Contents)
                {
                    yield return c;
                }

                var retType = signature.ReturnType;
                if (retType is ModifiedType mt)
                {
                    retType = mt.Unmodified;
                    yield return Tuples.cil_custom_modifiers(this, mt.Modifier, mt.IsRequired);
                }
                if (retType is ByRefType byRefType)
                {
                    retType = byRefType.ElementType;
                    yield return Tuples.cil_type_annotation(this, TypeAnnotation.Ref);
                }
                yield return Tuples.cil_function_pointer_return_type(this, retType);

                yield return Tuples.cil_function_pointer_calling_conventions(this, signature.Header.CallingConvention);

                foreach (var p in Method.GetParameterExtractionProducts(signature.ParameterTypes, this, this, Context, 0))
                {
                    yield return p;
                }
            }
        }
    }
}
