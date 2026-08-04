
class Test
{
    void Fn()
    {
        bool b = false;
        int x = 0, y = 0;

        if (b == true) ; // $ Alert
        if (b == false) ; // $ Alert
        if (true == b) ; // $ Alert
        if (false == b) ; // $ Alert
        if (b != true) ; // $ Alert
        if (b != false) ; // $ Alert
        if (true != b) ; // $ Alert
        if (false != b) ; // $ Alert
        if (b && true) ; // $ Alert
        if (b && false) ; // $ Alert
        if (true && b) ; // $ Alert
        if (false && b) ; // $ Alert
        if (b || true) ; // $ Alert
        if (b || false) ; // $ Alert
        if (true || b) ; // $ Alert
        if (false || b) ; // $ Alert
        if (!(x == y)) ; // $ Alert
        if (!(x != y)) ; // $ Alert
        if (!(x < y)) ; // $ Alert
        if (!(x <= y)) ; // $ Alert
        if (!(x >= y)) ; // $ Alert
        if (!(x > y)) ; // $ Alert
        if (b ? true : false) ; // $ Alert
        if (b ? true : true) ; // $ Alert
        if (b ? false : true) ; // $ Alert
        if (b ? true : true) ; // $ Alert
        if (b ? b : false) ; // $ Alert
        if (b ? b : true) ; // $ Alert
        if (b ? false : b) ; // $ Alert
        if (b ? true : b) ; // $ Alert

        // BAD
        if (true ? b : b) ;
        if (false ? b : b) ;
        if (true == true) ;
        if (true != false) ;
        if (true && true) ;
        if (true || false) ;
    }
}
