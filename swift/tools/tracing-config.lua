function RegisterExtractorPack(id)
    local extractorDirectory = GetPlatformToolsDirectory()
    local relativeSwiftExtractor = extractorDirectory .. 'extractor'
    local swiftExtractor = AbsolutifyExtractorPath(id, relativeSwiftExtractor)

    function indexOf(array, value)
      for i, v in ipairs(array) do
        if v == value then
          return i
        end
      end
      return nil
    end

    -- removes unsupported CLI arg including the following how_many args
    function strip_unsupported_arg(args, arg, how_many)
      local index = indexOf(args, arg)
      if index then
        table.remove(args, index)
        while (how_many > 0)
        do
          table.remove(args, index)
          how_many = how_many - 1
        end
      end
    end

    -- removes unsupported -Xcc flag, e.g, calling strip_unsupported_xcc_arg('-foo', 2) against
    -- swift -Xcc -foo -Xcc -bar main.swift
    -- will only leave 'swift main.swift' removing both -Xcc -foo, and also -Xcc -bar
    -- removes unsupported CLI arg passed to clang via -Xcc together with the following how_many args
    function strip_unsupported_clang_arg(args, arg, how_many)
        local index = indexOf(args, arg)
        if index and index > 0 and args[index - 1] == '-Xcc' then
            index = index - 1  -- start from -Xcc
            how_many = 2 * (how_many + 1)  -- need to remove initial -Xcc <arg> as well as following -Xcc prefixed flags
            while (how_many > 0)
            do
                table.remove(args, index)
                how_many = how_many - 1
            end
        end
    end

    function strip_unsupported_args(args)
      strip_unsupported_arg(args, '-emit-localized-strings', 0)
      strip_unsupported_arg(args, '-emit-localized-strings-path', 1)
      strip_unsupported_arg(args, '-stack-check', 0)
      strip_unsupported_arg(args, '-experimental-skip-non-inlinable-function-bodies-without-types', 0)
      strip_unsupported_clang_arg(args, '-ivfsstatcache', 1)

      -- new in 5.8
      strip_unsupported_arg(args, '-strict-implicit-module-context', 0)
      strip_unsupported_arg(args, '-no-strict-implicit-module-context', 0)
      strip_unsupported_arg(args, '-Rindexing-system-module', 0)
      strip_unsupported_arg(args, '-Rskip-explicit-interface-build', 0)
      strip_unsupported_arg(args, '-require-explicit-availability=error', 0)
      strip_unsupported_arg(args, '-require-explicit-availability=warn', 0)
      strip_unsupported_arg(args, '-require-explicit-availability=ignore', 0)
      strip_unsupported_arg(args, '-package-name', 1)
      strip_unsupported_arg(args, '-emit-const-values', 0)
      strip_unsupported_arg(args, '-emit-const-values-path', 1)
      strip_unsupported_arg(args, '-emit-clang-header-nonmodular-includes', 1)
      strip_unsupported_arg(args, '-experimental-c-foreign-reference-types', 0)
      strip_unsupported_arg(args, '-enable-experimental-cxx-interop-in-clang-header', 0)
      strip_unsupported_arg(args, '-suppress-remarks', 0)
      strip_unsupported_arg(args, '-enable-experimental-feature', 1)
      strip_unsupported_arg(args, '-enable-upcoming-feature', 1)
      strip_unsupported_arg(args, '-enable-default-cmo', 0)
      strip_unsupported_arg(args, '-emit-parse', 0)
      strip_unsupported_arg(args, '-emit-ast', 0)
      strip_unsupported_arg(args, '-index-include-locals', 0)
      strip_unsupported_arg(args, '-allowable-client', 1)
      strip_unsupported_arg(args, '-enable-autolinking-runtime-compatibility-bytecode-layouts', 0)
      strip_unsupported_arg(args, '-emit-extension-block-symbols', 0)
      strip_unsupported_arg(args, '-omit-extension-block-symbols', 0)
      strip_unsupported_arg(args, '-disable-remove-deprecated-check', 0)
      strip_unsupported_arg(args, '--disable-remove-deprecated-check', 0)
    end

    -- xcodebuild does not always specify the -resource-dir in which case the compiler falls back
    -- to a resource-dir based on its path
    -- here we mimic this behavior externally
    -- without a proper -resource-dir compiler-specific headers cannot be found which leads to
    -- broken extraction
    function insert_resource_dir_if_needed(compilerPath, args)
      local resource_dir_index = indexOf(args, '-resource-dir')
      if resource_dir_index then
        return
      end
      -- derive -resource-dir based on the compilerPath
      -- e.g.: /usr/bin/swift-frontend -> /usr/bin/../lib/swift
      local last_slash_index = string.find(compilerPath, "/[^/]*$")
      local compiler_dir = string.sub(compilerPath, 1, last_slash_index)
      local resource_dir = compiler_dir .. '../lib/swift'
      table.insert(args, '-resource-dir')
      table.insert(args, resource_dir)
    end

    function SwiftMatcher(compilerName, compilerPath, compilerArguments, lang)
        -- Only match binaries names `swift-frontend`
        if compilerName ~= 'swift-frontend' then return nil end
        -- Skip the invocation in case it's not called in `-frontend` mode
        if compilerArguments.argv[1] ~= '-frontend' then return nil end

        -- Drop the `-frontend` argument
        table.remove(compilerArguments.argv, 1)

        -- Skip "info" queries in case there is nothing to extract
        if compilerArguments.argv[1] == '-print-target-info' then
          return nil
        end
        if compilerArguments.argv[1] == '-emit-supported-features' then
          return nil
        end

        strip_unsupported_args(compilerArguments.argv)
        insert_resource_dir_if_needed(compilerPath, compilerArguments.argv)

        return {
            trace = true,
            replace = false,
            order = ORDER_AFTER,
            invocation = {path = swiftExtractor, arguments = compilerArguments}
        }
    end
    return {
      SwiftMatcher,
      CreatePatternMatcher({'^lsregister$'}, MatchCompilerName, nil,
                           {trace = false}),
      CreatePatternMatcher({'^sandbox%-exec$'}, MatchCompilerName, nil,
                           {trace = false}),
    }
end

-- Return a list of minimum supported versions of the configuration file format
-- return one entry per supported major version.
function GetCompatibleVersions() return {'1.0.0'} end
