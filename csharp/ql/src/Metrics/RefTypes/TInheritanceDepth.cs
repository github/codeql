class Book
{
    public void read()
    {
        // ...
    }
}
abstract class BlueBook : Book { /* ... */ }
abstract class RedBook : Book { /* ... */ }
abstract class LongRedBook : RedBook { /* ... */ }
abstract class ShortRedBook : RedBook { /* ... */ }
abstract class LongBlueBook : BlueBook { /* ... */ }
abstract class ShortBlueBook : BlueBook { /* ... */ }
class ShortBlueNovel : ShortBlueBook { /* ... */ }
// ...
