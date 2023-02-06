function RegisterExtractorPack()
    local goExtractor = GetPlatformToolsDirectory() .. 'go-extractor'
    local patterns = {
        CreatePatternMatcher({'^go%-autobuilder$'}, MatchCompilerName, nil,
                             {trace = false}),
        CreatePatternMatcher({'^go$'}, MatchCompilerName, goExtractor, {
            prepend = {'--mimic', '${compiler}'},
            order = ORDER_BEFORE
        })

    }
    if OperatingSystem == 'windows' then
        goExtractor = goExtractor .. '.exe'
        patterns = {
            CreatePatternMatcher({'^go%-autobuilder%.exe$'}, MatchCompilerName,
                                 nil, {trace = false}),
            CreatePatternMatcher({'^go%.exe$'}, MatchCompilerName, goExtractor,
                                 {
                prepend = {'--mimic', '"${compiler}"'},
                order = ORDER_BEFORE
            })
        }
    end
    return patterns
end

-- Return a list of minimum supported versions of the configuration file format
-- return one entry per supported major version.
function GetCompatibleVersions() return {'1.0.0'} end
