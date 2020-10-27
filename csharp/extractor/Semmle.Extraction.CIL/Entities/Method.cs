using System;
using System.Collections.Immutable;
using System.Reflection.Metadata;
using System.Collections.Generic;
using System.Reflection;
using System.Linq;
using System.Reflection.Metadata.Ecma335;
using System.IO;
using Semmle.Util;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// A method entity.
    /// </summary>
    internal interface IMethod : IMember
    {
    }

    /// <summary>
    /// A method entity.
    /// </summary>
    internal abstract class Method : TypeContainer, IMethod
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

    /// <summary>
    /// A method implementation entity.
    /// </summary>
    internal interface IMethodImplementation : IExtractedEntity
    {
    }

    /// <summary>
    /// A method implementation entity.
    /// In the database, the same method could in principle have multiple implementations.
    /// </summary>
    internal class MethodImplementation : UnlabelledEntity, IMethodImplementation
    {
        private readonly Method m;

        public MethodImplementation(Method m) : base(m.Cx)
        {
            this.m = m;
        }

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return Tuples.cil_method_implementation(this, m, Cx.Assembly);
            }
        }
    }


    /// <summary>
    /// A definition method - a method defined in the current assembly.
    /// </summary>
    internal sealed class DefinitionMethod : Method, IMember
    {
        private readonly Handle handle;
        private readonly MethodDefinition md;
        private readonly PDB.IMethod? methodDebugInformation;
        private readonly Type declaringType;

        private readonly string name;
        private LocalVariable[]? locals;

        public MethodImplementation? Implementation { get; private set; }

        public override IList<LocalVariable>? LocalVariables => locals;

        public DefinitionMethod(GenericContext gc, MethodDefinitionHandle handle) : base(gc)
        {
            md = Cx.MdReader.GetMethodDefinition(handle);
            this.gc = gc;
            this.handle = handle;
            name = Cx.GetString(md.Name);

            declaringType = (Type)Cx.CreateGeneric(this, md.GetDeclaringType());

            signature = md.DecodeSignature(new SignatureDecoder(), this);

            methodDebugInformation = Cx.GetMethodDebugInformation(handle);
        }

        public override bool Equals(object? obj)
        {
            return obj is DefinitionMethod method && handle.Equals(method.handle);
        }

        public override int GetHashCode() => handle.GetHashCode();

        public override bool IsStatic => !signature.Header.IsInstance;

        public override Type DeclaringType => declaringType;

        public override string Name => Cx.ShortName(md.Name);

        public override string NameLabel => name;

        /// <summary>
        /// Holds if this method has bytecode.
        /// </summary>
        public bool HasBytecode => md.ImplAttributes == MethodImplAttributes.IL && md.RelativeVirtualAddress != 0;

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                if (md.GetGenericParameters().Any())
                {
                    // We need to perform a 2-phase population because some type parameters can
                    // depend on other type parameters (as a constraint).
                    genericParams = new MethodTypeParameter[md.GetGenericParameters().Count];
                    for (var i = 0; i < genericParams.Length; ++i)
                        genericParams[i] = Cx.Populate(new MethodTypeParameter(this, this, i));
                    for (var i = 0; i < genericParams.Length; ++i)
                        genericParams[i].PopulateHandle(md.GetGenericParameters()[i]);
                    foreach (var p in genericParams)
                        yield return p;
                }

                var typeSignature = md.DecodeSignature(Cx.TypeSignatureDecoder, this);

                Parameters = MakeParameters(typeSignature.ParameterTypes).ToArray();

                foreach (var c in Parameters)
                    yield return c;

                foreach (var c in PopulateFlags)
                    yield return c;

                foreach (var p in md.GetParameters().Select(h => Cx.MdReader.GetParameter(h)).Where(p => p.SequenceNumber > 0))
                {
                    var pe = Parameters[IsStatic ? p.SequenceNumber - 1 : p.SequenceNumber];
                    if (p.Attributes.HasFlag(ParameterAttributes.Out))
                        yield return Tuples.cil_parameter_out(pe);
                    if (p.Attributes.HasFlag(ParameterAttributes.In))
                        yield return Tuples.cil_parameter_in(pe);
                    Attribute.Populate(Cx, pe, p.GetCustomAttributes());
                }

                yield return Tuples.metadata_handle(this, Cx.Assembly, MetadataTokens.GetToken(handle));
                yield return Tuples.cil_method(this, Name, declaringType, typeSignature.ReturnType);
                yield return Tuples.cil_method_source_declaration(this, this);
                yield return Tuples.cil_method_location(this, Cx.Assembly);

                if (HasBytecode)
                {
                    Implementation = new MethodImplementation(this);
                    yield return Implementation;

                    var body = Cx.PeReader.GetMethodBody(md.RelativeVirtualAddress);

                    if (!body.LocalSignature.IsNil)
                    {
                        var locals = Cx.MdReader.GetStandaloneSignature(body.LocalSignature);
                        var localVariableTypes = locals.DecodeLocalSignature(Cx.TypeSignatureDecoder, this);

                        this.locals = new LocalVariable[localVariableTypes.Length];

                        for (var l = 0; l < this.locals.Length; ++l)
                        {
                            this.locals[l] = Cx.Populate(new LocalVariable(Cx, Implementation, l, localVariableTypes[l]));
                            yield return this.locals[l];
                        }
                    }

                    var jump_table = new Dictionary<int, IInstruction>();

                    foreach (var c in Decode(body.GetILBytes(), jump_table))
                        yield return c;

                    var filter_index = 0;
                    foreach (var region in body.ExceptionRegions)
                    {
                        yield return new ExceptionRegion(this, Implementation, filter_index++, region, jump_table);
                    }

                    yield return Tuples.cil_method_stack_size(Implementation, body.MaxStack);

                    if (methodDebugInformation != null)
                    {
                        var sourceLocation = Cx.CreateSourceLocation(methodDebugInformation.Location);
                        yield return sourceLocation;
                        yield return Tuples.cil_method_location(this, sourceLocation);
                    }
                }

                // Flags

                if (md.Attributes.HasFlag(MethodAttributes.Private))
                    yield return Tuples.cil_private(this);

                if (md.Attributes.HasFlag(MethodAttributes.Public))
                    yield return Tuples.cil_public(this);

                if (md.Attributes.HasFlag(MethodAttributes.Family))
                    yield return Tuples.cil_protected(this);

                if (md.Attributes.HasFlag(MethodAttributes.Final))
                    yield return Tuples.cil_sealed(this);

                if (md.Attributes.HasFlag(MethodAttributes.Virtual))
                    yield return Tuples.cil_virtual(this);

                if (md.Attributes.HasFlag(MethodAttributes.Abstract))
                    yield return Tuples.cil_abstract(this);

                if (md.Attributes.HasFlag(MethodAttributes.HasSecurity))
                    yield return Tuples.cil_security(this);

                if (md.Attributes.HasFlag(MethodAttributes.RequireSecObject))
                    yield return Tuples.cil_requiresecobject(this);

                if (md.Attributes.HasFlag(MethodAttributes.SpecialName))
                    yield return Tuples.cil_specialname(this);

                if (md.Attributes.HasFlag(MethodAttributes.NewSlot))
                    yield return Tuples.cil_newslot(this);

                // Populate attributes
                Attribute.Populate(Cx, this, md.GetCustomAttributes());
            }
        }

        private IEnumerable<IExtractionProduct> Decode(byte[] ilbytes, Dictionary<int, IInstruction> jump_table)
        {
            // Sequence points are stored in order of offset.
            // We use an enumerator to locate the correct sequence point for each instruction.
            // The sequence point gives the location of each instruction.
            // The location of an instruction is given by the sequence point *after* the
            // instruction.
            IEnumerator<PDB.SequencePoint>? nextSequencePoint = null;
            PdbSourceLocation? instructionLocation = null;

            if (methodDebugInformation != null)
            {
                nextSequencePoint = methodDebugInformation.SequencePoints.GetEnumerator();
                if (nextSequencePoint.MoveNext())
                {
                    instructionLocation = Cx.CreateSourceLocation(nextSequencePoint.Current.Location);
                    yield return instructionLocation;
                }
                else
                {
                    nextSequencePoint = null;
                }
            }

            var child = 0;
            for (var offset = 0; offset < ilbytes.Length;)
            {
                var instruction = new Instruction(Cx, this, ilbytes, offset, child++);
                yield return instruction;

                if (nextSequencePoint != null && offset >= nextSequencePoint.Current.Offset)
                {
                    instructionLocation = Cx.CreateSourceLocation(nextSequencePoint.Current.Location);
                    yield return instructionLocation;
                    if (!nextSequencePoint.MoveNext())
                        nextSequencePoint = null;
                }

                if (instructionLocation != null)
                    yield return Tuples.cil_instruction_location(instruction, instructionLocation);

                jump_table.Add(instruction.Offset, instruction);
                offset += instruction.Width;
            }

            foreach (var i in jump_table)
            {
                foreach (var t in i.Value.JumpContents(jump_table))
                    yield return t;
            }
        }

        /// <summary>
        /// Display the instructions in the method in the debugger.
        /// This is only used for debugging, not in the code itself.
        /// </summary>
        public IEnumerable<Instruction> DebugInstructions
        {
            get
            {
                if (md.ImplAttributes == MethodImplAttributes.IL && md.RelativeVirtualAddress != 0)
                {
                    var body = Cx.PeReader.GetMethodBody(md.RelativeVirtualAddress);

                    var ilbytes = body.GetILBytes();

                    var child = 0;
                    for (var offset = 0; offset < ilbytes.Length;)
                    {
                        Instruction decoded;
                        try
                        {
                            decoded = new Instruction(Cx, this, ilbytes, offset, child++);
                            offset += decoded.Width;
                        }
                        catch  // lgtm[cs/catch-of-all-exceptions]
                        {
                            yield break;
                        }
                        yield return decoded;
                    }
                }
            }
        }
    }

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

                Parameters = MakeParameters(typeSignature.ParameterTypes).ToArray();
                foreach (var p in Parameters) yield return p;

                foreach (var f in PopulateFlags) yield return f;

                yield return Tuples.cil_method(this, Name, DeclaringType, typeSignature.ReturnType);

                if (SourceDeclaration != null)
                    yield return Tuples.cil_method_source_declaration(this, SourceDeclaration);
            }
        }
    }

    /// <summary>
    /// A constructed method.
    /// </summary>
    internal sealed class MethodSpecificationMethod : Method
    {
        private readonly MethodSpecificationHandle handle;
        private readonly MethodSpecification ms;
        private readonly Method unboundMethod;
        private readonly ImmutableArray<Type> typeParams;

        public MethodSpecificationMethod(GenericContext gc, MethodSpecificationHandle handle) : base(gc)
        {
            this.handle = handle;
            ms = Cx.MdReader.GetMethodSpecification(handle);
            typeParams = ms.DecodeSignature(Cx.TypeSignatureDecoder, gc);
            unboundMethod = (Method)Cx.CreateGeneric(gc, ms.Method);
        }

        public override void WriteId(TextWriter trapFile)
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
                        var mr = Cx.MdReader.GetMemberReference((MemberReferenceHandle)ms.Method);
                        constructedTypeSignature = mr.DecodeMethodSignature(Cx.TypeSignatureDecoder, this);
                        break;
                    case HandleKind.MethodDefinition:
                        var md = Cx.MdReader.GetMethodDefinition((MethodDefinitionHandle)ms.Method);
                        constructedTypeSignature = md.DecodeSignature(Cx.TypeSignatureDecoder, this);
                        break;
                    default:
                        throw new InternalError($"Unexpected constructed method handle kind {ms.Method.Kind}");
                }

                Parameters = MakeParameters(constructedTypeSignature.ParameterTypes).ToArray();
                foreach (var p in Parameters)
                    yield return p;

                foreach (var f in PopulateFlags)
                    yield return f;

                yield return Tuples.cil_method(this, Name, DeclaringType, constructedTypeSignature.ReturnType);
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
