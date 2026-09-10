private import unified
private import codeql.util.Unit
private import codeql.unified.internal.NameBindingPluginSwift // ensure overrides are seen

/** Extension point for language-specific inputs to name binding. */
class NameBindingPlugin extends Unit {
  /**
   * Holds if `e`, occurring in pattern context, should be interpreted a sub-expression
   * whose result is to be compared to the incoming value.
   */
  bindingset[e]
  predicate isNonPattern(Expr e) { none() }

  /**
   * Holds if `member` is an instance member.
   *
   * The caller has already restricted `member` to be a member of `cls`, and
   * ensured that `member` is a `VariableDeclaration` or `FunctionDeclaration`.
   */
  bindingset[cls, member]
  predicate isInstanceMember(ClassLikeDeclaration cls, Member member) { none() }

  /**
   * Holds if `binding`, declared by `member` is only visible in its local scope, and can thus be entirely resolved
   * by local name-binding, suppressing any store-steps that would otherwise be induced from the member.
   *
   * Need only be implemented for members that occur in the context of class or top-level, as other
   * contexts are considered local already.
   *
   * `binding` refers to an `Identifier` or `BulkImportingPattern` bound by the member.
   */
  bindingset[member, binding]
  predicate isPrivateToLocalScope(Stmt member, AstNode binding) { none() }

  /**
   * Holds if `member` can be inherited by subclasses of `cls`.
   *
   * The caller has already restricted `member` to be a member of `cls`.
   */
  bindingset[cls, member]
  predicate isInheritableMember(ClassLikeDeclaration cls, Member member) { none() }
}

/** Holds if `member` is an instance member. */
predicate isInstanceMember(Member member) {
  (member instanceof VariableDeclaration or member instanceof FunctionDeclaration) and
  exists(ClassLikeDeclaration cls | cls.getAMember() = member |
    any(NameBindingPlugin p).isInstanceMember(cls, member)
  )
}

/**
 * Holds if `member` is a non-instance member declared in the context of a class or top-level.
 */
predicate isStaticMember(Member member) {
  exists(ClassLikeDeclaration cls | cls.getAMember() = member |
    not any(NameBindingPlugin p).isInstanceMember(cls, member)
  )
  or
  member = any(TopLevel t).getBody().getAStmt()
}

/** Holds if `member` is an inheritable member. */
predicate isInheritableMember(Member member) {
  exists(ClassLikeDeclaration cls | cls.getAMember() = member |
    any(NameBindingPlugin p).isInheritableMember(cls, member)
  )
}

/**
 * A representative for a module scope.
 *
 * Module scopes can encompass a set of files, and is the canonical representative
 * for the top-level members collectively exported from those files.
 */
abstract class ModuleScopeRepr extends AstNode {
  /**
   * Holds if files matched by `path` should be part of this module;
   * `path` is resolved relative to `c` and may use globs.
   *
   * For each file in the module:
   * - Top-level exported members become members of this module, and
   * - This module is implicitly imported at the top-level
   */
  predicate shouldInclude(Container c, string path) { none() }

  /**
   * Holds if this module scope can be referenced by the given `name`
   * appearing as the leading name of an import path.
   */
  predicate hasImportableName(string name) { none() }

  /** Gets one of the files included due to the `shouldInclude` predicate. */
  final File getAnIncludedFile() {
    exists(Container c, string path |
      this.shouldInclude(c, path) and
      result = FileResolver::resolve(c, path)
    )
  }
}

private module FileResolverInput implements Folder::ResolveSig {
  predicate shouldResolve(Container base, string path) {
    any(ModuleScopeRepr r).shouldInclude(base, path)
  }

  predicate allowGlobs() { any() }
}

private module FileResolver = Folder::Resolve<FileResolverInput>;
