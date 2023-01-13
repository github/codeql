#include "swift/extractor/remapping/SwiftFileInterception.h"

#include <fcntl.h>
#include <filesystem>

#include <dlfcn.h>
#include <mutex>
#include <optional>
#include <cassert>

#include "swift/extractor/infra/file/FileHash.h"
#include "swift/extractor/infra/file/PathHash.h"
#include "swift/extractor/infra/file/Path.h"

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
  FileInterceptor(fs::path&& workingDir, fs::path&& hashCacheDir)
      : workingDir{std::move(workingDir)}, hashCacheDir{std::move(hashCacheDir)} {
    fs::create_directories(hashesPath());
  }

  int open(const char* path, int flags, mode_t mode = 0) const {
    fs::path fsPath{path};
    assert((flags & O_ACCMODE) == O_RDONLY);
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
    if (auto hashed = getHashOfRealFile(hashCacheDir, target)) {
      return hashesPath() / *hashed;
    }
    return std::nullopt;
  }

  fs::path workingDir;
  fs::path hashCacheDir;
};

std::optional<std::string> getHashOfRealFile(const fs::path& cacheDir,
                                             const std::filesystem::path& path) {
  auto resultLink = cacheDir / resolvePath(path).relative_path();
  std::error_code ec;
  if (auto result = read_symlink(resultLink, ec); !ec) {
    return result.string();
  } else if (ec == std::errc::no_such_file_or_directory) {
    if (auto fd = original::open(path.c_str(), O_RDONLY | O_CLOEXEC); fd >= 0) {
      if (auto hashed = hashFile(fd); !hashed.empty()) {
        fs::create_directories(resultLink.parent_path(), ec);
        if (!ec) {
          fs::create_symlink(hashed, resultLink, ec);
        }
        if (ec) {
          std::cerr << "Unable to cache hash result (" << ec.message() << ")";
        }
        return hashed;
      }
    }
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
  auto ret = std::make_shared<FileInterceptor>(configuration.getTempArtifactDir(),
                                               configuration.getHashCacheDir());
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
