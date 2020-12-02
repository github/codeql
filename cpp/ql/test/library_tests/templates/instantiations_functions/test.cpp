
struct grammar_helper_base {
    int undefine(int *);
};

template <typename B>
struct composite {
    template <typename TupleT>
    void eval(TupleT args) { }
};

#include "header.h"

template <typename ActionT>
class action {
public:
    void eparse() {
        int valx;
        actor.funx(valx);
    }

private:
    ActionT actor;
};

class rule {
    public:
        template <typename ParserT>
        rule(ParserT p) {
            p.eparse();
        }
};

void define() {
    action<actor1<composite<int>>> z;
    rule pp_expression = z;
}

