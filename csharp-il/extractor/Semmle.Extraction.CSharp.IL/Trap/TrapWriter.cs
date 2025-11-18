using System.IO;

namespace Semmle.Extraction.CSharp.IL.Trap;

/// <summary>
/// Simple TRAP file writer - just writes tuples as text lines.
/// We'll create the schema later to match what we write here.
/// </summary>
public class TrapWriter : IDisposable
{
    private readonly TextWriter writer;
    private readonly string trapFilePath;
    private int nextId = 1;

    public TrapWriter(string outputPath)
    {
        trapFilePath = outputPath;
        writer = new StreamWriter(trapFilePath);
    }

    /// <summary>
    /// Get a unique ID for an entity.
    /// </summary>
    public int GetId()
    {
        return nextId++;
    }

    /// <summary>
    /// Write a tuple to the TRAP file.
    /// Format: predicate(arg1, arg2, ...)
    /// </summary>
    public void WriteTuple(string predicate, params object[] args)
    {
        writer.Write(predicate);
        writer.Write('(');
        
        for (int i = 0; i < args.Length; i++)
        {
            if (i > 0)
                writer.Write(", ");
            
            WriteValue(args[i]);
        }
        
        writer.WriteLine(')');
    }

    private void WriteValue(object value)
    {
        switch (value)
        {
            case int i:
                writer.Write(i);
                break;
            case long l:
                writer.Write(l);
                break;
            case string s:
                // Escape string and wrap in quotes
                writer.Write('"');
                writer.Write(EscapeString(s));
                writer.Write('"');
                break;
            case null:
                writer.Write("null");
                break;
            default:
                writer.Write(value.ToString());
                break;
        }
    }

    private string EscapeString(string s)
    {
        // Basic escaping - may need to be more sophisticated
        return s.Replace("\\", "\\\\")
                .Replace("\"", "\\\"")
                .Replace("\n", "\\n")
                .Replace("\r", "\\r")
                .Replace("\t", "\\t");
    }

    public void Dispose()
    {
        writer.Dispose();
    }
}
