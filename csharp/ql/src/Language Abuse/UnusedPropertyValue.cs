class Window
{
    const int screenWidth = 1280;
    int x0, x1;

    public int Width
    {
        get { return x1 - x0; }

        // BAD: Setter has no effect
        set { }
    }

    public bool FullWidth
    {
        get { return x0 == 0 && x1 == screenWidth; }

        // BAD: This is confusing if value==false
        set { x0 = 0; x1 = screenWidth; }
    }
}
