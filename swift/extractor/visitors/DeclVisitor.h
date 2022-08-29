#pragma once

#include <swift/AST/Decl.h>
#include <swift/AST/ASTMangler.h>

#include "swift/extractor/visitors/VisitorBase.h"
#include "swift/extractor/trap/generated/decl/TrapClasses.h"

namespace codeql {

// `swift::Decl` visitor
// TODO all `std::variant` here should really be `std::optional`, but we need those kinds of
// "forward declarations" while our extraction is incomplete
class DeclVisitor : public AstVisitorBase<DeclVisitor> {
 public:
  using AstVisitorBase<DeclVisitor>::AstVisitorBase;
  using AstVisitorBase<DeclVisitor>::visit;

  void visit(const swift::IfConfigClause* clause) {
    dispatcher_.emit(translateIfConfigClause(*clause));
  }

  std::optional<codeql::ConcreteFuncDecl> translateFuncDecl(const swift::FuncDecl& decl);
  std::optional<codeql::ConstructorDecl> translateConstructorDecl(
      const swift::ConstructorDecl& decl);
  std::optional<codeql::DestructorDecl> translateDestructorDecl(const swift::DestructorDecl& decl);
  codeql::PrefixOperatorDecl translatePrefixOperatorDecl(const swift::PrefixOperatorDecl& decl);
  codeql::PostfixOperatorDecl translatePostfixOperatorDecl(const swift::PostfixOperatorDecl& decl);
  codeql::InfixOperatorDecl translateInfixOperatorDecl(const swift::InfixOperatorDecl& decl);
  codeql::PrecedenceGroupDecl translatePrecedenceGroupDecl(const swift::PrecedenceGroupDecl& decl);
  std::optional<codeql::ParamDecl> translateParamDecl(const swift::ParamDecl& decl);
  codeql::TopLevelCodeDecl translateTopLevelCodeDecl(const swift::TopLevelCodeDecl& decl);
  codeql::PatternBindingDecl translatePatternBindingDecl(const swift::PatternBindingDecl& decl);
  std::optional<codeql::ConcreteVarDecl> translateVarDecl(const swift::VarDecl& decl);
  std::optional<codeql::StructDecl> translateStructDecl(const swift::StructDecl& decl);
  std::optional<codeql::ClassDecl> translateClassDecl(const swift::ClassDecl& decl);
  std::optional<codeql::EnumDecl> translateEnumDecl(const swift::EnumDecl& decl);
  std::optional<codeql::ProtocolDecl> translateProtocolDecl(const swift::ProtocolDecl& decl);
  codeql::EnumCaseDecl translateEnumCaseDecl(const swift::EnumCaseDecl& decl);
  std::optional<codeql::EnumElementDecl> translateEnumElementDecl(
      const swift::EnumElementDecl& decl);
  codeql::GenericTypeParamDecl translateGenericTypeParamDecl(
      const swift::GenericTypeParamDecl& decl);
  std::optional<codeql::AssociatedTypeDecl> translateAssociatedTypeDecl(
      const swift::AssociatedTypeDecl& decl);
  std::optional<codeql::TypeAliasDecl> translateTypeAliasDecl(const swift::TypeAliasDecl& decl);
  std::optional<codeql::AccessorDecl> translateAccessorDecl(const swift::AccessorDecl& decl);
  std::optional<codeql::SubscriptDecl> translateSubscriptDecl(const swift::SubscriptDecl& decl);
  codeql::ExtensionDecl translateExtensionDecl(const swift::ExtensionDecl& decl);
  codeql::ImportDecl translateImportDecl(const swift::ImportDecl& decl);
  std::optional<codeql::ModuleDecl> translateModuleDecl(const swift::ModuleDecl& decl);
  codeql::IfConfigDecl translateIfConfigDecl(const swift::IfConfigDecl& decl);
  codeql::IfConfigClause translateIfConfigClause(const swift::IfConfigClause& clause);

 private:
  std::string mangledName(const swift::ValueDecl& decl);
  void fillAbstractFunctionDecl(const swift::AbstractFunctionDecl& decl,
                                codeql::AbstractFunctionDecl& entry);
  void fillOperatorDecl(const swift::OperatorDecl& decl, codeql::OperatorDecl& entry);
  void fillTypeDecl(const swift::TypeDecl& decl, codeql::TypeDecl& entry);
  void fillIterableDeclContext(const swift::IterableDeclContext& decl,
                               codeql::IterableDeclContext& entry);
  void fillVarDecl(const swift::VarDecl& decl, codeql::VarDecl& entry);
  void fillNominalTypeDecl(const swift::NominalTypeDecl& decl, codeql::NominalTypeDecl& entry);
  void fillGenericContext(const swift::GenericContext& decl, codeql::GenericContext& entry);
  void fillValueDecl(const swift::ValueDecl& decl, codeql::ValueDecl& entry);
  void fillAbstractStorageDecl(const swift::AbstractStorageDecl& decl,
                               codeql::AbstractStorageDecl& entry);

  template <typename D>
  std::optional<TrapClassOf<D>> createNamedEntry(const D& decl) {
    auto id = dispatcher_.assignNewLabel(decl, mangledName(decl));
    std::optional<TrapClassOf<D>> entry;
    if (dispatcher_.shouldEmitDeclBody(decl)) {
      entry.emplace(id);
      fillDecl(decl, *entry);
    }
    return entry;
  }

  template <typename D>
  TrapClassOf<D> createEntry(const D& decl) {
    TrapClassOf<D> entry{dispatcher_.template assignNewLabel(decl)};
    fillDecl(decl, entry);
    return entry;
  }

  void fillDecl(const swift::Decl& decl, codeql::Decl& entry) {
    entry.module = dispatcher_.fetchLabel(decl.getModuleContext());
  }

  swift::Mangle::ASTMangler mangler;
};

}  // namespace codeql
