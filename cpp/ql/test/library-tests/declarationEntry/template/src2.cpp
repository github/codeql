// src2.cpp

template<class A>
class template_class;

template_class<char> *y;

/*
This used to cause a DBCheck issue along the lines of:

[INVALID_KEY] Relation class_instantiation((unique @usertype to, @usertype from)): Value 134 of key field to occurs in several tuples. Two such tuples are: (134,129) and (134,150)
	Relevant element: Full ID for 134: @"type_decl_template_class[class]<(24)>". The ID may expand to @"type_decl_template_class[class]<{@"predefined_type;char;1,-1"}>"
	Relevant element: Full ID for 129: @"type_decl_template_class[class]<(127)>". The ID may expand to @"type_decl_template_class[class]<{@"template_parameter_A:3:16:{@"C:/semmle/code/semmlecode-cpp-tests/library-tests/declarationEntry/template/src1.cpp;sourcefile"}"}>"
	Relevant element: Full ID for 150: @"type_decl_template_class[class]<(148)>". The ID may expand to @"type_decl_template_class[class]<{@"template_parameter_A:3:16:{@"C:/semmle/code/semmlecode-cpp-tests/library-tests/declarationEntry/template/src2.cpp;sourcefile"}"}>"

i.e. that the type 'template_class<char>' is an instantiation of two distinct templates,
template_class<A> of src1.cpp and template_class<A> of src2.cpp (and template_class<B> of
src3.cpp).  After some discussion we've decided that this is correct, since:
	* template_class<A> (x2) and template_class<B> are not real classes, but prototypes local to their own source files.  They do not make it through to the linking process or the final compiled program, thus they remain as three distinct entities.
	* template_class<char> on the other hand is a real class, merged from the three sources at link time.
	(it is a - not necessarily enforced - requirement of C++ that the three template_class<char> have equivalent definitions; if they don't, it can easily lead to bugs at runtime but that's another story)
	* thus, template_class<char> is legitimately derived from multiple templates.
*/
