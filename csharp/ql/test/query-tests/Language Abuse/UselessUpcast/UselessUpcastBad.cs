class Bad
{
    class Super {}
    class Sub : Super {}

    void M()
    {
        var sub = new Sub();
        Super super = (Super)sub;
    }
}
