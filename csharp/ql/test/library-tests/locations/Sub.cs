public class Sub : Base<int>
{
    public void SubM()
    {
        M();
        var x = new InnerBase();
    }
}
