public class PossiblyOverridableClass
{
    public virtual int getNumber()
    {
        // By default returns 0, which is safe
        return 0;
    }
}

public class PointerArithmetic
{
    public unsafe void CalcPointer(PossiblyOverridableClass possiblyOverridable, char[] charArray)
    {
        fixed (char* charPointer = charArray)
        {
            // BAD: Unvalidate use in pointer arithmetic
            char* newCharPointer = charPointer + possiblyOverridable.getNumber();
            *newCharPointer = 'A';
            // BAD: Unvalidate use in pointer arithmetic
            int number = possiblyOverridable.getNumber();
            if (number > 0 && number < charArray.Length)
            {
                // GOOD: number validated first
                char* newCharPointer2 = charPointer + number;
                *newCharPointer = 'A';
            }
        }
    }
}
