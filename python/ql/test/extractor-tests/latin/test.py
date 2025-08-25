# -*- coding: latin-1 -*-

class C(object):

    def m(self):
        #According to https://docs.python.org/2/library/ast.html#ast.AST.col_offset
        #all column offsets are utf-8.
        #That is incorrect as the compiler passes latin-1 encoded files through untouched.
        f(unicode=u'£££'.encode('utf-8'))
