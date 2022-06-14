#pragma once

#include <swift/AST/Decl.h>
#include <swift/AST/GenericParamList.h>
#include <swift/AST/ParameterList.h>

#include "swift/extractor/visitors/VisitorBase.h"

namespace codeql {

// `swift::Decl` visitor
// public `visitXXX(swift::XXX* decl)` methods visit concrete declarations
// private `emitXXX(swift::XXX* decl, TrapLabel<XXXTag> label)` are used to fill the properties
// related to an abstract `XXX` entity, given the label assigned to the concrete entry
// In general, `visitXXX/emitXXX` should call `emitYYY` with `YYY` the direct superclass of `XXX`
// (if not `Decl` itself)
// TODO: maybe make the above chain of calls automatic with a bit of macro metaprogramming?
class DeclVisitor : public AstVisitorBase<DeclVisitor> {
 public:
  using AstVisitorBase<DeclVisitor>::AstVisitorBase;

  void visitFuncDecl(swift::FuncDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    dispatcher_.emit(ConcreteFuncDeclsTrap{label});
    emitAbstractFunctionDecl(decl, label);
  }

  void visitConstructorDecl(swift::ConstructorDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    dispatcher_.emit(ConstructorDeclsTrap{label});
    emitConstructorDecl(decl, label);
  }

  void visitDestructorDecl(swift::DestructorDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    dispatcher_.emit(DestructorDeclsTrap{label});
    emitDestructorDecl(decl, label);
  }

  void visitPrefixOperatorDecl(swift::PrefixOperatorDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    dispatcher_.emit(PrefixOperatorDeclsTrap{label});
    emitOperatorDecl(decl, label);
  }

  void visitPostfixOperatorDecl(swift::PostfixOperatorDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    dispatcher_.emit(PostfixOperatorDeclsTrap{label});
    emitOperatorDecl(decl, label);
  }

  void visitInfixOperatorDecl(swift::InfixOperatorDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    dispatcher_.emit(InfixOperatorDeclsTrap{label});
    if (auto group = decl->getPrecedenceGroup()) {
      dispatcher_.emit(InfixOperatorDeclPrecedenceGroupsTrap{label, dispatcher_.fetchLabel(group)});
    }
    emitOperatorDecl(decl, label);
  }

  void visitPrecedenceGroupDecl(swift::PrecedenceGroupDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    dispatcher_.emit(PrecedenceGroupDeclsTrap{label});
  }

  void visitParamDecl(swift::ParamDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    dispatcher_.emit(ParamDeclsTrap{label});
    if (decl->isInOut()) {
      dispatcher_.emit(ParamDeclIsInoutTrap{label});
    }
    emitVarDecl(decl, label);
  }

  void visitTopLevelCodeDecl(swift::TopLevelCodeDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    assert(decl->getBody() && "Expect top level code to have body");
    dispatcher_.emit(TopLevelCodeDeclsTrap{label, dispatcher_.fetchLabel(decl->getBody())});
  }

  void visitPatternBindingDecl(swift::PatternBindingDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    dispatcher_.emit(PatternBindingDeclsTrap{label});
    for (unsigned i = 0; i < decl->getNumPatternEntries(); ++i) {
      auto pattern = decl->getPattern(i);
      assert(pattern && "Expect pattern binding decl to have all patterns");
      dispatcher_.emit(PatternBindingDeclPatternsTrap{label, i, dispatcher_.fetchLabel(pattern)});
      if (auto init = decl->getInit(i)) {
        dispatcher_.emit(PatternBindingDeclInitsTrap{label, i, dispatcher_.fetchLabel(init)});
      }
    }
  }

  void visitVarDecl(swift::VarDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    auto introducer = static_cast<uint8_t>(decl->getIntroducer());
    dispatcher_.emit(ConcreteVarDeclsTrap{label, introducer});
    emitVarDecl(decl, label);
  }

  void visitStructDecl(swift::StructDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    dispatcher_.emit(StructDeclsTrap{label});
    emitNominalTypeDecl(decl, label);
  }

  void visitClassDecl(swift::ClassDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    dispatcher_.emit(ClassDeclsTrap{label});
    emitNominalTypeDecl(decl, label);
  }

  void visitEnumDecl(swift::EnumDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    dispatcher_.emit(EnumDeclsTrap{label});
    emitNominalTypeDecl(decl, label);
  }

  void visitProtocolDecl(swift::ProtocolDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    dispatcher_.emit(ProtocolDeclsTrap{label});
    emitNominalTypeDecl(decl, label);
  }

  void visitEnumCaseDecl(swift::EnumCaseDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    dispatcher_.emit(EnumCaseDeclsTrap{label});
    auto i = 0u;
    for (auto e : decl->getElements()) {
      dispatcher_.emit(EnumCaseDeclElementsTrap{label, i++, dispatcher_.fetchLabel(e)});
    }
  }

  void visitEnumElementDecl(swift::EnumElementDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    dispatcher_.emit(EnumElementDeclsTrap{label, decl->getNameStr().str()});
    if (decl->hasParameterList()) {
      auto i = 0u;
      for (auto p : *decl->getParameterList()) {
        dispatcher_.emit(EnumElementDeclParamsTrap{label, i++, dispatcher_.fetchLabel(p)});
      }
    }
  }

  void visitGenericTypeParamDecl(swift::GenericTypeParamDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    dispatcher_.emit(GenericTypeParamDeclsTrap{label});
    emitTypeDecl(decl, label);
  }

  void visitAssociatedTypeDecl(swift::AssociatedTypeDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    dispatcher_.emit(AssociatedTypeDeclsTrap{label});
    emitTypeDecl(decl, label);
  }

  void visitTypeAliasDecl(swift::TypeAliasDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    dispatcher_.emit(TypeAliasDeclsTrap{label});
    emitTypeDecl(decl, label);
  }

  void visitAccessorDecl(swift::AccessorDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    dispatcher_.emit(AccessorDeclsTrap{label});
    switch (decl->getAccessorKind()) {
      case swift::AccessorKind::Get:
        dispatcher_.emit(AccessorDeclIsGetterTrap{label});
        break;
      case swift::AccessorKind::Set:
        dispatcher_.emit(AccessorDeclIsSetterTrap{label});
        break;
      case swift::AccessorKind::WillSet:
        dispatcher_.emit(AccessorDeclIsWillSetTrap{label});
        break;
      case swift::AccessorKind::DidSet:
        dispatcher_.emit(AccessorDeclIsDidSetTrap{label});
        break;
    }
    emitAccessorDecl(decl, label);
  }

  void visitSubscriptDecl(swift::SubscriptDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    auto elementTypeLabel = dispatcher_.fetchLabel(decl->getElementInterfaceType());
    dispatcher_.emit(SubscriptDeclsTrap{label, elementTypeLabel});
    if (auto indices = decl->getIndices()) {
      for (auto i = 0u; i < indices->size(); ++i) {
        dispatcher_.emit(
            SubscriptDeclParamsTrap{label, i, dispatcher_.fetchLabel(indices->get(i))});
      }
    }
    emitAbstractStorageDecl(decl, label);
  }

  void visitExtensionDecl(swift::ExtensionDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    auto typeLabel = dispatcher_.fetchLabel(decl->getExtendedNominal());
    dispatcher_.emit(ExtensionDeclsTrap{label, typeLabel});
    emitGenericContext(decl, label);
    emitIterableDeclContext(decl, label);
  }

 private:
  void emitConstructorDecl(swift::ConstructorDecl* decl, TrapLabel<ConstructorDeclTag> label) {
    emitAbstractFunctionDecl(decl, label);
  }

  void emitDestructorDecl(swift::DestructorDecl* decl, TrapLabel<DestructorDeclTag> label) {
    emitAbstractFunctionDecl(decl, label);
  }

  void emitAbstractFunctionDecl(swift::AbstractFunctionDecl* decl,
                                TrapLabel<AbstractFunctionDeclTag> label) {
    assert(decl->hasParameterList() && "Expect functions to have a parameter list");
    auto name = !decl->hasName() || decl->getName().isSpecial() ? "(unnamed function decl)"
                                                                : decl->getNameStr().str();
    dispatcher_.emit(AbstractFunctionDeclsTrap{label, name});
    if (auto body = decl->getBody()) {
      dispatcher_.emit(AbstractFunctionDeclBodiesTrap{label, dispatcher_.fetchLabel(body)});
    }
    auto params = decl->getParameters();
    for (auto i = 0u; i < params->size(); ++i) {
      dispatcher_.emit(
          AbstractFunctionDeclParamsTrap{label, i, dispatcher_.fetchLabel(params->get(i))});
    }
    emitValueDecl(decl, label);
    emitGenericContext(decl, label);
  }

  void emitOperatorDecl(swift::OperatorDecl* decl, TrapLabel<OperatorDeclTag> label) {
    dispatcher_.emit(OperatorDeclsTrap{label, decl->getName().str().str()});
  }

  void emitTypeDecl(swift::TypeDecl* decl, TrapLabel<TypeDeclTag> label) {
    dispatcher_.emit(TypeDeclsTrap{label, decl->getNameStr().str()});
    auto i = 0u;
    for (auto& typeLoc : decl->getInherited()) {
      auto type = typeLoc.getType();
      if (type.isNull()) {
        continue;
      }

      dispatcher_.emit(TypeDeclBaseTypesTrap{label, i++, dispatcher_.fetchLabel(type)});
    }
    emitValueDecl(decl, label);
  }

  void emitIterableDeclContext(swift::IterableDeclContext* decl,
                               TrapLabel<IterableDeclContextTag> label) {
    auto i = 0u;
    for (auto& member : decl->getAllMembers()) {
      dispatcher_.emit(IterableDeclContextMembersTrap{label, i++, dispatcher_.fetchLabel(member)});
    }
  }

  void emitVarDecl(swift::VarDecl* decl, TrapLabel<VarDeclTag> label) {
    auto typeLabel = dispatcher_.fetchLabel(decl->getType());
    dispatcher_.emit(VarDeclsTrap{label, decl->getNameStr().str(), typeLabel});
    if (auto pattern = decl->getParentPattern()) {
      dispatcher_.emit(VarDeclParentPatternsTrap{label, dispatcher_.fetchLabel(pattern)});
    }
    if (auto init = decl->getParentInitializer()) {
      dispatcher_.emit(VarDeclParentInitializersTrap{label, dispatcher_.fetchLabel(init)});
    }
    if (decl->hasAttachedPropertyWrapper()) {
      if (auto propertyType = decl->getPropertyWrapperBackingPropertyType();
          !propertyType.isNull()) {
        dispatcher_.emit(
            VarDeclAttachedPropertyWrapperTypesTrap{label, dispatcher_.fetchLabel(propertyType)});
      }
    }
    emitAbstractStorageDecl(decl, label);
  }

  void emitNominalTypeDecl(swift::NominalTypeDecl* decl, TrapLabel<NominalTypeDeclTag> label) {
    auto typeLabel = dispatcher_.fetchLabel(decl->getDeclaredType());
    dispatcher_.emit(NominalTypeDeclsTrap{label, typeLabel});
    emitGenericContext(decl, label);
    emitIterableDeclContext(decl, label);
    emitTypeDecl(decl, label);
  }

  void emitGenericContext(const swift::GenericContext* decl, TrapLabel<GenericContextTag> label) {
    if (auto params = decl->getGenericParams()) {
      auto i = 0u;
      for (auto t : *params) {
        dispatcher_.emit(
            GenericContextGenericTypeParamsTrap{label, i++, dispatcher_.fetchLabel(t)});
      }
    }
  }

  void emitValueDecl(const swift::ValueDecl* decl, TrapLabel<ValueDeclTag> label) {
    assert(decl->getInterfaceType() && "Expect ValueDecl to have InterfaceType");
    dispatcher_.emit(ValueDeclsTrap{label, dispatcher_.fetchLabel(decl->getInterfaceType())});
  }

  void emitAccessorDecl(swift::AccessorDecl* decl, TrapLabel<AccessorDeclTag> label) {
    emitAbstractFunctionDecl(decl, label);
  }

  void emitAbstractStorageDecl(const swift::AbstractStorageDecl* decl,
                               TrapLabel<AbstractStorageDeclTag> label) {
    auto i = 0u;
    for (auto acc : decl->getAllAccessors()) {
      dispatcher_.emit(
          AbstractStorageDeclAccessorDeclsTrap{label, i++, dispatcher_.fetchLabel(acc)});
    }
    emitValueDecl(decl, label);
  }
};

}  // namespace codeql
