package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;
import java.util.List;

public class Subtraction extends RegExpTerm {
    private final List<RegExpTerm> subtraction;

    public Subtraction(SourceLocation loc, List<RegExpTerm> subtraction) {
        super(loc, "Intersection");
        this.subtraction = subtraction;
    }

    @Override
    public void accept(Visitor v) {
        v.visit(this);
    }

    public List<RegExpTerm> getSubtraction() {
        return subtraction;
    }
}
