#pragma once

#include <swift/AST/Decl.h>
#include <swift/AST/GenericParamList.h>
#include <swift/AST/ParameterList.h>

#include "swift/extractor/visitors/VisitorBase.h"

namespace codeql {

// `swift::Decl` visitor
class DeclVisitor : public AstVisitorBase<DeclVisitor> {
 public:
  void translateFuncDecl(swift::FuncDecl* decl, codeql::ConcreteFuncDecl* entry) {
    entry->id = dispatcher_.assignNewLabel(decl);
    fillAbstractFunctionDecl(decl, entry);
  }

  void translateConstructorDecl(swift::ConstructorDecl* decl, codeql::ConstructorDecl* entry) {
    entry->id = dispatcher_.assignNewLabel(decl);
    fillAbstractFunctionDecl(decl, entry);
  }

  void translateDestructorDecl(swift::DestructorDecl* decl, codeql::DestructorDecl* entry) {
    entry->id = dispatcher_.assignNewLabel(decl);
    fillAbstractFunctionDecl(decl, entry);
  }

  void translatePrefixOperatorDecl(swift::PrefixOperatorDecl* decl,
                                   codeql::PrefixOperatorDecl* entry) {
    entry->id = dispatcher_.assignNewLabel(decl);
    fillOperatorDecl(decl, entry);
  }

  void translatePostfixOperatorDecl(swift::PostfixOperatorDecl* decl,
                                    codeql::PostfixOperatorDecl* entry) {
    entry->id = dispatcher_.assignNewLabel(decl);
    fillOperatorDecl(decl, entry);
  }

  void translateInfixOperatorDecl(swift::InfixOperatorDecl* decl,
                                  codeql::InfixOperatorDecl* entry) {
    entry->id = dispatcher_.assignNewLabel(decl);
    entry->precedence_group = dispatcher_.fetchOptionalLabel(decl->getPrecedenceGroup());
    fillOperatorDecl(decl, entry);
  }

  void translatePrecedenceGroupDecl(swift::PrecedenceGroupDecl* decl,
                                    codeql::PrecedenceGroupDecl* entry) {
    entry->id = dispatcher_.assignNewLabel(decl);
  }

  void translateParamDecl(swift::ParamDecl* decl, codeql::ParamDecl* entry) {
    entry->id = dispatcher_.assignNewLabel(decl);
    fillAbstractVarDecl(decl, entry);
  }

  void translateTopLevelCodeDecl(swift::TopLevelCodeDecl* decl, codeql::TopLevelCodeDecl* entry) {
    entry->id = dispatcher_.assignNewLabel(decl);
    assert(decl->getBody() && "Expect top level code to have body");
    entry->body = dispatcher_.fetchLabel(decl->getBody());
  }

  void translatePatternBindingDecl(swift::PatternBindingDecl* decl,
                                   codeql::PatternBindingDecl* entry) {
    entry->id = dispatcher_.assignNewLabel(decl);
    for (unsigned i = 0; i < decl->getNumPatternEntries(); ++i) {
      auto pattern = decl->getPattern(i);
      assert(pattern && "Expect pattern binding decl to have all patterns");
      entry->patterns.push_back(dispatcher_.fetchLabel(pattern));
      entry->inits.push_back(dispatcher_.fetchOptionalLabel(decl->getInit(i)));
    }
  }

  void translateVarDecl(swift::VarDecl* decl, codeql::ConcreteVarDecl* entry) {
    entry->id = dispatcher_.assignNewLabel(decl);
    entry->introducer_int = static_cast<uint8_t>(decl->getIntroducer());
    fillAbstractVarDecl(decl, entry);
  }

  void translateStructDecl(swift::StructDecl* decl, codeql::StructDecl* entry) {
    entry->id = dispatcher_.assignNewLabel(decl);
    fillNominalTypeDecl(decl, entry);
  }

  void translateClassDecl(swift::ClassDecl* decl, codeql::ClassDecl* entry) {
    entry->id = dispatcher_.assignNewLabel(decl);
    fillNominalTypeDecl(decl, entry);
  }

  void translateEnumDecl(swift::EnumDecl* decl, codeql::EnumDecl* entry) {
    entry->id = dispatcher_.assignNewLabel(decl);
    fillNominalTypeDecl(decl, entry);
  }

  void translateProtocolDecl(swift::ProtocolDecl* decl, codeql::ProtocolDecl* entry) {
    entry->id = dispatcher_.assignNewLabel(decl);
    fillNominalTypeDecl(decl, entry);
  }

  void translateEnumCaseDecl(swift::EnumCaseDecl* decl, codeql::EnumCaseDecl* entry) {
    entry->id = dispatcher_.assignNewLabel(decl);
    entry->elements = dispatcher_.fetchRepeatedLabels(decl->getElements());
  }

  void translateEnumElementDecl(swift::EnumElementDecl* decl, codeql::EnumElementDecl* entry) {
    entry->id = dispatcher_.assignNewLabel(decl);
    entry->name = decl->getNameStr().str();
    if (decl->hasParameterList()) {
      entry->params = dispatcher_.fetchRepeatedLabels(*decl->getParameterList());
    }
    fillValueDecl(decl, entry);
  }

  void translateGenericTypeParamDecl(swift::GenericTypeParamDecl* decl,
                                     GenericTypeParamDecl* entry) {
    entry->id = dispatcher_.assignNewLabel(decl);
    fillTypeDecl(decl, entry);
  }

  void translateAssociatedTypeDecl(swift::AssociatedTypeDecl* decl,
                                   codeql::AssociatedTypeDecl* entry) {
    entry->id = dispatcher_.assignNewLabel(decl);
    fillTypeDecl(decl, entry);
  }

  void translateTypeAliasDecl(swift::TypeAliasDecl* decl, codeql::TypeAliasDecl* entry) {
    entry->id = dispatcher_.assignNewLabel(decl);
    fillTypeDecl(decl, entry);
  }

  void translateAccessorDecl(swift::AccessorDecl* decl, codeql::AccessorDecl* entry) {
    entry->id = dispatcher_.assignNewLabel(decl);
    switch (decl->getAccessorKind()) {
      case swift::AccessorKind::Get:
        entry->is_getter = true;
        break;
      case swift::AccessorKind::Set:
        entry->is_setter = true;
        break;
      case swift::AccessorKind::WillSet:
        entry->is_will_set = true;
        break;
      case swift::AccessorKind::DidSet:
        entry->is_did_set = true;
        break;
    }
    fillAbstractFunctionDecl(decl, entry);
  }

  void translateSubscriptDecl(swift::SubscriptDecl* decl, codeql::SubscriptDecl* entry) {
    entry->id = dispatcher_.assignNewLabel(decl);
    entry->element_type = dispatcher_.fetchLabel(decl->getElementInterfaceType());
    if (auto indices = decl->getIndices()) {
      entry->params = dispatcher_.fetchRepeatedLabels(*indices);
    }
    fillAbstractStorageDecl(decl, entry);
  }

 private:
  void fillAbstractFunctionDecl(swift::AbstractFunctionDecl* decl,
                                codeql::AbstractFunctionDecl* entry) {
    assert(decl->hasParameterList() && "Expect functions to have a parameter list");
    entry->name =        !decl->hasName() || decl->getName().isSpecial() ? "(unnamed function decl)"
                                                : decl->getNameStr().str();
    entry->body = dispatcher_.fetchOptionalLabel(decl->getBody());
    entry->params = dispatcher_.fetchRepeatedLabels(*decl->getParameters());
    fillValueDecl(decl, entry);
    fillGenericContext(decl, entry);
  }

  void fillOperatorDecl(swift::OperatorDecl* decl, codeql::OperatorDecl* entry) {
    entry->name = decl->getName().str().str();
  }

  void fillTypeDecl(swift::TypeDecl* decl, codeql::TypeDecl* entry) {
    entry->name = decl->getNameStr().str();
    for (auto& typeLoc : decl->getInherited()) {
      if (auto type = typeLoc.getType()) {
        entry->base_types.push_back(dispatcher_.fetchLabel(type));
      }
    }
    fillValueDecl(decl, entry);
  }

  void fillIterableDeclContext(swift::IterableDeclContext* decl,
                               codeql::IterableDeclContext* entry) {
    entry->members = dispatcher_.fetchRepeatedLabels(decl->getAllMembers());
  }

  void fillAbstractVarDecl(swift::VarDecl* decl, codeql::VarDecl* entry) {
    entry->type = dispatcher_.fetchLabel(decl->getType());
    entry->parent_pattern = dispatcher_.fetchOptionalLabel(decl->getParentPattern());
    entry->parent_initializer = dispatcher_.fetchOptionalLabel(decl->getParentInitializer());
    if (decl->hasAttachedPropertyWrapper()) {
      entry->attached_property_wrapper_type =
          dispatcher_.fetchOptionalLabel(decl->getPropertyWrapperBackingPropertyType());
    }
    fillAbstractStorageDecl(decl, entry);
  }

  void fillNominalTypeDecl(swift::NominalTypeDecl* decl, codeql::NominalTypeDecl* entry) {
    entry->type = dispatcher_.fetchLabel(decl->getDeclaredType());
    fillGenericContext(decl, entry);
    fillIterableDeclContext(decl, entry);
    fillTypeDecl(decl, entry);
  }

  void fillGenericContext(swift::GenericContext* decl, codeql::GenericContext* entry) {
    if (auto params = decl->getGenericParams()) {
      entry->generic_type_params = dispatcher_.fetchRepeatedLabels(*params);
    }
  }

  void fillValueDecl(swift::ValueDecl* decl, codeql::ValueDecl* entry) {
    assert(decl->getInterfaceType() && "Expect ValueDecl to have InterfaceType");
    entry->interface_type = dispatcher_.fetchLabel(decl->getInterfaceType());
  }

  void fillAbstractStorageDecl(swift::AbstractStorageDecl* decl,
                               codeql::AbstractStorageDecl* entry) {
    entry->accessor_decls = dispatcher_.fetchRepeatedLabels(decl->getAllAccessors());
    fillValueDecl(decl, entry);
  }
};

}  // namespace codeql
