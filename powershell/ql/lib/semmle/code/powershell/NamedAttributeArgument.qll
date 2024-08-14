import powershell

class NamedAttributeArgument extends @named_attribute_argument
{
    string toString()
    {
        none()
    }

    SourceLocation getLocation()
    {
        named_attribute_argument_location(this, result)
    }

    string getName()
    {
        named_attribute_argument(this, result, _)
    }

    Expression getValue()
    {
        named_attribute_argument(this, _, result)
    }
}