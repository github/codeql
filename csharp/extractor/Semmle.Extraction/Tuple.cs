namespace Semmle.Extraction
{
    /// <summary>
    /// A tuple represents a string of the form "a(b,c,d)"
    /// Its purpose is mainly to make various method calls typesafe.
    /// </summary>
    public struct Tuple : ITrapEmitter
    {
        readonly string Name;
        readonly object[] Args;

        public Tuple(string name, params object[] args)
        {
            Name = name;
            Args = args;
        }

        /// <summary>
        /// Constructs a unique string for this tuple.
        /// </summary>
        /// <param name="tb">The trap builder used to store the result.</param>
        public void EmitToTrapBuilder(ITrapBuilder tb)
        {
            tb.Append(Name).Append("(");

            int column = 0;
            foreach (var a in Args)
            {
                if (column > 0) tb.Append(", ");
                if (a is Label)
                {
                    ((Label)a).AppendTo(tb);
                }
                else if (a is IEntity)
                {
                    ((IEntity)a).Label.AppendTo(tb);
                }
                else if (a is string)
                {
                    tb.Append("\"");
                    tb.Append(((string)a).Replace("\"", "\"\""));
                    tb.Append("\"");
                }
                else if (a is System.Enum)
                {
                    tb.Append((int)a);
                }
                else if (a is int)
                {
                    tb.Append((int)a);
                }
                else if (a == null)
                {
                    throw new InternalError("Attempt to write a null argument tuple {0} at column {1}",
                        Name, column);
                }
                else
                {
                    var array = a as string[];
                    if (array != null)
                    {
                        tb.Append("\"");
                        foreach (var element in array)
                            tb.Append(element.Replace("\"", "\"\""));
                        tb.Append("\"");
                    }
                    else
                    {
                        throw new InternalError("Attempt to write an invalid argument type {0} in tuple {1} at column {2}",
                            a.GetType(), Name, column);
                    }
                }
                ++column;
            }
            tb.Append(")");
            tb.AppendLine();
        }

        public override string ToString()
        {
            // Only implemented for debugging purposes
            var tsb = new TrapStringBuilder();
            EmitToTrapBuilder(tsb);
            return tsb.ToString();
        }
    }
}
