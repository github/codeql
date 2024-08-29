/**
 * INTERNAL: Do not use.
 * This module defines the IPA layer on top of raw DB entities, and the conversions between the two
 * layers.
 */

private import codeql.rust.generated.SynthConstructors
private import codeql.rust.generated.Raw

cached
module Synth {
  /**
   * INTERNAL: Do not use.
   * The synthesized type of all elements.
   */
  cached
  newtype TElement =
    /**
     * INTERNAL: Do not use.
     */
    TDbFile(Raw::DbFile id) { constructDbFile(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TDbLocation(Raw::DbLocation id) { constructDbLocation(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TFunction(Raw::Function id) { constructFunction(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TModule(Raw::Module id) { constructModule(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TUnknownFile() or
    /**
     * INTERNAL: Do not use.
     */
    TUnknownLocation()

  /**
   * INTERNAL: Do not use.
   */
  class TDeclaration = TFunction or TModule;

  /**
   * INTERNAL: Do not use.
   */
  class TFile = TDbFile or TUnknownFile;

  /**
   * INTERNAL: Do not use.
   */
  class TLocatable = TDeclaration;

  /**
   * INTERNAL: Do not use.
   */
  class TLocation = TDbLocation or TUnknownLocation;

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TDbFile`, if possible.
   */
  cached
  TDbFile convertDbFileFromRaw(Raw::Element e) { result = TDbFile(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TDbLocation`, if possible.
   */
  cached
  TDbLocation convertDbLocationFromRaw(Raw::Element e) { result = TDbLocation(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TFunction`, if possible.
   */
  cached
  TFunction convertFunctionFromRaw(Raw::Element e) { result = TFunction(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TModule`, if possible.
   */
  cached
  TModule convertModuleFromRaw(Raw::Element e) { result = TModule(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TUnknownFile`, if possible.
   */
  cached
  TUnknownFile convertUnknownFileFromRaw(Raw::Element e) { none() }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TUnknownLocation`, if possible.
   */
  cached
  TUnknownLocation convertUnknownLocationFromRaw(Raw::Element e) { none() }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TDeclaration`, if possible.
   */
  cached
  TDeclaration convertDeclarationFromRaw(Raw::Element e) {
    result = convertFunctionFromRaw(e)
    or
    result = convertModuleFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TElement`, if possible.
   */
  cached
  TElement convertElementFromRaw(Raw::Element e) {
    result = convertFileFromRaw(e)
    or
    result = convertLocatableFromRaw(e)
    or
    result = convertLocationFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TFile`, if possible.
   */
  cached
  TFile convertFileFromRaw(Raw::Element e) {
    result = convertDbFileFromRaw(e)
    or
    result = convertUnknownFileFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TLocatable`, if possible.
   */
  cached
  TLocatable convertLocatableFromRaw(Raw::Element e) { result = convertDeclarationFromRaw(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TLocation`, if possible.
   */
  cached
  TLocation convertLocationFromRaw(Raw::Element e) {
    result = convertDbLocationFromRaw(e)
    or
    result = convertUnknownLocationFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDbFile` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDbFileToRaw(TDbFile e) { e = TDbFile(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDbLocation` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDbLocationToRaw(TDbLocation e) { e = TDbLocation(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TFunction` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertFunctionToRaw(TFunction e) { e = TFunction(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TModule` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertModuleToRaw(TModule e) { e = TModule(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TUnknownFile` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnknownFileToRaw(TUnknownFile e) { none() }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TUnknownLocation` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnknownLocationToRaw(TUnknownLocation e) { none() }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDeclaration` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDeclarationToRaw(TDeclaration e) {
    result = convertFunctionToRaw(e)
    or
    result = convertModuleToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TElement` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertElementToRaw(TElement e) {
    result = convertFileToRaw(e)
    or
    result = convertLocatableToRaw(e)
    or
    result = convertLocationToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TFile` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertFileToRaw(TFile e) {
    result = convertDbFileToRaw(e)
    or
    result = convertUnknownFileToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TLocatable` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertLocatableToRaw(TLocatable e) { result = convertDeclarationToRaw(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TLocation` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertLocationToRaw(TLocation e) {
    result = convertDbLocationToRaw(e)
    or
    result = convertUnknownLocationToRaw(e)
  }
}
