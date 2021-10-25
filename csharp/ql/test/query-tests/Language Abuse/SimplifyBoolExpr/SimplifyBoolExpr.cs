
class Test
{
    void Fn()
    {
        bool b = false;
        int x = 0, y = 0;

        if (b == true) ;
        if (b == false) ;
        if (true == b) ;
        if (false == b) ;
        if (b != true) ;
        if (b != false) ;
        if (true != b) ;
        if (false != b) ;
        if (b && true) ;
        if (b && false) ;
        if (true && b) ;
        if (false && b) ;
        if (b || true) ;
        if (b || false) ;
        if (true || b) ;
        if (false || b) ;
        if (!(x == y)) ;
        if (!(x != y)) ;
        if (!(x < y)) ;
        if (!(x <= y)) ;
        if (!(x >= y)) ;
        if (!(x > y)) ;
        if (b ? true : false) ;
        if (b ? true : true) ;
        if (b ? false : true) ;
        if (b ? true : true) ;
        if (b ? b : false) ;
        if (b ? b : true) ;
        if (b ? false : b) ;
        if (b ? true : b) ;

        // BAD
        if (true ? b : b) ;
        if (false ? b : b) ;
        if (true == true) ;
        if (true != false) ;
        if (true && true) ;
        if (true || false) ;
    }
}
