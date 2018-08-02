//  semmle-extractor-options: --standalone

class ObjectComparisonTest
{
    UnknownType unknownValue;

    void test()
    {
        bool result;

        // GOOD: type information missing
        result = unknownF() == unknownF();
        result = this == unknownValue;
        result = someValue == unknownValue;
        result = (object)unknownF() == 0;
        result = (object)unknownValue = someValue;

        // BAD: Explicit cast
        result = (object)unknownValue == (object)someValue;

        // BAD: Type information known
        result = this == (object)this;
    }
}
