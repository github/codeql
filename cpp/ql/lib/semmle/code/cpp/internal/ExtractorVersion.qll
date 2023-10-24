/**
 * INTERNAL: Do not use. Provides predicates for getting the CodeQL and frontend
 * version used during database extraction.
 */

/** Get the extractor CodeQL version */
string getExtractorCodeQLVersion() { extractor_version(result, _) }

/** Get the extractor frontend version */
string getExtractorFrontendVersion() { extractor_version(_, result) }
