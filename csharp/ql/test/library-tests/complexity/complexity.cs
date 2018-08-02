public class Complexity
{
    void cc1(int val)
    {
        switch (val)
        {
        }
        switch (val)
        {
            case 1:
            default:
                break;
        }
        switch (val)
        {
            default:
            case 1:
                break;
        }
        switch (val)
        {
            case 1:
            default:
            case 2:
                break;
        }
    }

    void cc2(int val)
    {
        switch (val)
        {
            case 1:
                break;
            default:
                break;
        }
    }

    void cc3(int val)
    {
        switch (val)
        {
            case 1:
            case 2:
                break;
            case 3:
                break;
        }
    }

    void cc4(int val)
    {
        switch (val)
        {
            case 1:
            case 2:
                break;
            case 3:
                break;
            case 4:
                break;
            case 2 + 3:
            default:
            case 3 + 3:
            case 7:
                break;
        }
    }
}
