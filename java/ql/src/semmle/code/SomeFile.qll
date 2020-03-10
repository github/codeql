import java

predicate publicPredicate(Expr e) {
    none()
}

private predicate privatePredicate(Expr e) {
    none()
}

module PublicModule {}

private module PrivateModule {}

private module IndirectlyPublicModule {
    predicate indirectlyPublicPredicate() { none() }
}

module Alias = IndirectlyPublicModule;

/** Lorem ipsum. */
predicate documentedPublicPredicate() { none() }
