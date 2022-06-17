#pragma once

#include <swift/AST/Decl.h>
#include <swift/AST/GenericParamList.h>
#include <swift/AST/ParameterList.h>
#include <swift/AST/ASTMangler.h>

#include "swift/extractor/visitors/VisitorBase.h"

namespace codeql {

// `swift::Decl` visitor
// TODO all `std::variant` here should really be `std::optional`, but we need those kinds of
// "forward declarations" while our extraction is incomplete
class DeclVisitor : public AstVisitorBase<DeclVisitor> {
 public:
  using AstVisitorBase<DeclVisitor>::AstVisitorBase;

  std::variant<codeql::ConcreteFuncDecl, codeql::ConcreteFuncDeclsTrap> translateFuncDecl(
      const swift::FuncDecl& decl) {
    auto id = dispatcher_.assignNewLabel(decl, mangledName(decl));
    if (!dispatcher_.shouldEmitDeclBody(decl)) {
      return ConcreteFuncDeclsTrap{id};
    }
    ConcreteFuncDecl entry{id};
    fillAbstractFunctionDecl(decl, entry);
    return entry;
  }

  std::variant<codeql::ConstructorDecl, codeql::ConstructorDeclsTrap> translateConstructorDecl(
      const swift::ConstructorDecl& decl) {
    auto id = dispatcher_.assignNewLabel(decl, mangledName(decl));
    if (!dispatcher_.shouldEmitDeclBody(decl)) {
      return ConstructorDeclsTrap{id};
    }
    ConstructorDecl entry{id};
    fillAbstractFunctionDecl(decl, entry);
    return entry;
  }

  std::variant<codeql::DestructorDecl, codeql::DestructorDeclsTrap> translateDestructorDecl(
      const swift::DestructorDecl& decl) {
    auto id = dispatcher_.assignNewLabel(decl, mangledName(decl));
    if (!dispatcher_.shouldEmitDeclBody(decl)) {
      return DestructorDeclsTrap{id};
    }
    DestructorDecl entry{id};
    fillAbstractFunctionDecl(decl, entry);
    return entry;
  }

  codeql::PrefixOperatorDecl translatePrefixOperatorDecl(const swift::PrefixOperatorDecl& decl) {
    PrefixOperatorDecl entry{dispatcher_.assignNewLabel(decl)};
    fillOperatorDecl(decl, entry);
    return entry;
  }

  codeql::PostfixOperatorDecl translatePostfixOperatorDecl(const swift::PostfixOperatorDecl& decl) {
    PostfixOperatorDecl entry{dispatcher_.assignNewLabel(decl)};
    fillOperatorDecl(decl, entry);
    return entry;
  }

  codeql::InfixOperatorDecl translateInfixOperatorDecl(const swift::InfixOperatorDecl& decl) {
    InfixOperatorDecl entry{dispatcher_.assignNewLabel(decl)};
    entry.precedence_group = dispatcher_.fetchOptionalLabel(decl.getPrecedenceGroup());
    fillOperatorDecl(decl, entry);
    return entry;
  }

  codeql::PrecedenceGroupDecl translatePrecedenceGroupDecl(const swift::PrecedenceGroupDecl& decl) {
    PrecedenceGroupDecl entry{dispatcher_.assignNewLabel(decl)};
    return entry;
  }

  codeql::ParamDecl translateParamDecl(const swift::ParamDecl& decl) {
    // TODO: deduplicate
    ParamDecl entry{dispatcher_.assignNewLabel(decl)};
    fillVarDecl(decl, entry);
    entry.is_inout = decl.isInOut();
    return entry;
  }

  codeql::TopLevelCodeDecl translateTopLevelCodeDecl(const swift::TopLevelCodeDecl& decl) {
    TopLevelCodeDecl entry{dispatcher_.assignNewLabel(decl)};
    assert(decl.getBody() && "Expect top level code to have body");
    entry.body = dispatcher_.fetchLabel(decl.getBody());
    return entry;
  }

  codeql::PatternBindingDecl translatePatternBindingDecl(const swift::PatternBindingDecl& decl) {
    PatternBindingDecl entry{dispatcher_.assignNewLabel(decl)};
    for (unsigned i = 0; i < decl.getNumPatternEntries(); ++i) {
      auto pattern = decl.getPattern(i);
      assert(pattern && "Expect pattern binding decl to have all patterns");
      entry.patterns.push_back(dispatcher_.fetchLabel(pattern));
      entry.inits.push_back(dispatcher_.fetchOptionalLabel(decl.getInit(i)));
    }
    return entry;
  }

  codeql::ConcreteVarDecl translateVarDecl(const swift::VarDecl& decl) {
    // TODO: deduplicate all non-local variables
    ConcreteVarDecl entry{dispatcher_.assignNewLabel(decl)};
    entry.introducer_int = static_cast<uint8_t>(decl.getIntroducer());
    fillVarDecl(decl, entry);
    return entry;
  }

  std::variant<codeql::StructDecl, codeql::StructDeclsTrap> translateStructDecl(
      const swift::StructDecl& decl) {
    auto id = dispatcher_.assignNewLabel(decl, mangledName(decl));
    if (!dispatcher_.shouldEmitDeclBody(decl)) {
      return StructDeclsTrap{id};
    }
    StructDecl entry{id};
    fillNominalTypeDecl(decl, entry);
    return entry;
  }

  std::variant<codeql::ClassDecl, codeql::ClassDeclsTrap> translateClassDecl(
      const swift::ClassDecl& decl) {
    auto id = dispatcher_.assignNewLabel(decl, mangledName(decl));
    if (!dispatcher_.shouldEmitDeclBody(decl)) {
      return ClassDeclsTrap{id};
    }
    ClassDecl entry{id};
    fillNominalTypeDecl(decl, entry);
    return entry;
  }

  std::variant<codeql::EnumDecl, codeql::EnumDeclsTrap> translateEnumDecl(
      const swift::EnumDecl& decl) {
    auto id = dispatcher_.assignNewLabel(decl, mangledName(decl));
    if (!dispatcher_.shouldEmitDeclBody(decl)) {
      return EnumDeclsTrap{id};
    }
    EnumDecl entry{id};
    fillNominalTypeDecl(decl, entry);
    return entry;
  }

  std::variant<codeql::ProtocolDecl, codeql::ProtocolDeclsTrap> translateProtocolDecl(
      const swift::ProtocolDecl& decl) {
    auto id = dispatcher_.assignNewLabel(decl, mangledName(decl));
    if (!dispatcher_.shouldEmitDeclBody(decl)) {
      return ProtocolDeclsTrap{id};
    }
    ProtocolDecl entry{id};
    fillNominalTypeDecl(decl, entry);
    return entry;
  }

  codeql::EnumCaseDecl translateEnumCaseDecl(const swift::EnumCaseDecl& decl) {
    EnumCaseDecl entry{dispatcher_.assignNewLabel(decl)};
    entry.elements = dispatcher_.fetchRepeatedLabels(decl.getElements());
    return entry;
  }

  std::variant<codeql::EnumElementDecl, codeql::EnumElementDeclsTrap> translateEnumElementDecl(
      const swift::EnumElementDecl& decl) {
    auto id = dispatcher_.assignNewLabel(decl, mangledName(decl));
    if (!dispatcher_.shouldEmitDeclBody(decl)) {
      return EnumElementDeclsTrap{id, decl.getNameStr().str()};
    }
    EnumElementDecl entry{id};
    entry.name = decl.getNameStr().str();
    if (decl.hasParameterList()) {
      entry.params = dispatcher_.fetchRepeatedLabels(*decl.getParameterList());
    }
    fillValueDecl(decl, entry);
    return entry;
  }

  codeql::GenericTypeParamDecl translateGenericTypeParamDecl(
      const swift::GenericTypeParamDecl& decl) {
    // TODO: deduplicate
    GenericTypeParamDecl entry{dispatcher_.assignNewLabel(decl)};
    fillTypeDecl(decl, entry);
    return entry;
  }

  std::variant<codeql::AssociatedTypeDecl, codeql::AssociatedTypeDeclsTrap>
  translateAssociatedTypeDecl(const swift::AssociatedTypeDecl& decl) {
    auto id = dispatcher_.assignNewLabel(decl, mangledName(decl));
    if (!dispatcher_.shouldEmitDeclBody(decl)) {
      return AssociatedTypeDeclsTrap{id};
    }
    AssociatedTypeDecl entry{id};
    fillTypeDecl(decl, entry);
    return entry;
  }

  std::variant<codeql::TypeAliasDecl, codeql::TypeAliasDeclsTrap> translateTypeAliasDecl(
      const swift::TypeAliasDecl& decl) {
    auto id = dispatcher_.assignNewLabel(decl, mangledName(decl));
    if (!dispatcher_.shouldEmitDeclBody(decl)) {
      return TypeAliasDeclsTrap{id};
    }
    TypeAliasDecl entry{id};
    fillTypeDecl(decl, entry);
    return entry;
  }

  std::variant<codeql::AccessorDecl, codeql::AccessorDeclsTrap> translateAccessorDecl(
      const swift::AccessorDecl& decl) {
    auto id = dispatcher_.assignNewLabel(decl, mangledName(decl));
    if (!dispatcher_.shouldEmitDeclBody(decl)) {
      return AccessorDeclsTrap{id};
    }
    AccessorDecl entry{id};
    switch (decl.getAccessorKind()) {
      case swift::AccessorKind::Get:
        entry.is_getter = true;
        break;
      case swift::AccessorKind::Set:
        entry.is_setter = true;
        break;
      case swift::AccessorKind::WillSet:
        entry.is_will_set = true;
        break;
      case swift::AccessorKind::DidSet:
        entry.is_did_set = true;
        break;
    }
    fillAbstractFunctionDecl(decl, entry);
    return entry;
  }

  std::optional<codeql::SubscriptDecl> translateSubscriptDecl(const swift::SubscriptDecl& decl) {
    auto id = dispatcher_.assignNewLabel(decl, mangledName(decl));
    if (!dispatcher_.shouldEmitDeclBody(decl)) {
      return std::nullopt;
    }
    SubscriptDecl entry{id};
    entry.element_type = dispatcher_.fetchLabel(decl.getElementInterfaceType());
    if (auto indices = decl.getIndices()) {
      entry.params = dispatcher_.fetchRepeatedLabels(*indices);
    }
    fillAbstractStorageDecl(decl, entry);
    return entry;
  }

  codeql::ExtensionDecl translateExtensionDecl(const swift::ExtensionDecl& decl) {
    ExtensionDecl entry{dispatcher_.assignNewLabel(decl)};
    entry.extended_type_decl = dispatcher_.fetchLabel(decl.getExtendedNominal());
    fillGenericContext(decl, entry);
    fillIterableDeclContext(decl, entry);
    return entry;
  }

 private:
  std::string mangledName(const swift::ValueDecl& decl) {
    // prefix adds a couple of special symbols, we don't necessary need them
    return mangler.mangleAnyDecl(&decl, /* prefix = */ false);
  }

  void fillAbstractFunctionDecl(const swift::AbstractFunctionDecl& decl,
                                codeql::AbstractFunctionDecl& entry) {
    assert(decl.hasParameterList() && "Expect functions to have a parameter list");
    entry.name = !decl.hasName() || decl.getName().isSpecial() ? "(unnamed function decl)"
                                                               : decl.getNameStr().str();
    entry.body = dispatcher_.fetchOptionalLabel(decl.getBody());
    entry.params = dispatcher_.fetchRepeatedLabels(*decl.getParameters());
    fillValueDecl(decl, entry);
    fillGenericContext(decl, entry);
  }

  void fillOperatorDecl(const swift::OperatorDecl& decl, codeql::OperatorDecl& entry) {
    entry.name = decl.getName().str().str();
  }

  void fillTypeDecl(const swift::TypeDecl& decl, codeql::TypeDecl& entry) {
    entry.name = decl.getNameStr().str();
    for (auto& typeLoc : decl.getInherited()) {
      if (auto type = typeLoc.getType()) {
        entry.base_types.push_back(dispatcher_.fetchLabel(type));
      }
    }
    fillValueDecl(decl, entry);
  }

  void fillIterableDeclContext(const swift::IterableDeclContext& decl,
                               codeql::IterableDeclContext& entry) {
    entry.members = dispatcher_.fetchRepeatedLabels(decl.getAllMembers());
  }

  void fillVarDecl(const swift::VarDecl& decl, codeql::VarDecl& entry) {
    entry.name = decl.getNameStr().str();
    entry.type = dispatcher_.fetchLabel(decl.getType());
    entry.parent_pattern = dispatcher_.fetchOptionalLabel(decl.getParentPattern());
    entry.parent_initializer = dispatcher_.fetchOptionalLabel(decl.getParentInitializer());
    if (decl.hasAttachedPropertyWrapper()) {
      entry.attached_property_wrapper_type =
          dispatcher_.fetchOptionalLabel(decl.getPropertyWrapperBackingPropertyType());
    }
    fillAbstractStorageDecl(decl, entry);
  }

  void fillNominalTypeDecl(const swift::NominalTypeDecl& decl, codeql::NominalTypeDecl& entry) {
    entry.type = dispatcher_.fetchLabel(decl.getDeclaredType());
    fillGenericContext(decl, entry);
    fillIterableDeclContext(decl, entry);
    fillTypeDecl(decl, entry);
  }

  void fillGenericContext(const swift::GenericContext& decl, codeql::GenericContext& entry) {
    if (auto params = decl.getGenericParams()) {
      entry.generic_type_params = dispatcher_.fetchRepeatedLabels(*params);
    }
  }

  void fillValueDecl(const swift::ValueDecl& decl, codeql::ValueDecl& entry) {
    assert(decl.getInterfaceType() && "Expect ValueDecl to have InterfaceType");
    entry.interface_type = dispatcher_.fetchLabel(decl.getInterfaceType());
  }

  void fillAbstractStorageDecl(const swift::AbstractStorageDecl& decl,
                               codeql::AbstractStorageDecl& entry) {
    entry.accessor_decls = dispatcher_.fetchRepeatedLabels(decl.getAllAccessors());
    fillValueDecl(decl, entry);
  }

 private:
  swift::Mangle::ASTMangler mangler;
};

}  // namespace codeql
