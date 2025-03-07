package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;
import java.util.List;

public class Union extends RegExpTerm {
    private final List<RegExpTerm> union;

    public Union(SourceLocation loc, List<RegExpTerm> union) {
        super(loc, "Union");
        this.union = union;
    }

    @Override
    public void accept(Visitor v) {
        v.visit(this);
    }

    public List<RegExpTerm> getUnion() {
        return union;
    }
}
