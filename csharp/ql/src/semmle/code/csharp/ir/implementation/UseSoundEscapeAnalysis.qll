import IRConfiguration

/**
 * Overrides the default IR configuration to use sound escape analysis, instead of assuming that
 * variable addresses never escape.
 */
class SoundEscapeAnalysisConfiguration extends IREscapeAnalysisConfiguration {
  override predicate useSoundEscapeAnalysis() { any() }
}
