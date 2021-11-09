function RegisterExtractorPack()
    local goExtractor = GetPlatformToolsDirectory() .. 'go-extractor'
    if OperatingSystem == 'windows' then
        local goExtractor = GetPlatformToolsDirectory() .. 'go-extractor.exe'
    end
    local matchers = {
        CreatePatternMatcher('go',
                             {'^go-autobuilder$', '^go-autobuilder%.exe$'},
                             MatchCompilerName, nil, {trace = false}),

        CreatePatternMatcher('go', {'^go$', '^go%.exe$'}, MatchCompilerName,
                             goExtractor, {prepend = {'--mimic', '${compiler}'}})
    }

    RegisterLanguage('go', matchers)
end

-- Return a list of minimum supported versions of the configuration file format
-- return one entry per supported major version.
function GetCompatibleVersions() return {'1.0.0'} end
