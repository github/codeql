#include "swift/extractor/remapping/SwiftFileInterception.h"

#include <fcntl.h>
#include <filesystem>

#include <dlfcn.h>
#include <unistd.h>
#include <mutex>
#include <optional>
#include <cassert>
#include <cstdarg>
#include <iostream>

#include <picosha2.h>

#include "swift/extractor/infra/file/PathHash.h"
#include "swift/extractor/infra/file/Path.h"
#include "swift/logging/SwiftAssert.h"

#ifdef __APPLE__
// path is hardcoded as otherwise redirection could break when setting DYLD_FALLBACK_LIBRARY_PATH
#define SHARED_LIBC "/usr/lib/libc.dylib"
#define FILE_CREATION_MODE O_CREAT
#else
#define SHARED_LIBC "libc.so.6"
#define FILE_CREATION_MODE (O_CREAT | O_TMPFILE)
#endif

namespace fs = std::filesystem;

namespace {

namespace {
codeql::Logger& logger() {
  static codeql::Logger ret{"open_interception"};
  return ret;
}
}  // namespace

namespace original {

void* openLibC() {
  if (auto ret = dlopen(SHARED_LIBC, RTLD_LAZY)) {
    return ret;
  }
  LOG_CRITICAL("Unable to dlopen " SHARED_LIBC "!");
  abort();
}

void* libc() {
  static auto ret = openLibC();
  return ret;
}

template <typename Signature>
Signature get(const char* name) {
  return reinterpret_cast<Signature>(dlsym(libc(), name));
}

int open(const char* path, int flags, mode_t mode = 0) {
  static auto original = get<int (*)(const char*, int, ...)>("open");
  return original(path, flags, mode);
}

}  // namespace original

bool endsWith(const std::string_view& s, const std::string_view& suffix) {
  return s.size() >= suffix.size() && s.substr(s.size() - suffix.size()) == suffix;
}

auto& fileInterceptorInstance() {
  static std::weak_ptr<codeql::FileInterceptor> ret{};
  return ret;
}

bool mayBeRedirected(const char* path, int flags = O_RDONLY) {
  return (!fileInterceptorInstance().expired() && (flags & O_ACCMODE) == O_RDONLY &&
          endsWith(path, ".swiftmodule"));
}

std::optional<std::string> hashFile(const fs::path& path) {
  auto fd = original::open(path.c_str(), O_RDONLY | O_CLOEXEC);
  if (fd < 0) {
    if (errno == ENOENT) {
      LOG_DEBUG("ignoring non-existing module {}", path);
    } else {
      LOG_ERROR("unable to open {} for hashing ({})", path,
                std::make_error_code(static_cast<std::errc>(errno)));
    }
    return std::nullopt;
  }
  auto hasher = picosha2::hash256_one_by_one();
  constexpr size_t bufferSize = 16 * 1024;
  char buffer[bufferSize];
  ssize_t bytesRead = 0;
  while ((bytesRead = ::read(fd, buffer, bufferSize)) > 0) {
    hasher.process(buffer, buffer + bytesRead);
  }
  ::close(fd);
  if (bytesRead < 0) {
    return std::nullopt;
  }
  hasher.finish();
  return get_hash_hex_string(hasher);
}

}  // namespace

namespace codeql {

class FileInterceptor {
 public:
  FileInterceptor(fs::path&& workingDir) : workingDir{std::move(workingDir)} {
    fs::create_directories(hashesPath());
  }

  int open(const char* path, int flags, mode_t mode = 0) const {
    CODEQL_ASSERT((flags & O_ACCMODE) == O_RDONLY, "We should only be intercepting file reads");
    // try to use the hash map first
    errno = 0;
    if (auto hashed = hashPath(path)) {
      if (auto ret = original::open(hashed->c_str(), flags); errno != ENOENT) {
        return ret;
      }
    }
    return original::open(path, flags, mode);
  }

  fs::path redirect(const fs::path& target) const {
    CODEQL_ASSERT(mayBeRedirected(target.c_str()), "Trying to redirect {} which is unsupported",
                  target);
    auto redirected = redirectedPath(target);
    fs::create_directories(redirected.parent_path());
    if (auto hashed = hashPath(target)) {
      std::error_code ec;
      fs::create_symlink(*hashed, redirected, ec);
      if (ec && ec.value() != ENOENT) {
        LOG_WARNING("Cannot remap file {} -> {} ({})", *hashed, redirected, ec);
      }
      return *hashed;
    }
    return redirected;
  }

 private:
  fs::path hashesPath() const { return workingDir / "hashes"; }

  fs::path storePath() const { return workingDir / "store"; }

  fs::path redirectedPath(const fs::path& target) const {
    return storePath() / target.relative_path();
  }

  std::optional<fs::path> hashPath(const fs::path& target) const {
    if (auto hashed = getHashOfRealFile(target)) {
      return hashesPath() / *hashed;
    }
    return std::nullopt;
  }

  fs::path workingDir;
};

std::optional<std::string> getHashOfRealFile(const fs::path& path) {
  static std::unordered_map<fs::path, std::string, codeql::PathHash> cache;
  auto resolved = resolvePath(path);
  if (auto found = cache.find(resolved); found != cache.end()) {
    return found->second;
  }

  if (auto hashed = hashFile(resolved)) {
    cache.emplace(resolved, *hashed);
    return hashed;
  }
  return std::nullopt;
}

fs::path redirect(const fs::path& target) {
  if (auto interceptor = fileInterceptorInstance().lock()) {
    return interceptor->redirect(target);
  } else {
    return target;
  }
}

std::shared_ptr<FileInterceptor> setupFileInterception(
    const SwiftExtractorConfiguration& configuration) {
  auto ret = std::make_shared<FileInterceptor>(configuration.getTempArtifactDir());
  fileInterceptorInstance() = ret;
  return ret;
}
}  // namespace codeql

extern "C" {
int open(const char* path, int flags, ...) {
  mode_t mode = 0;
  if (flags & FILE_CREATION_MODE) {
    va_list ap;
    // mode only applies when creating a file
    va_start(ap, flags);
    mode = va_arg(ap, int);
    va_end(ap);
  }

  if (mayBeRedirected(path, flags)) {
    if (auto interceptor = fileInterceptorInstance().lock()) {
      return interceptor->open(path, flags, mode);
    }
  }
  return original::open(path, flags, mode);
}

}  // namespace codeql
