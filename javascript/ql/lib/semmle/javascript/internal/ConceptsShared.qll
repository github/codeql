/**
 * Provides Concepts which are shared across languages.
 *
 * Each language has a language specific `Concepts.qll` file that can import the
 * shared concepts from this file. A language can either re-export the concept directly,
 * or can add additional member-predicates that are needed for that language.
 *
 * Moving forward, `Concepts.qll` will be the staging ground for brand new concepts from
 * each language, but we will maintain a discipline of moving those concepts to
 * `ConceptsShared.qll` ASAP.
 */

private import ConceptsImports
