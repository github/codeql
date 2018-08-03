class Color{ /* ... */ }
class BookLength{ /* ... */ }
class BookType{ /* ... */ }
class Book
{
    private Color color;
    private BookLength length;
    private BookType type;
    public Book(Color color, BookLength length, BookType type){
        this.color = color;
        this.length = length;
        this.type = type;
    }
    public void read()
    {
        // ...
    }
}
