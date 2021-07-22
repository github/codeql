using System.Reflection.Metadata;
using System.Collections.Generic;
using System.IO;
using System.Diagnostics.CodeAnalysis;
using System.Linq;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// A type.
    /// </summary>
    internal abstract class Type : TypeContainer, IMember
    {
        internal const string AssemblyTypeNameSeparator = "::";
        internal const string PrimitiveTypePrefix = "builtin" + AssemblyTypeNameSeparator + "System.";

        protected Type(Context cx) : base(cx) { }

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
        public abstract void WriteId(EscapingTextWriter trapFile, bool inContext);

        public sealed override void WriteId(EscapingTextWriter trapFile)
        {
            WriteId(trapFile, false);
            trapFile.Write(";cil-type");
        }

        /// <summary>
        /// Returns the friendly qualified name of types, such as
        /// ``"System.Collection.Generic.List`1"`` or
        /// ``"System.Collection.Generic.List<System.Int32>"``.
        ///
        /// Note that method/type generic type parameters never show up in the returned name.
        /// </summary>
        public string GetQualifiedName()
        {
            using var writer = new EscapingTextWriter();
            WriteId(writer, false);
            var name = writer.ToString();
            return name.Substring(name.IndexOf(AssemblyTypeNameSeparator) + 2).
                Replace(";namespace", "").
                Replace(";cil-type", "");
        }

        public abstract CilTypeKind Kind { get; }

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return Tuples.cil_type(this, Name, Kind, Parent, SourceDeclaration);
            }
        }

        public abstract string Name { get; }

        public abstract Namespace? ContainingNamespace { get; }

        public abstract Type? ContainingType { get; }

        public virtual TypeContainer Parent => (TypeContainer?)ContainingType ?? ContainingNamespace!;

        public abstract Type Construct(IEnumerable<Type> typeArguments);

        /// <summary>
        /// Returns the type arguments of constructed types. For non-constructed types it returns an
        /// empty collection.
        /// </summary>
        public virtual IEnumerable<Type> ThisTypeArguments
        {
            get
            {
                yield break;
            }
        }

        /// <summary>
        /// The number of type parameters for non-constructed generic types, the number of type arguments
        /// for constructed types, or 0.
        /// </summary>
        public abstract int ThisTypeParameterCount { get; }

        /// <summary>
        /// The total number of type parameters/type arguments (including parent types).
        /// This is used for internal consistency checking only.
        /// </summary>
        public int TotalTypeParametersCount =>
            ThisTypeParameterCount + (ContainingType?.TotalTypeParametersCount ?? 0);

        /// <summary>
        /// Returns all bound/unbound generic arguments of a constructed/unbound generic type.
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
                if (ContainingType is not null)
                {
                    foreach (var t in ContainingType.GenericArguments)
                        yield return t;
                }

                foreach (var t in ThisGenericArguments)
                    yield return t;
            }
        }

        public virtual Type SourceDeclaration => this;

        public static void WritePrimitiveTypeId(TextWriter trapFile, string name)
        {
            trapFile.Write(PrimitiveTypePrefix);
            trapFile.Write(name);
        }

        private static readonly Dictionary<string, PrimitiveTypeCode> primitiveTypeCodeMapping = new Dictionary<string, PrimitiveTypeCode>
        {
            {"Boolean", PrimitiveTypeCode.Boolean},
            {"Object", PrimitiveTypeCode.Object},
            {"Byte", PrimitiveTypeCode.Byte},
            {"SByte", PrimitiveTypeCode.SByte},
            {"Int16", PrimitiveTypeCode.Int16},
            {"UInt16", PrimitiveTypeCode.UInt16},
            {"Int32", PrimitiveTypeCode.Int32},
            {"UInt32", PrimitiveTypeCode.UInt32},
            {"Int64", PrimitiveTypeCode.Int64},
            {"UInt64", PrimitiveTypeCode.UInt64},
            {"Single", PrimitiveTypeCode.Single},
            {"Double", PrimitiveTypeCode.Double},
            {"String", PrimitiveTypeCode.String},
            {"Void", PrimitiveTypeCode.Void},
            {"IntPtr", PrimitiveTypeCode.IntPtr},
            {"UIntPtr", PrimitiveTypeCode.UIntPtr},
            {"Char", PrimitiveTypeCode.Char},
            {"TypedReference", PrimitiveTypeCode.TypedReference}
        };

        /// <summary>
        /// Gets the primitive type corresponding to this type, if possible.
        /// </summary>
        /// <param name="t">The resulting primitive type, or null.</param>
        /// <returns>True if this type is a primitive type.</returns>
        public bool TryGetPrimitiveType([NotNullWhen(true)] out PrimitiveType? t)
        {
            if (TryGetPrimitiveTypeCode(out var code))
            {
                t = Context.Create(code);
                return true;
            }

            t = null;
            return false;
        }

        private bool TryGetPrimitiveTypeCode(out PrimitiveTypeCode code)
        {
            if (ContainingType is null &&
                ContainingNamespace?.Name == Context.SystemNamespace.Name &&
                primitiveTypeCodeMapping.TryGetValue(Name, out code))
            {
                return true;
            }

            code = default;
            return false;
        }

        protected internal bool IsPrimitiveType => TryGetPrimitiveTypeCode(out _);

        public sealed override IEnumerable<Type> MethodParameters => Enumerable.Empty<Type>();

        public static Type DecodeType(IGenericContext gc, TypeSpecificationHandle handle) =>
            gc.Context.MdReader.GetTypeSpecification(handle).DecodeSignature(gc.Context.TypeSignatureDecoder, gc);
    }
}
