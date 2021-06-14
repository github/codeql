using System;
using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// Modified types are not written directly to trap files. Instead, the modifiers are stored
    /// on the modifiable entity (field type, property/method/function pointer parameter or return types).
    /// </summary>
    internal sealed class ModifiedType : Type
    {
        public ModifiedType(Context cx, Type unmodified, Type modifier, bool isRequired) : base(cx)
        {
            Unmodified = unmodified;
            Modifier = modifier;
            IsRequired = isRequired;
        }

        public Type Unmodified { get; }
        public Type Modifier { get; }
        public bool IsRequired { get; }

        public override CilTypeKind Kind => throw new NotImplementedException();

        public override Namespace? ContainingNamespace => throw new NotImplementedException();

        public override Type? ContainingType => throw new NotImplementedException();

        public override IEnumerable<Type> TypeParameters => throw new NotImplementedException();

        public override int ThisTypeParameterCount => throw new NotImplementedException();

        public override Type Construct(IEnumerable<Type> typeArguments) => throw new NotImplementedException();

        public override string Name => $"{Unmodified.Name} {(IsRequired ? "modreq" : "modopt")}({Modifier.Name})";

        public override void WriteAssemblyPrefix(TextWriter trapFile) => throw new NotImplementedException();

        public override void WriteId(EscapingTextWriter trapFile, bool inContext)
        {
            Unmodified.WriteId(trapFile, inContext);
            trapFile.Write(IsRequired ? " modreq" : " modopt");
            trapFile.Write("(");
            Modifier.WriteId(trapFile, inContext);
            trapFile.Write(")");
        }
    }
}
