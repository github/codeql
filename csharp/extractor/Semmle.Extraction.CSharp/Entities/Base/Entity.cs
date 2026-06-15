using System;
using System.Collections.Generic;
using System.IO;
using Microsoft.CodeAnalysis;
using Semmle.Extraction.CSharp.Entities;

namespace Semmle.Extraction.CSharp
{
    public abstract class Entity : IEntity
    {
        public Context Context { get; }

        protected Entity(Context context)
        {
            this.Context = context;
        }

        public Label Label { get; set; }

        public abstract void WriteId(EscapingTextWriter trapFile);

        public virtual void WriteQuotedId(EscapingTextWriter trapFile)
        {
            trapFile.WriteUnescaped("@\"");
            WriteId(trapFile);
            trapFile.WriteUnescaped('\"');
        }

        public abstract Microsoft.CodeAnalysis.Location? ReportingLocation { get; }

        public abstract TrapStackBehaviour TrapStackBehaviour { get; }

        public void DefineLabel(TextWriter trapFile)
        {
            trapFile.WriteLabel(this);
            trapFile.Write("=");
            using var escaping = new EscapingTextWriter(trapFile);
            try
            {
                WriteQuotedId(escaping);
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                trapFile.WriteLine("\"");
                Context.ExtractionContext.Message(new Message($"Unhandled exception generating id: {ex.Message}", ToString() ?? "", null, ex.StackTrace));
            }
            trapFile.WriteLine();
        }

        public void DefineFreshLabel(TextWriter trapFile)
        {
            trapFile.WriteLabel(this);
            trapFile.WriteLine("=*");
        }

#if DEBUG_LABELS
        /// <summary>
        /// Generates a debug string for this entity.
        /// </summary>
        public string GetDebugLabel()
        {
            using var writer = new EscapingTextWriter();
            writer.WriteLabel(Label.Value);
            writer.Write('=');
            WriteQuotedId(writer);
            return writer.ToString();
        }
#endif

        protected void PopulateRefKind(TextWriter trapFile, RefKind kind)
        {
            switch (kind)
            {
                case RefKind.Out:
                    trapFile.type_annotation(this, Kinds.TypeAnnotation.Out);
                    break;
                case RefKind.Ref:
                    trapFile.type_annotation(this, Kinds.TypeAnnotation.Ref);
                    break;
                case RefKind.RefReadOnly:
                case RefKind.RefReadOnlyParameter:
                    trapFile.type_annotation(this, Kinds.TypeAnnotation.ReadonlyRef);
                    break;
            }
        }

        protected void PopulateNullability(TextWriter trapFile, AnnotatedTypeSymbol type)
        {
            var n = NullabilityEntity.Create(Context, Nullability.Create(type));
            if (!type.HasObliviousNullability())
            {
                trapFile.type_nullability(this, n);
            }
        }

        protected static void WriteLocationToTrap<T1>(Action<T1, Entities.Location> writeAction, T1 entity, Entities.Location l)
        {
            if (l is not EmptyLocation)
            {
                writeAction(entity, l);
            }
        }

        protected static void WriteLocationsToTrap<T1>(Action<T1, Entities.Location> writeAction, T1 entity, IEnumerable<Entities.Location> locations)
        {
            foreach (var loc in locations)
            {
                WriteLocationToTrap(writeAction, entity, loc);
            }
        }

        public override string ToString() => Label.ToString();
    }
}
