using System;

class C
{
    void FormatTests()
    {
        // GOOD: Uses all args
        String.Format("{0} {1} {2}", 0, 1, 2);

        // BAD: Missing arg {0}
        String.Format("X", 1);

        // BAD: Missing {1}
        String.Format("{0}", 1, 2);

        // BAD: Missing {1}
        String.Format("{0} {0}", 1, 2);

        // BAD: Missing {0}
        String.Format("{1} {1}", 1, 2);

        // BAD: Missing {0}, {1} and {2}
        String.Format("abcdefg", 0, 1, 2);

        // BAD: {0} is unused
        String.Format("{{sdc}}", 0);

        // GOOD: {0} is used
        String.Format("{{{0:D}}}", 0);

        // GOOD: Uses all args in params
        String.Format("{0} {1} {2} {3}", 0, 1, 2, 3);

        // GOOD: Params supplied
        String.Format("{0} {1} {2}", ps);

        // BAD: Would display "{0}"
        String.Format("{{0}}", 1);

        // GOOD: Ignore the empty string as it's often used as the default value
        // of GetResource().
        String.Format("", 1);
    }

    object[] ps;
}
