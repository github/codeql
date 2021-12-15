class Composers
{
    IList<string> names, genres;

    public Composers()
    {
        names = new List<string> { "Bach", "Beethoven", "Chopin" };
        genres = new List<string> { "Classical", "Romantic", "Jazz" };
    }

    public IList<string> Names
    {
        get { return genres; }
    }

    public IList<string> Genres
    {
        get { return genres; }
    }
}
