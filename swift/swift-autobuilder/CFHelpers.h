#pragma once

#include <CoreFoundation/CoreFoundation.h>
#include <string>
#include <vector>

CFStringRef cf_string_ref(const void* ptr);
CFArrayRef cf_array_ref(const void* ptr);
CFDictionaryRef cf_dictionary_ref(const void* ptr);

std::string stringValueForKey(CFDictionaryRef dict, CFStringRef key);

struct CFKeyValues {
  static CFKeyValues fromDictionary(CFDictionaryRef dict) {
    auto size = CFDictionaryGetCount(dict);
    CFKeyValues ret(size);
    CFDictionaryGetKeysAndValues(dict, ret.keys.data(), ret.values.data());
    return ret;
  }
  explicit CFKeyValues(size_t size) : size(size), keys(size), values(size) {}
  size_t size;
  std::vector<const void*> keys;
  std::vector<const void*> values;
};
