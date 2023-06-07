/**
 * Provides modeling for the Rack library.
 */

/**
 * Provides modeling for the Rack library.
 */
module Rack {
  import rack.internal.App
  import rack.internal.Mime
  import rack.internal.Response::Public as Response

  /** DEPRECATED: Alias for App::AppCandidate */
  deprecated class AppCandidate = App::AppCandidate;
}
