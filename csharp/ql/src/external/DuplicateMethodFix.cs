class Container
{
    protected int x;
    protected int y;
    public void move(int x, int y)
    {
        this.x = x;
        this.y = y;
    }
}
class Toolbox : Container
{
    // ...
}
class Window : Container
{
    // ...
}
