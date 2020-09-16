using System;
using System.Collections.Immutable;
using System.Reflection.Metadata;
using Microsoft.CodeAnalysis;
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
    interface IMethod : IMember
    {
    }

    /// <summary>
    /// A method entity.
    /// </summary>
    abstract class Method : TypeContainer, IMethod
    {
        protected MethodTypeParameter[]? genericParams;
        protected GenericContext gc;
        protected MethodSignature<ITypeSignature> signature;

        protected Method(GenericContext gc) : base(gc.cx)
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

        internal protected void WriteMethodId(TextWriter trapFile, Type parent, string methodName)
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
            int index = 0;
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
            int i = 0;

            if (!IsStatic)
            {
                yield return cx.Populate(new Parameter(cx, this, i++, DeclaringType));
            }

            foreach (var p in parameterTypes)
                yield return cx.Populate(new Parameter(cx, this, i++, p));
        }
    }

    /// <summary>
    /// A method implementation entity.
    /// </summary>
    interface IMethodImplementation : IExtractedEntity
    {
    }

    /// <summary>
    /// A method implementation entity.
    /// In the database, the same method could in principle have multiple implementations.
    /// </summary>
    class MethodImplementation : UnlabelledEntity, IMethodImplementation
    {
        readonly Method m;

        public MethodImplementation(Method m) : base(m.cx)
        {
            this.m = m;
        }

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return Tuples.cil_method_implementation(this, m, cx.assembly);
            }
        }
    }


    /// <summary>
    /// A definition method - a method defined in the current assembly.
    /// </summary>
    sealed class DefinitionMethod : Method, IMember
    {
        readonly Handle handle;
        readonly MethodDefinition md;
        readonly PDB.IMethod? methodDebugInformation;
        readonly Type declaringType;

        readonly string name;
        LocalVariable[]? locals;

        public MethodImplementation? Implementation { get; private set; }

        public override IList<LocalVariable>? LocalVariables => locals;

        public DefinitionMethod(GenericContext gc, MethodDefinitionHandle handle) : base(gc)
        {
            md = cx.mdReader.GetMethodDefinition(handle);
            this.gc = gc;
            this.handle = handle;
            name = cx.GetString(md.Name);

            declaringType = (Type)cx.CreateGeneric(this, md.GetDeclaringType());

            signature = md.DecodeSignature(new SignatureDecoder(), this);

            methodDebugInformation = cx.GetMethodDebugInformation(handle);
        }

        public override bool Equals(object? obj)
        {
            return obj is DefinitionMethod method && handle.Equals(method.handle);
        }

        public override int GetHashCode() => handle.GetHashCode();

        public override bool IsStatic => !signature.Header.IsInstance;

        public override Type DeclaringType => declaringType;

        public override string Name => cx.ShortName(md.Name);

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
                    for (int i = 0; i < genericParams.Length; ++i)
                        genericParams[i] = cx.Populate(new MethodTypeParameter(this, this, i));
                    for (int i = 0; i < genericParams.Length; ++i)
                        genericParams[i].PopulateHandle(this, md.GetGenericParameters()[i]);
                    foreach (var p in genericParams)
                        yield return p;
                }

                var typeSignature = md.DecodeSignature(cx.TypeSignatureDecoder, this);

                Parameters = MakeParameters(typeSignature.ParameterTypes).ToArray();

                foreach (var c in Parameters)
                    yield return c;

                foreach (var c in PopulateFlags)
                    yield return c;

                foreach (var p in md.GetParameters().Select(h => cx.mdReader.GetParameter(h)).Where(p => p.SequenceNumber > 0))
                {
                    var pe = Parameters[IsStatic ? p.SequenceNumber - 1 : p.SequenceNumber];
                    if (p.Attributes.HasFlag(ParameterAttributes.Out))
                        yield return Tuples.cil_parameter_out(pe);
                    if (p.Attributes.HasFlag(ParameterAttributes.In))
                        yield return Tuples.cil_parameter_in(pe);
                    Attribute.Populate(cx, pe, p.GetCustomAttributes());
                }

                yield return Tuples.metadata_handle(this, cx.assembly, MetadataTokens.GetToken(handle));
                yield return Tuples.cil_method(this, Name, declaringType, typeSignature.ReturnType);
                yield return Tuples.cil_method_source_declaration(this, this);
                yield return Tuples.cil_method_location(this, cx.assembly);

                if (HasBytecode)
                {
                    Implementation = new MethodImplementation(this);
                    yield return Implementation;

                    var body = cx.peReader.GetMethodBody(md.RelativeVirtualAddress);

                    if (!body.LocalSignature.IsNil)
                    {
                        var locals = cx.mdReader.GetStandaloneSignature(body.LocalSignature);
                        var localVariableTypes = locals.DecodeLocalSignature(cx.TypeSignatureDecoder, this);

                        this.locals = new LocalVariable[localVariableTypes.Length];

                        for (int l = 0; l < this.locals.Length; ++l)
                        {
                            this.locals[l] = cx.Populate(new LocalVariable(cx, Implementation, l, localVariableTypes[l]));
                            yield return this.locals[l];
                        }
                    }

                    var jump_table = new Dictionary<int, IInstruction>();

                    foreach (var c in Decode(body.GetILBytes(), jump_table))
                        yield return c;

                    int filter_index = 0;
                    foreach (var region in body.ExceptionRegions)
                    {
                        yield return new ExceptionRegion(this, Implementation, filter_index++, region, jump_table);
                    }

                    yield return Tuples.cil_method_stack_size(Implementation, body.MaxStack);

                    if (methodDebugInformation != null)
                    {
                        var sourceLocation = cx.CreateSourceLocation(methodDebugInformation.Location);
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
                Attribute.Populate(cx, this, md.GetCustomAttributes());
            }
        }

        IEnumerable<IExtractionProduct> Decode(byte[] ilbytes, Dictionary<int, IInstruction> jump_table)
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
                    instructionLocation = cx.CreateSourceLocation(nextSequencePoint.Current.Location);
                    yield return instructionLocation;
                }
                else
                {
                    nextSequencePoint = null;
                }
            }

            int child = 0;
            for (int offset = 0; offset < ilbytes.Length;)
            {
                var instruction = new Instruction(cx, this, ilbytes, offset, child++);
                yield return instruction;

                if (nextSequencePoint != null && offset >= nextSequencePoint.Current.Offset)
                {
                    instructionLocation = cx.CreateSourceLocation(nextSequencePoint.Current.Location);
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
                    var body = cx.peReader.GetMethodBody(md.RelativeVirtualAddress);

                    var ilbytes = body.GetILBytes();

                    int child = 0;
                    for (int offset = 0; offset < ilbytes.Length;)
                    {
                        Instruction decoded;
                        try
                        {
                            decoded = new Instruction(cx, this, ilbytes, offset, child++);
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
    sealed class MemberReferenceMethod : Method
    {
        readonly MemberReferenceHandle handle;
        readonly MemberReference mr;
        readonly Type declaringType;
        readonly GenericContext parent;
        readonly Method? sourceDeclaration;

        public MemberReferenceMethod(GenericContext gc, MemberReferenceHandle handle) : base(gc)
        {
            this.handle = handle;
            this.gc = gc;
            mr = cx.mdReader.GetMemberReference(handle);

            signature = mr.DecodeMethodSignature(new SignatureDecoder(), gc);

            parent = (GenericContext)cx.CreateGeneric(gc, mr.Parent);

            var parentMethod = parent as Method;

            var declType = parentMethod is null ? parent as Type : parentMethod.DeclaringType;

            if (declType is null)
                throw new InternalError("Parent context of method is not a type");

            declaringType = declType;
            nameLabel = cx.GetString(mr.Name);

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

        public override string Name => cx.ShortName(mr.Name);

        public override IEnumerable<Type> TypeParameters => parent.TypeParameters.Concat(gc.TypeParameters);

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                genericParams = new MethodTypeParameter[signature.GenericParameterCount];
                for (int p = 0; p < genericParams.Length; ++p)
                    genericParams[p] = cx.Populate(new MethodTypeParameter(this, this, p));

                foreach (var p in genericParams)
                    yield return p;

                var typeSignature = mr.DecodeMethodSignature(cx.TypeSignatureDecoder, this);

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
    sealed class MethodSpecificationMethod : Method
    {
        readonly MethodSpecificationHandle handle;
        readonly MethodSpecification ms;
        readonly Method unboundMethod;
        readonly ImmutableArray<Type> typeParams;

        public MethodSpecificationMethod(GenericContext gc, MethodSpecificationHandle handle) : base(gc)
        {
            this.handle = handle;
            ms = cx.mdReader.GetMethodSpecification(handle);
            typeParams = ms.DecodeSignature(cx.TypeSignatureDecoder, gc);
            unboundMethod = (Method)cx.CreateGeneric(gc, ms.Method);
        }

        public override void WriteId(TextWriter trapFile)
        {
            unboundMethod.WriteId(trapFile);
            trapFile.Write('<');
            int index = 0;
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
                        var mr = cx.mdReader.GetMemberReference((MemberReferenceHandle)ms.Method);
                        constructedTypeSignature = mr.DecodeMethodSignature(cx.TypeSignatureDecoder, this);
                        break;
                    case HandleKind.MethodDefinition:
                        var md = cx.mdReader.GetMethodDefinition((MethodDefinitionHandle)ms.Method);
                        constructedTypeSignature = md.DecodeSignature(cx.TypeSignatureDecoder, this);
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

                if (typeParams.Count() != unboundMethod.GenericParameterCount)
                    throw new InternalError("Method type parameter mismatch");

                for (int p = 0; p < typeParams.Length; ++p)
                {
                    yield return Tuples.cil_type_argument(this, p, typeParams[p]);
                }
            }
        }
    }
}
