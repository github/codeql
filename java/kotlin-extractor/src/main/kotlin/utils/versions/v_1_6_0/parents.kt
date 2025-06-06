package org.jetbrains.kotlin.ir.util

import org.jetbrains.kotlin.backend.common.lower.parents as kParents
import org.jetbrains.kotlin.backend.common.lower.parentsWithSelf as kParentsWithSelf
import org.jetbrains.kotlin.ir.declarations.*

val IrDeclaration.parents: Sequence<IrDeclarationParent>
    get() = this.kParents

val IrDeclaration.parentsWithSelf: Sequence<IrDeclarationParent>
    get() = this.kParentsWithSelf
