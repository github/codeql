using System;
using System.IO;

namespace Semmle.Extraction
{
    /// <summary>
    /// An ID. Either a fresh ID (`*`), a key, or a label (https://semmle.com/wiki/display/IN/TRAP+Files):
    ///
    /// ```
    /// id ::= '*' | key | label
    /// ```
    /// </summary>
    public interface IId
    {
        /// <summary>
        /// Appends this ID to the supplied trap builder.
        /// </summary>
        void AppendTo(TextWriter trapFile);
    }

    /// <summary>
    /// A fresh ID (`*`).
    /// </summary>
    public class FreshId : IId
    {
        private FreshId() { }

        /// <summary>
        /// Gets the singleton <see cref="FreshId"/> instance.
        /// </summary>
        public static IId Instance { get; } = new FreshId();

        public override string ToString() => "*";

        public override bool Equals(object? obj) => obj?.GetType() == GetType();

        public override int GetHashCode() => 0;

        public void AppendTo(TextWriter trapFile)
        {
            trapFile.Write('*');
        }
    }

    /// <summary>
    /// A key. Either a simple key, e.g. `@"bool A.M();method"`, or a compound key, e.g.
    /// `@"{0} {1}.M();method"` where `0` and `1` are both labels.
    /// </summary>
    public class Key : IId
    {
        private readonly StringWriter trapBuilder = new StringWriter();

        /// <summary>
        /// Creates a new key by concatenating the contents of the supplied arguments.
        /// </summary>
        public Key(params object[] args)
        {
            trapBuilder = new StringWriter();
            foreach (var arg in args)
            {
                if (arg is IEntity entity)
                {
                    var key = entity.Label;
                    trapBuilder.Write("{#");
                    trapBuilder.Write(key.Value.ToString());
                    trapBuilder.Write("}");
                }
                else
                {
                    trapBuilder.Write(arg.ToString());
                }
            }
        }

        /// <summary>
        /// Creates a new key by applying the supplied action to an empty
        /// trap builder.
        /// </summary>
        public Key(Action<TextWriter> action)
        {
            action(trapBuilder);
        }

        public override string ToString()
        {
            return trapBuilder.ToString();
        }

        public override bool Equals(object? obj)
        {
            if (obj is null || obj.GetType() != GetType())
                return false;
            var id = (Key)obj;
            return trapBuilder.ToString() == id.trapBuilder.ToString();
        }

        public override int GetHashCode() => trapBuilder.ToString().GetHashCode();

        public void AppendTo(TextWriter trapFile)
        {
            trapFile.Write("@\"");
            trapFile.Write(trapBuilder.ToString());
            trapFile.Write("\"");
        }
    }

    /// <summary>
    /// A label referencing an entity, of the form "#123".
    /// </summary>
    public struct Label
    {
        public Label(int value) : this()
        {
            Value = value;
        }

        public int Value { get; private set; }

        public static Label InvalidLabel { get; } = new Label(0);

        public bool Valid => Value > 0;

        public override string ToString()
        {
            if (!Valid)
                throw new InvalidOperationException("Attempt to use an invalid label");

            return "#" + Value;
        }

        public static bool operator ==(Label l1, Label l2) => l1.Value == l2.Value;

        public static bool operator !=(Label l1, Label l2) => l1.Value != l2.Value;

        public override bool Equals(object? other)
        {
            if (other is null)
                return false;
            return GetType() == other.GetType() && ((Label)other).Value == Value;
        }

        public override int GetHashCode() => 61 * Value;

        /// <summary>
        /// Constructs a unique string for this label.
        /// </summary>
        /// <param name="trapFile">The trap builder used to store the result.</param>
        public void AppendTo(System.IO.TextWriter trapFile)
        {
            if (!Valid)
                throw new InvalidOperationException("Attempt to use an invalid label");

            trapFile.Write('#');
            trapFile.Write(Value);
        }
    }
}
