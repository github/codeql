#ifdef _WIN32
#include "canonicalize.h"
#include <windows.h>
#include <string>
#include <unordered_map>
#include <shared_mutex>
#include <random>

namespace {

class PathCache {
public:
    static PathCache& instance() {
        static PathCache cache;
        return cache;
    }

    const wchar_t* canonicalize(const wchar_t* path) {
        std::wstring key(path);

        // Fast path: shared (read) lock for cache hit
        {
            std::shared_lock lock(mutex_);
            auto it = cache_.find(key);
            if (it != cache_.end()) {
                return _wcsdup(it->second.c_str());
            }
        }

        // Slow path: resolve and insert under exclusive lock
        std::wstring resolved = resolve(path);
        if (resolved.empty()) return nullptr;

        std::unique_lock lock(mutex_);
        // Check again under exclusive lock (another thread may have inserted)
        auto it = cache_.find(key);
        if (it != cache_.end()) {
            return _wcsdup(it->second.c_str());
        }

        // Evict a random entry if at capacity (matches C# strategy)
        if (cache_.size() >= max_capacity_) {
            std::uniform_int_distribution<size_t> dist(0, cache_.size() - 1);
            auto evict = cache_.begin();
            std::advance(evict, dist(rng_));
            cache_.erase(evict);
        }

        auto inserted = cache_.emplace(std::move(key), std::move(resolved)).first;
        return _wcsdup(inserted->second.c_str());
    }

private:
    PathCache() = default;

    static constexpr size_t max_capacity_ = 4096;
    std::unordered_map<std::wstring, std::wstring> cache_;
    std::shared_mutex mutex_;
    std::mt19937 rng_{std::random_device{}()};

    static std::wstring resolve(const wchar_t* path) {
        HANDLE h = CreateFileW(
            path,
            0,
            FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE,
            nullptr,
            OPEN_EXISTING,
            FILE_FLAG_BACKUP_SEMANTICS,
            nullptr);

        if (h == INVALID_HANDLE_VALUE) {
            return resolve_nonexistent(path);
        }

        std::wstring result = get_final_path(h);
        CloseHandle(h);

        if (result.empty()) return {};
        return strip_prefix(result);
    }

    static std::wstring get_final_path(HANDLE h) {
        wchar_t buf[MAX_PATH];
        DWORD len = GetFinalPathNameByHandleW(h, buf, MAX_PATH, FILE_NAME_NORMALIZED);

        if (len > 0 && len < MAX_PATH) {
            return std::wstring(buf, len);
        }
        if (len >= MAX_PATH) {
            std::wstring big(len + 1, L'\0');
            len = GetFinalPathNameByHandleW(h, big.data(), len + 1, FILE_NAME_NORMALIZED);
            if (len > 0) return std::wstring(big.data(), len);
        }
        return {};
    }

    static std::wstring strip_prefix(const std::wstring& path) {
        constexpr std::wstring_view unc_prefix = L"\\\\?\\UNC\\";
        constexpr std::wstring_view lp_prefix = L"\\\\?\\";

        if (path.starts_with(unc_prefix)) {
            return L"\\" + path.substr(unc_prefix.size() - 1);
        }
        if (path.starts_with(lp_prefix)) {
            return std::wstring(path.substr(lp_prefix.size()));
        }
        return path;
    }

    // For non-existent files: canonicalize parent, append filename
    // (matches C#'s ConstructCanonicalPath)
    static std::wstring resolve_nonexistent(const wchar_t* path) {
        std::wstring spath(path);
        auto sep = spath.find_last_of(L"\\/");
        if (sep == std::wstring::npos) return {};

        std::wstring parent = spath.substr(0, sep);
        std::wstring name = spath.substr(sep + 1);

        std::wstring canonical_parent = resolve(parent.c_str());
        if (canonical_parent.empty()) return {};

        return canonical_parent + L"\\" + name;
    }
};

} // namespace

extern "C" {

CODEQL_API const wchar_t* canonicalize_path_w(const wchar_t* path) {
    if (!path || !*path) return nullptr;
    return PathCache::instance().canonicalize(path);
}

CODEQL_API void canonicalize_free_w(const wchar_t* path) {
    free(const_cast<wchar_t*>(path));
}

CODEQL_API const char* canonicalize_path_u8(const char* path) {
    if (!path || !*path) return nullptr;

    int wlen = MultiByteToWideChar(CP_UTF8, 0, path, -1, nullptr, 0);
    if (wlen <= 0) return nullptr;
    std::wstring wpath(wlen - 1, L'\0');
    MultiByteToWideChar(CP_UTF8, 0, path, -1, wpath.data(), wlen);

    const wchar_t* wresult = PathCache::instance().canonicalize(wpath.c_str());
    if (!wresult) return nullptr;

    int ulen = WideCharToMultiByte(CP_UTF8, 0, wresult, -1, nullptr, 0, nullptr, nullptr);
    if (ulen <= 0) { free(const_cast<wchar_t*>(wresult)); return nullptr; }
    char* result = static_cast<char*>(malloc(ulen));
    WideCharToMultiByte(CP_UTF8, 0, wresult, -1, result, ulen, nullptr, nullptr);
    free(const_cast<wchar_t*>(wresult));

    return result;
}

CODEQL_API void canonicalize_free_u8(const char* path) {
    free(const_cast<char*>(path));
}

} // extern "C"
#endif
