/**
 * @name AV Rule 156
 * @description All the members of a structure (or class) shall be named
 *              and shall only be accessed via their names.
 * @kind problem
 * @id cpp/jsf/av-rule-156
 * @problem.severity warning
 * @precision low
 * @tags correctness
 *       external/jsf
 */

import cpp

/*
 * TODO: what about the "shall only be accessed" part?
 * TODO: implement better check for namelessness (at the moment we rely on the fact
 *       that the frontend creates dummy names of the form "(unnamed X)" for nameless members)
 */

from Declaration m
where
  m.isMember() and
  m.getName().matches("(%") and
  not m.(BitField).getDeclaredNumBits() = 0
select m,
  "AV Rule 156: All the members of a structure (or class) shall be named and shall only be accessed via their names."
