package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;
import java.util.List;

public class Intersection extends RegExpTerm {
    private final List<RegExpTerm> intersections;

    public Intersection(SourceLocation loc, List<RegExpTerm> intersections) {
        super(loc, "Intersection");
        this.intersections = intersections;
    }

    @Override
    public void accept(Visitor v) {
        v.visit(this);
    }

    /** The individual elements of the intersections. */
    public List<RegExpTerm> getIntersections() {
        return intersections;
    }
}
