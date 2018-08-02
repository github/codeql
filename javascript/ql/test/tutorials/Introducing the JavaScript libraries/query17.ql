import javascript

class PasswordTracker extends DataFlow::Configuration {
    PasswordTracker() {
        // unique identifier for this configuration
        this = "PasswordTracker"
    }

    override predicate isSource(DataFlow::Node nd) {
        nd.asExpr() instanceof StringLiteral
    }

    override predicate isSink(DataFlow::Node nd) {
        passwordVarAssign(_, nd)
    }

    predicate passwordVarAssign(Variable v, DataFlow::Node nd) {
        exists (SsaExplicitDefinition def |
            nd = DataFlow::ssaDefinitionNode(def) and
            def.getSourceVariable() = v and
            v.getName().toLowerCase() = "password"
        )
    }
}

from PasswordTracker pt, DataFlow::Node source, DataFlow::Node sink, Variable v
where pt.hasFlow(source, sink) and pt.passwordVarAssign(v, sink)
select sink, "Password variable " + v + " is assigned a constant string."
