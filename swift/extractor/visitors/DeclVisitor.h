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
    emit<ConcreteFuncDeclsTrap>(label);
    emitAbstractFunctionDecl(decl, label);
  }

  void visitConstructorDecl(swift::ConstructorDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    emit<ConstructorDeclsTrap>(label);
    emitConstructorDecl(decl, label);
  }

  void visitDestructorDecl(swift::DestructorDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    emit<DestructorDeclsTrap>(label);
    emitDestructorDecl(decl, label);
  }

  void visitPrefixOperatorDecl(swift::PrefixOperatorDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    emit<PrefixOperatorDeclsTrap>(label);
    emitOperatorDecl(decl, label);
  }

  void visitPostfixOperatorDecl(swift::PostfixOperatorDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    emit<PostfixOperatorDeclsTrap>(label);
    emitOperatorDecl(decl, label);
  }

  void visitInfixOperatorDecl(swift::InfixOperatorDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    emit<InfixOperatorDeclsTrap>(label);
    emitOptional<InfixOperatorDeclPrecedenceGroupsTrap>(label, decl->getPrecedenceGroup());
    emitOperatorDecl(decl, label);
  }

  void visitPrecedenceGroupDecl(swift::PrecedenceGroupDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    emit<PrecedenceGroupDeclsTrap>(label);
  }

  void visitParamDecl(swift::ParamDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    emit<ParamDeclsTrap>(label);
    emitVarDecl(decl, label);
  }

  void visitTopLevelCodeDecl(swift::TopLevelCodeDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    assert(decl->getBody() && "Expect top level code to have body");
    emit<TopLevelCodeDeclsTrap>(label, decl->getBody());
  }

  void visitPatternBindingDecl(swift::PatternBindingDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    emit<PatternBindingDeclsTrap>(label);
    for (unsigned i = 0; i < decl->getNumPatternEntries(); ++i) {
      auto pattern = decl->getPattern(i);
      assert(pattern && "Expect pattern binding decl to have all patterns");
      emit<PatternBindingDeclPatternsTrap>(label, i, pattern);
      if (auto init = decl->getInit(i)) {
        emit<PatternBindingDeclInitsTrap>(label, i, init);
      }
    }
  }

  void visitVarDecl(swift::VarDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    auto introducer = static_cast<uint8_t>(decl->getIntroducer());
    emit<ConcreteVarDeclsTrap>(label, introducer);
    emitVarDecl(decl, label);
  }

  void visitStructDecl(swift::StructDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    emit<StructDeclsTrap>(label);
    emitNominalTypeDecl(decl, label);
  }

  void visitClassDecl(swift::ClassDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    emit<ClassDeclsTrap>(label);
    emitNominalTypeDecl(decl, label);
  }

  void visitEnumDecl(swift::EnumDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    emit<EnumDeclsTrap>(label);
    emitNominalTypeDecl(decl, label);
  }

  void visitProtocolDecl(swift::ProtocolDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    emit<ProtocolDeclsTrap>(label);
    emitNominalTypeDecl(decl, label);
  }

  void visitEnumCaseDecl(swift::EnumCaseDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    emit<EnumCaseDeclsTrap>(label);
    emitRepeated<EnumCaseDeclElementsTrap>(label, decl->getElements());
  }

  void visitEnumElementDecl(swift::EnumElementDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    emit<EnumElementDeclsTrap>(label, decl->getNameStr().str());
    if (decl->hasParameterList()) {
      emitRepeated<EnumElementDeclParamsTrap>(label, *decl->getParameterList());
    }
  }

  void visitGenericTypeParamDecl(swift::GenericTypeParamDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    emit<GenericTypeParamDeclsTrap>(label);
    emitTypeDecl(decl, label);
  }

  void visitAssociatedTypeDecl(swift::AssociatedTypeDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    emit<AssociatedTypeDeclsTrap>(label);
    emitTypeDecl(decl, label);
  }

  void visitTypeAliasDecl(swift::TypeAliasDecl* decl) {
    auto label = dispatcher_.assignNewLabel(decl);
    emit<TypeAliasDeclsTrap>(label);
    emitTypeDecl(decl, label);
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
    assert(decl->hasName() && "Expect functions to have name");
    assert(decl->hasParameterList() && "Expect functions to have a parameter list");
    auto name = decl->getName().isSpecial() ? "(unnamed function decl)" : decl->getNameStr().str();
    emit<AbstractFunctionDeclsTrap>(label, name);
    emitOptional<AbstractFunctionDeclBodiesTrap>(label, decl->getBody());
    emitRepeated<AbstractFunctionDeclParamsTrap>(label, *decl->getParameters());
    emitValueDecl(decl, label);
    emitGenericContext(decl, label);
  }

  void emitOperatorDecl(swift::OperatorDecl* decl, TrapLabel<OperatorDeclTag> label) {
    emit<OperatorDeclsTrap>(label, decl->getName().str().str());
  }

  void emitTypeDecl(swift::TypeDecl* decl, TrapLabel<TypeDeclTag> label) {
    emit<TypeDeclsTrap>(label, decl->getNameStr().str());
    auto i = 0u;
    for (auto& typeLoc : decl->getInherited()) {
      if (auto type = typeLoc.getType()) {
        emit<TypeDeclBaseTypesTrap>(label, i++, type);
      }
    }
    emitValueDecl(decl, label);
  }

  void emitIterableDeclContext(swift::IterableDeclContext* decl,
                               TrapLabel<IterableDeclContextTag> label) {
    emitRepeated<IterableDeclContextMembersTrap>(label, decl->getAllMembers());
  }

  void emitVarDecl(swift::VarDecl* decl, TrapLabel<VarDeclTag> label) {
    auto typeLabel = decl->getType();
    emit<VarDeclsTrap>(label, decl->getNameStr().str(), typeLabel);
    emitOptional<VarDeclParentPatternsTrap>(label, decl->getParentPattern());
    emitOptional<VarDeclParentInitializersTrap>(label, decl->getParentInitializer());
    if (decl->hasAttachedPropertyWrapper()) {
      emitOptional<VarDeclAttachedPropertyWrapperTypesTrap>(
          label, decl->getPropertyWrapperBackingPropertyType());
    }
    emitValueDecl(decl, label);
  }

  void emitNominalTypeDecl(swift::NominalTypeDecl* decl, TrapLabel<NominalTypeDeclTag> label) {
    auto typeLabel = decl->getDeclaredType();
    emit<NominalTypeDeclsTrap>(label, typeLabel);
    emitGenericContext(decl, label);
    emitIterableDeclContext(decl, label);
    emitTypeDecl(decl, label);
  }

  void emitGenericContext(const swift::GenericContext* decl, TrapLabel<GenericContextTag> label) {
    if (auto params = decl->getGenericParams()) {
      emitRepeated<GenericContextGenericTypeParamsTrap>(label, *params);
    }
  }

  void emitValueDecl(const swift::ValueDecl* decl, TrapLabel<ValueDeclTag> label) {
    assert(decl->getInterfaceType() && "Expect ValueDecl to have InterfaceType");
    emit<ValueDeclsTrap>(label, decl->getInterfaceType());
  }
};

}  // namespace codeql
