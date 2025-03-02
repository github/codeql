package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;
import java.util.List;

public class CharacterClassIntersection extends RegExpTerm {
    private final List<RegExpTerm> intersections;

    public CharacterClassIntersection(SourceLocation loc, List<RegExpTerm> intersections) {
        super(loc, "CharacterClassIntersection");
        this.intersections = intersections;
    }

    @Override
    public void accept(Visitor v) {
        v.visit(this);
    }

    public List<RegExpTerm> getIntersections() {
        return intersections;
    }
}
