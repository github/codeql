namespace Semmle.Extraction.CSharp
{
    /// <summary>
    /// How an entity behaves with respect to .push and .pop
    /// </summary>
    public enum TrapStackBehaviour
    {
        /// <summary>
        /// The entity must not be extracted inside a .push/.pop
        /// </summary>
        NoLabel,

        /// <summary>
        /// The entity defines its own label, creating a .push/.pop
        /// </summary>
        PushesLabel,

        /// <summary>
        /// The entity must be extracted inside a .push/.pop
        /// </summary>
        NeedsLabel,

        /// <summary>
        /// The entity can be extracted inside or outside of a .push/.pop
        /// </summary>
        OptionalLabel
    }
}
