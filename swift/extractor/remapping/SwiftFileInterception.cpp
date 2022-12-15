#include "swift/extractor/remapping/SwiftFileInterception.h"

#include <fcntl.h>
#include <filesystem>

#include <dlfcn.h>
#include <mutex>
#include <optional>
#include <cassert>

#include "swift/extractor/infra/file/FileHash.h"
#include "swift/extractor/infra/file/FileHash.h"

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
namespace original {

void* openLibC() {
  if (auto ret = dlopen(SHARED_LIBC, RTLD_LAZY)) {
    return ret;
  }
  std::cerr << "Unable to dlopen " SHARED_LIBC "!\n";
  std::abort();
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

}  // namespace

namespace codeql {

class FileInterceptor {
 public:
  FileInterceptor(fs::path&& workingDir) : workingDir{std::move(workingDir)} {
    fs::create_directories(hashesPath());
    fs::create_directories(storePath());
  }

  int open(const char* path, int flags, mode_t mode = 0) const {
    fs::path fsPath{path};
    assert((flags & O_ACCMODE) == O_RDONLY);
    errno = 0;
    // first, try the same path underneath the artifact store
    if (auto ret = original::open(redirectedPath(path).c_str(), flags);
        ret >= 0 || errno != ENOENT) {
      return ret;
    }
    errno = 0;
    // then try to use the hash map
    if (auto hashed = hashPath(path)) {
      if (auto ret = original::open(hashed->c_str(), flags); ret >= 0 || errno != ENOENT) {
        return ret;
      }
    }
    return original::open(path, flags, mode);
  }

  fs::path redirect(const fs::path& target) const {
    assert(mayBeRedirected(target.c_str()));
    auto ret = redirectedPath(target);
    fs::create_directories(ret.parent_path());
    if (auto hashed = hashPath(target)) {
      std::error_code ec;
      fs::create_symlink(ret, *hashed, ec);
      if (ec) {
        std::cerr << "Cannot remap file " << ret << " -> " << *hashed << ": " << ec.message()
                  << "\n";
      }
    }
    return ret;
  }

 private:
  fs::path hashesPath() const { return workingDir / "hashes"; }

  fs::path storePath() const { return workingDir / "store"; }

  fs::path redirectedPath(const fs::path& target) const {
    return storePath() / target.relative_path();
  }

  std::optional<fs::path> hashPath(const fs::path& target) const {
    if (auto fd = original::open(target.c_str(), O_RDONLY | O_CLOEXEC); fd >= 0) {
      return hashesPath() / hashFile(fd);
    }
    return std::nullopt;
  }

  fs::path workingDir;
};

int openReal(const fs::path& path) {
  return original::open(path.c_str(), O_RDONLY | O_CLOEXEC);
}

fs::path redirect(const fs::path& target) {
  if (auto interceptor = fileInterceptorInstance().lock()) {
    return interceptor->redirect(target);
  } else {
    return target;
  }
}

std::shared_ptr<FileInterceptor> setupFileInterception(fs::path workginDir) {
  auto ret = std::make_shared<FileInterceptor>(std::move(workginDir));
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
