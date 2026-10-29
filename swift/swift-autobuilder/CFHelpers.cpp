#include "swift/swift-autobuilder/CFHelpers.h"

#include <iostream>

typedef CFTypeID (*cf_get_type_id)();

template <typename CFType, cf_get_type_id get_type_id>
CFType cf_cast(const void* ptr) {
  if (!ptr) {
    return nullptr;
  }
  if (CFGetTypeID(ptr) != get_type_id()) {
    std::cerr << "Unexpected type: ";
    CFShow(ptr);
    abort();
  }
  return static_cast<CFType>(ptr);
}

CFStringRef cf_string_ref(const void* ptr) {
  return cf_cast<CFStringRef, CFStringGetTypeID>(ptr);
}

CFArrayRef cf_array_ref(const void* ptr) {
  return cf_cast<CFArrayRef, CFArrayGetTypeID>(ptr);
}
CFDictionaryRef cf_dictionary_ref(const void* ptr) {
  return cf_cast<CFDictionaryRef, CFDictionaryGetTypeID>(ptr);
}

std::string stringValueForKey(CFDictionaryRef dict, CFStringRef key) {
  auto cfValue = cf_string_ref(CFDictionaryGetValue(dict, key));
  if (cfValue) {
    const int bufferSize = 256;
    char buf[bufferSize];
    if (CFStringGetCString(cfValue, buf, bufferSize, kCFStringEncodingUTF8)) {
      return {buf};
    }
  }
  return {};
}
