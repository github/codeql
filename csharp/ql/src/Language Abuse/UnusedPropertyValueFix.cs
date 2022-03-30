class Window
{
    const int screenWidth = 1280;
    int x0, x1;

    public int Width
    {
        get { return x1 - x0; }
    }

    public bool IsFullWidth
    {
        get { return x0 == 0 && x1 == screenWidth; }
    }

    public void MakeFullWidth()
    {
        x0 = 0; x1 = screenWidth;
    }
}
