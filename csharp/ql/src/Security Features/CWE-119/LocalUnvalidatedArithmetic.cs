public class PossiblyOverridable
{
    public virtual int GetElementNumber()
    {
        // By default returns 0, which is safe
        return 0;
    }
}

public class PointerArithmetic
{
    public unsafe void WriteToOffset(PossiblyOverridable possiblyOverridable,
                                     char[] charArray)
    {
        fixed (char* charPointer = charArray)
        {
            // BAD: Unvalidated use of virtual method call result in pointer arithmetic
            char* newCharPointer = charPointer + possiblyOverridable.GetElementNumber();
            *newCharPointer = 'A';
            // GOOD: Check that the number is viable
            int number = possiblyOverridable.GetElementNumber();
            if (number >= 0 && number < charArray.Length)
            {
                char* newCharPointer2 = charPointer + number;
                *newCharPointer = 'A';
            }
        }
    }
}
