/**
 * Provides database quality statistics that are reported by csharp/telemetry/extractor-information
 * and perhaps warned about by csharp/diagnostics/database-quality.
 */

import csharp

signature module StatsSig {
  int getNumberOfOk();

  int getNumberOfNotOk();

  string getOkText();

  string getNotOkText();
}

module ReportStats<StatsSig Stats> {
  predicate numberOfOk(string key, int value) {
    value = Stats::getNumberOfOk() and
    key = "Number of " + Stats::getOkText()
  }

  predicate numberOfNotOk(string key, int value) {
    value = Stats::getNumberOfNotOk() and
    key = "Number of " + Stats::getNotOkText()
  }

  predicate percentageOfOk(string key, float value) {
    value = Stats::getNumberOfOk() * 100.0 / (Stats::getNumberOfOk() + Stats::getNumberOfNotOk()) and
    key = "Percentage of " + Stats::getOkText()
  }
}

module CallTargetStats implements StatsSig {
  int getNumberOfOk() { result = count(Call c | exists(c.getTarget())) }

  private predicate isNoSetterPropertyCallInConstructor(PropertyCall c) {
    exists(Property p, Constructor ctor |
      p = c.getProperty() and
      not exists(Setter a | a = p.getAnAccessor()) and
      c.getEnclosingCallable() = ctor and
      (
        c.hasThisQualifier()
        or
        ctor instanceof StaticConstructor and p.getDeclaringType() = ctor.getDeclaringType()
      )
    )
  }

  private predicate isNoSetterPropertyInitialization(PropertyCall c) {
    exists(Property p, AssignExpr assign |
      p = c.getProperty() and
      not exists(Setter a | a = p.getAnAccessor()) and
      assign = c.getParent() and
      assign.getLValue() = c and
      assign.getParent() instanceof Property
    )
  }

  private predicate isAnonymousObjectMemberDeclaration(PropertyCall c) {
    exists(Property p, AssignExpr assign |
      p = c.getProperty() and
      assign = c.getParent() and
      assign.getLValue() = c and
      assign.getParent() instanceof ObjectInitializer and
      assign.getParent().getParent() instanceof AnonymousObjectCreation
    )
  }

  private predicate isInitializedWithObjectOrCollectionInitializer(PropertyCall c) {
    exists(Property p, AssignExpr assign |
      p = c.getProperty() and
      assign = c.getParent() and
      assign.getLValue() = c and
      assign.getRValue() instanceof ObjectOrCollectionInitializer
    )
  }

  private predicate isEventFieldAccess(EventCall c) {
    exists(Event e | c.getEvent() = e |
      forall(Accessor a | e.getAnAccessor() = a | a.isCompilerGenerated())
    )
  }

  private predicate isTypeParameterInstantiation(ObjectCreation e) {
    e.getType() instanceof TypeParameter
  }

  additional predicate isNotOkCall(Call c) {
    not exists(c.getTarget()) and
    not c instanceof DelegateCall and
    not c instanceof DynamicExpr and
    not isNoSetterPropertyCallInConstructor(c) and
    not isNoSetterPropertyInitialization(c) and
    not isAnonymousObjectMemberDeclaration(c) and
    not isInitializedWithObjectOrCollectionInitializer(c) and
    not c.getParent+() instanceof NameOfExpr and
    not isEventFieldAccess(c) and
    not isTypeParameterInstantiation(c)
  }

  int getNumberOfNotOk() { result = count(Call c | isNotOkCall(c)) }

  string getOkText() { result = "calls with call target" }

  string getNotOkText() { result = "calls with missing call target" }
}

private class SourceExpr extends Expr {
  SourceExpr() { this.getFile().fromSource() }
}

private predicate hasGoodType(Expr e) {
  exists(e.getType()) and not e.getType() instanceof UnknownType
}

module ExprTypeStats implements StatsSig {
  int getNumberOfOk() { result = count(SourceExpr e | hasGoodType(e)) }

  int getNumberOfNotOk() { result = count(SourceExpr e | not hasGoodType(e)) }

  string getOkText() { result = "expressions with known type" }

  string getNotOkText() { result = "expressions with unknown type" }
}

module CallTargetStatsReport = ReportStats<CallTargetStats>;

module ExprTypeStatsReport = ReportStats<ExprTypeStats>;
