using System;

namespace Identifiers
{
    interface @I1
    {
        void @Method1(int @param1);
    }

    struct @S1
    {
    }

    class @C1 : @I1
    {
        int @field1;
        @S1 @field2;
        int field3;

        public void @Method1(int @param1)
        {
            object @local1;
            Func<int, int> @local2 = @x => @x;
            object local3;
        }
    }
}
