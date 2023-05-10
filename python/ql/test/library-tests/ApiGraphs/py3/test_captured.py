from html import escape

def p(x):
    return escape(x) #$ use=moduleImport("html").getMember("escape").getReturn()

def p_list(l):
    return ", ".join(p(x) for x in l) #$ use=moduleImport("html").getMember("escape").getReturn()

def pp_list(l):
    def pp(x):
        return escape(x) #$ use=moduleImport("html").getMember("escape").getReturn()

    def pp_list_inner(l):
        return ", ".join(pp(x) for x in l) #$ use=moduleImport("html").getMember("escape").getReturn()
