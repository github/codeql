
class c {
    struct t {
        template< template< typename V0 > class V > struct s { };
        template< typename V > static void f( s < V::template r >* = 0 );
    };
};

