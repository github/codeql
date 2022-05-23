function RegisterExtractorPack(id)
    local extractorDirectory = GetPlatformToolsDirectory()
    local relativeSwiftExtractor = extractorDirectory .. 'extractor'
    local swiftExtractor = AbsolutifyExtractorPath(id, relativeSwiftExtractor)

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

        -- Skip actions in which we cannot extract anything
        if compilerArguments.argv[1] == '-merge-modules' then return nil end

        return {
            trace = true,
            replace = false,
            order = ORDER_AFTER,
            invocation = {path = swiftExtractor, arguments = compilerArguments}
        }
    end
    return {SwiftMatcher}
end

-- Return a list of minimum supported versions of the configuration file format
-- return one entry per supported major version.
function GetCompatibleVersions() return {'1.0.0'} end
