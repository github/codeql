namespace Semmle.Extraction
{
    /// <summary>
    /// How an entity behaves with respect to .push and .pop
    /// </summary>
    public abstract class TrapStackBehaviour
    {
        public static TrapStackBehaviour NoLabel = new NoLabel();

        public static TrapStackBehaviour NeedsLabel = new NeedsLabel();

        public static TrapStackBehaviour OptionalLabel = new OptionalLabel();


    }

    /// <summary>
    /// The entity must not be extracted inside a .push/.pop
    /// </summary>
    public sealed class NoLabel : TrapStackBehaviour { }

    /// <summary>
    /// The entity defines its own label, creating a .push/.pop
    ///
    /// In order to avoid .push/.pop when the entity is covered by a conditional
    /// preprocessor directive such as `#if`, the entity must specify the span
    /// that it covers.
    /// </summary>
    public sealed class PushesLabel : TrapStackBehaviour
    {
        public readonly int Start;
        public readonly int End;

        public PushesLabel(int start, int end)
        {
            Start = start;
            End = end;
        }
    }

    /// <summary>
    /// The entity must be extracted inside a .push/.pop
    /// </summary>
    public sealed class NeedsLabel : TrapStackBehaviour { }

    /// <summary>
    /// The entity can be extracted inside or outside of a .push/.pop
    /// </summary>
    public sealed class OptionalLabel : TrapStackBehaviour { }
}
