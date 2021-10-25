using System;

class Fixed
{
    unsafe void fixed1()
    {
        byte[] buffer = new byte[10];

        fixed (byte* pinned_buffer = &buffer[0])
        {
            var t = pinned_buffer;
            fixed1();
        }

        fixed (byte* pinned_buffer = &buffer[0])
        {
        }

        fixed (byte* pinned_buffer = &buffer[0]) ;
    }
}
