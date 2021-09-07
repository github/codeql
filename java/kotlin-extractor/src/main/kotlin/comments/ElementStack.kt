package com.github.codeql.comments

import com.github.codeql.Location
import com.github.codeql.getLocation
import org.jetbrains.kotlin.ir.IrElement
import java.util.ArrayDeque

/**
 * Stack of elements, where each element in the stack fully contains the elements above it.
 */
class ElementStack {
    private val stack = ArrayDeque<IrElement>()

    /**
     * Pops all elements from the stack that don't fully contain the new element. And then pushes the element onto the
     * stack.
     */
    fun push(element: IrElement) {
        while (!stack.isEmpty() && !stack.peek().getLocation().contains(element.getLocation())) {
            stack.pop();
        }

        stack.push(element);
    }

    fun findBefore(location: Location) : IrElement? {
        return stack.lastOrNull { it.getLocation().endOffset < location.startOffset }
    }

    fun findAfter(location: Location, next: IrElement?) : IrElement? {
        if (next == null) {
            return null
        }

        val parent = findParent(location) ?: return next;

        if (parent.getLocation().contains(next.getLocation())) {
            return next
        }

        return null
    }

    fun findParent(location: Location) : IrElement? {
        return stack.firstOrNull { it.getLocation().contains(location) }
    }
}