using System;

[assembly: global::Attribute1]

class Attribute1Attribute : Attribute
{
}

[Attribute1]
class A
{
}
