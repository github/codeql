using System.Reflection.Metadata;
using System.Collections.Generic;
using Semmle.Util;
using System.IO;
using System.Diagnostics.CodeAnalysis;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// A type.
    /// </summary>
    public abstract class Type : TypeContainer, IMember, IType
    {
        public override string IdSuffix => ";cil-type";

        public sealed override void WriteId(TextWriter trapFile) => WriteId(trapFile, false);

        /// <summary>
        /// Find the method in this type matching the name and signature.
        /// </summary>
        /// <param name="methodName">The handle to the name.</param>
        /// <param name="signature">
        /// The handle to the signature. Note that comparing handles is a valid
        /// shortcut to comparing the signature bytes since handles are unique.
        /// </param>
        /// <returns>The method, or 'null' if not found or not supported.</returns>
        internal virtual Method? LookupMethod(StringHandle methodName, BlobHandle signature)
        {
            return null;
        }

        public IEnumerable<Type> TypeArguments
        {
            get
            {
                if (ContainingType != null)
                {
                    foreach (var t in ContainingType.TypeArguments)
                        yield return t;
                }
                foreach (var t in ThisTypeArguments)
                    yield return t;

            }
        }

        public virtual IEnumerable<Type> ThisTypeArguments
        {
            get
            {
                yield break;
            }
        }

        /// <summary>
        /// Writes the assembly identifier of this type.
        /// </summary>
        public abstract void WriteAssemblyPrefix(TextWriter trapFile);

        /// <summary>
        /// Writes the ID part to be used in a method ID.
        /// </summary>
        /// <param name="inContext">
        /// Whether we should output the context prefix of type parameters.
        /// (This is to avoid infinite recursion generating a method ID that returns a
        /// type parameter.)
        /// </param>
        public abstract void WriteId(TextWriter trapFile, bool inContext);

        public void GetId(TextWriter trapFile, bool inContext)
        {
            if (inContext)
                WriteId(trapFile, true);
            else
                WriteId(trapFile);
        }

        protected Type(Context cx) : base(cx) { }

        public abstract CilTypeKind Kind
        {
            get;
        }

        public virtual TypeContainer Parent => (TypeContainer?)ContainingType ?? Namespace!;

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return Tuples.cil_type(this, Name, Kind, Parent, SourceDeclaration);
            }
        }

        /// <summary>
        /// Whether this type is visible outside the current assembly.
        /// </summary>
        public virtual bool IsVisible => true;

        public abstract string Name { get; }

        public abstract Namespace? Namespace { get; }

        public abstract Type? ContainingType { get; }

        public abstract Type Construct(IEnumerable<Type> typeArguments);

        /// <summary>
        /// The number of type arguments, or 0 if this isn't generic.
        /// The containing type may also have type arguments.
        /// </summary>
        public abstract int ThisTypeParameters { get; }

        /// <summary>
        /// The total number of type parameters (including parent types).
        /// This is used for internal consistency checking only.
        /// </summary>
        public int TotalTypeParametersCheck =>
            ContainingType == null ? ThisTypeParameters : ThisTypeParameters + ContainingType.TotalTypeParametersCheck;

        /// <summary>
        /// Returns all bound/unbound generic arguments
        /// of a constructed/unbound generic type.
        /// </summary>
        public virtual IEnumerable<Type> ThisGenericArguments
        {
            get
            {
                yield break;
            }
        }

        public virtual IEnumerable<Type> GenericArguments
        {
            get
            {
                if (ContainingType != null)
                {
                    foreach (var t in ContainingType.GenericArguments)
                        yield return t;
                }
                foreach (var t in ThisGenericArguments)
                    yield return t;
            }
        }

        public virtual Type SourceDeclaration => this;

        public void PrimitiveTypeId(TextWriter trapFile)
        {
            trapFile.Write("builtin:");
            trapFile.Write(Name);
        }

        /// <summary>
        /// Gets the primitive type corresponding to this type, if possible.
        /// </summary>
        /// <param name="t">The resulting primitive type, or null.</param>
        /// <returns>True if this type is a primitive type.</returns>
        public bool TryGetPrimitiveType([NotNullWhen(true)] out PrimitiveType? t)
        {
            if (TryGetPrimitiveTypeCode(out var code))
            {
                t = Cx.Create(code);
                return true;
            }

            t = null;
            return false;
        }

        private bool TryGetPrimitiveTypeCode(out PrimitiveTypeCode code)
        {
            if (ContainingType == null && Namespace?.Name == Cx.SystemNamespace.Name)
            {
                switch (Name)
                {
                    case "Boolean":
                        code = PrimitiveTypeCode.Boolean;
                        return true;
                    case "Object":
                        code = PrimitiveTypeCode.Object;
                        return true;
                    case "Byte":
                        code = PrimitiveTypeCode.Byte;
                        return true;
                    case "SByte":
                        code = PrimitiveTypeCode.SByte;
                        return true;
                    case "Int16":
                        code = PrimitiveTypeCode.Int16;
                        return true;
                    case "UInt16":
                        code = PrimitiveTypeCode.UInt16;
                        return true;
                    case "Int32":
                        code = PrimitiveTypeCode.Int32;
                        return true;
                    case "UInt32":
                        code = PrimitiveTypeCode.UInt32;
                        return true;
                    case "Int64":
                        code = PrimitiveTypeCode.Int64;
                        return true;
                    case "UInt64":
                        code = PrimitiveTypeCode.UInt64;
                        return true;
                    case "Single":
                        code = PrimitiveTypeCode.Single;
                        return true;
                    case "Double":
                        code = PrimitiveTypeCode.Double;
                        return true;
                    case "String":
                        code = PrimitiveTypeCode.String;
                        return true;
                    case "Void":
                        code = PrimitiveTypeCode.Void;
                        return true;
                    case "IntPtr":
                        code = PrimitiveTypeCode.IntPtr;
                        return true;
                    case "UIntPtr":
                        code = PrimitiveTypeCode.UIntPtr;
                        return true;
                    case "Char":
                        code = PrimitiveTypeCode.Char;
                        return true;
                    case "TypedReference":
                        code = PrimitiveTypeCode.TypedReference;
                        return true;
                }
            }

            code = default(PrimitiveTypeCode);
            return false;
        }

        protected bool IsPrimitiveType => TryGetPrimitiveTypeCode(out _);

        public static Type DecodeType(GenericContext gc, TypeSpecificationHandle handle) =>
            gc.Cx.MdReader.GetTypeSpecification(handle).DecodeSignature(gc.Cx.TypeSignatureDecoder, gc);
    }
}
