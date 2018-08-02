/*
  semmle-extractor-options: /r:asm1=${testdir}/Assembly1.dll /r:asm2=${testdir}/Assembly2.dll

  Class is defined in three places, and requires the alias to disambiguate them.
*/

extern alias asm1;
extern alias asm2;

class Class
{
}

class Tests
{
    public static void Main(string[] args)
    {
        asm1::Class c1;
        asm2::Class c2;
        Class c3;
    }
}
