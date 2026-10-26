/*
  Global statements are not allowed in 'library' target.
*/

using System;

[assembly: Attr] // not a global stmt

Console.WriteLine("1");
Console.WriteLine("2");
M();

void M()
{
}

public class Attr : Attribute
{
  void M1()
  {
    Console.WriteLine("3");
  }
}
