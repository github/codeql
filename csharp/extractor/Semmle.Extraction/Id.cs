using System;
using System.Collections.Generic;
using System.Linq;

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
        void AppendTo(ITrapBuilder tb);
    }

    /// <summary>
    /// A fresh ID (`*`).
    /// </summary>
    public class FreshId : IId
    {
        FreshId() { }

        /// <summary>
        /// Gets the singleton <see cref="FreshId"/> instance.
        /// </summary>
        public static IId Instance { get; } = new FreshId();

        public override string ToString() => "*";

        public override bool Equals(object obj) => obj.GetType() == GetType();

        public override int GetHashCode() => 0;

        public void AppendTo(ITrapBuilder tb)
        {
            tb.Append("*");
        }
    }

    /// <summary>
    /// A key. Either a simple key, e.g. `@"bool A.M();method"`, or a compound key, e.g.
    /// `@"{0} {1}.M();method"` where `0` and `1` are both labels.
    /// </summary>
    public class Key : IId
    {
        readonly IdTrapBuilder TrapBuilder;

        /// <summary>
        /// Creates a new key by concatenating the contents of the supplied arguments.
        /// </summary>
        public Key(params object[] args)
        {
            TrapBuilder = new IdTrapBuilder();
            foreach (var arg in args)
                TrapBuilder.Append(arg);
        }

        /// <summary>
        /// Creates a new key by applying the supplied action to an empty
        /// trap builder.
        /// </summary>
        public Key(Action<ITrapBuilder> action)
        {
            TrapBuilder = new IdTrapBuilder();
            action(TrapBuilder);
        }

        public override string ToString()
        {
            // Only implemented for debugging purposes
            var tsb = new TrapStringBuilder();
            AppendTo(tsb);
            return tsb.ToString();
        }

        public override bool Equals(object obj)
        {
            if (obj.GetType() != GetType())
                return false;
            var id = (Key)obj;
            return id.TrapBuilder.Fragments.SequenceEqual(TrapBuilder.Fragments);
        }

        public override int GetHashCode()
        {
            unchecked
            {
                int hash = 17;

                foreach (var fragment in TrapBuilder.Fragments)
                {
                    hash = hash * 23 + fragment.GetHashCode();
                }

                return hash;
            }
        }

        public void AppendTo(ITrapBuilder tb)
        {
            tb.Append("@\"");
            foreach (var fragment in TrapBuilder.Fragments)
                tb.Append(fragment);
            tb.Append("\"");
        }

        class IdTrapBuilder : ITrapBuilder
        {
            readonly public List<string> Fragments = new List<string>();

            public ITrapBuilder Append(object arg)
            {
                if (arg is IEntity)
                {
                    var key = ((IEntity)arg).Label;
                    Fragments.Add("{#");
                    Fragments.Add(key.Value.ToString());
                    Fragments.Add("}");
                }
                else
                    Fragments.Add(arg.ToString());

                return this;
            }

            public ITrapBuilder Append(string arg)
            {
                Fragments.Add(arg);
                return this;
            }

            public ITrapBuilder AppendLine()
            {
                throw new NotImplementedException();
            }
        }
    }

    /// <summary>
    /// A label referencing an entity, of the form "#123".
    /// </summary>
    public struct Label : IId
    {
        public Label(int value) : this()
        {
            Value = value;
        }

        public int Value { get; private set; }

        static public readonly Label InvalidLabel = new Label(0);

        public bool Valid => Value > 0;

        public override string ToString()
        {
            if (!Valid)
                throw new NullReferenceException("Attempt to use an invalid label");

            return "#" + Value;
        }

        public static bool operator ==(Label l1, Label l2) => l1.Value == l2.Value;

        public static bool operator !=(Label l1, Label l2) => l1.Value != l2.Value;

        public override bool Equals(object other)
        {
            return GetType() == other.GetType() && ((Label)other).Value == Value;
        }

        public override int GetHashCode() => 61 * Value;

        /// <summary>
        /// Constructs a unique string for this label.
        /// </summary>
        /// <param name="tb">The trap builder used to store the result.</param>
        public void AppendTo(ITrapBuilder tb)
        {
            if (!Valid)
                throw new NullReferenceException("Attempt to use an invalid label");

            tb.Append("#").Append(Value);
        }
    }
}
