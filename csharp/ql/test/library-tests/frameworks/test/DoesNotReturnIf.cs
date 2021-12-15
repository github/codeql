using System;
using System.Collections.Generic;

namespace DoesNotReturnIfTests
{
    class MyTestSuite
    {
        private void AssertTrue([System.Diagnostics.CodeAnalysis.DoesNotReturnIf(false)] bool condition)
        {
        }

        private void AssertFalse([System.Diagnostics.CodeAnalysis.DoesNotReturnIf(true)] bool condition)
        {
        }

        private void AssertTrue2(
            [System.Diagnostics.CodeAnalysis.DoesNotReturnIf(false)] bool condition1,
            [System.Diagnostics.CodeAnalysis.DoesNotReturnIf(false)] bool condition2,
            bool nonCondition)
        {
        }
    }
}
