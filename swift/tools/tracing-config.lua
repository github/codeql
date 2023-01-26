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

    function strip_unsupported_args(args)
      strip_unsupported_arg(args, '-emit-localized-strings', 0)
      strip_unsupported_arg(args, '-emit-localized-strings-path', 1)
      strip_unsupported_arg(args, '-stack-check', 0)
      strip_unsupported_arg(args, '-experimental-skip-non-inlinable-function-bodies-without-types', 0)
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
    }
end

-- Return a list of minimum supported versions of the configuration file format
-- return one entry per supported major version.
function GetCompatibleVersions() return {'1.0.0'} end
