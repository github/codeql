public static void foo(int count)
{
    if (count > 10) {
        Console.WriteLine("The count is large");
    }

    var timesLeft = count;
    while (timesLeft > 0) {
        switch(Console.ReadLine()) {
            case "BYE" : Console.WriteLine("Good bye"); break;
            case "HELLO" : Console.WriteLine("Hi"); break;
            case "HELP" : Console.WriteLine("Try HELLO or BYE."); break;
            default : Console.WriteLine("Input not understood."); break;
        }
        timesLeft--;
    }
}
