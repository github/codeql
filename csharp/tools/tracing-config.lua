function RegisterExtractorPack(id)
    local extractor = GetPlatformToolsDirectory() ..
                          'Semmle.Extraction.CSharp.Driver'
    if OperatingSystem == 'windows' then extractor = extractor .. '.exe' end

    function DotnetMatcherBuild(compilerName, compilerPath, compilerArguments,
                                _languageId)
        if compilerName ~= 'dotnet' and compilerName ~= 'dotnet.exe' then
            return nil
        end

        -- The dotnet CLI has the following usage instructions:
        -- dotnet [sdk-options] [command] [command-options] [arguments]
        -- we are interested in dotnet build, which has the following usage instructions:
        -- dotnet [options] build [<PROJECT | SOLUTION>...]
        -- For now, parse the command line as follows:
        -- Everything that starts with `-` (or `/`) will be ignored.
        -- The first non-option argument is treated as the command.
        -- if that's `build`, we append `/p:UseSharedCompilation=false` to the command line,
        -- otherwise we do nothing.
        local match = false
        local argv = compilerArguments.argv
        if OperatingSystem == 'windows' then
            -- let's hope that this split matches the escaping rules `dotnet` applies to command line arguments
            -- or, at least, that it is close enough
            argv =
                NativeArgumentsToArgv(compilerArguments.nativeArgumentPointer)
        end
        for i, arg in ipairs(argv) do
            -- dotnet options start with either - or / (both are legal)
            local firstCharacter = string.sub(arg, 1, 1)
            if not (firstCharacter == '-') and not (firstCharacter == '/') then
                Log(1, 'Dotnet subcommand detected: %s', arg)
                if arg == 'build' then match = true end
                break
            end
        end
        if match then
            return {
                order = ORDER_REPLACE,
                invocation = BuildExtractorInvocation(id, compilerPath,
                                                      compilerPath,
                                                      compilerArguments, nil, {
                    '/p:UseSharedCompilation=false'
                })
            }
        end
        return nil
    end

    local windowsMatchers = {
        DotnetMatcherBuild,
        CreatePatternMatcher({'^dotnet%.exe$'}, MatchCompilerName, extractor, {
            prepend = {'--dotnetexec', '--cil'},
            order = ORDER_BEFORE
        }),
        CreatePatternMatcher({'^csc.*%.exe$'}, MatchCompilerName, extractor, {
            prepend = {'--compiler', '"${compiler}"', '--cil'},
            order = ORDER_BEFORE
        }),
        CreatePatternMatcher({'^fakes.*%.exe$', 'moles.*%.exe'},
                             MatchCompilerName, nil, {trace = false})
    }
    local posixMatchers = {
        DotnetMatcherBuild,
        CreatePatternMatcher({'^mono', '^dotnet$'}, MatchCompilerName,
                             extractor, {
            prepend = {'--dotnetexec', '--cil'},
            order = ORDER_BEFORE
        }),
        CreatePatternMatcher({'^mcs%.exe$', '^csc%.exe$'}, MatchCompilerName,
                             extractor, {
            prepend = {'--compiler', '"${compiler}"', '--cil'},
            order = ORDER_BEFORE
        }), function(compilerName, compilerPath, compilerArguments, _languageId)
            if MatchCompilerName('^msbuild$', compilerName, compilerPath,
                                 compilerArguments) or
                MatchCompilerName('^xbuild$', compilerName, compilerPath,
                                  compilerArguments) then
                return {
                    order = ORDER_REPLACE,
                    invocation = BuildExtractorInvocation(id, compilerPath,
                                                          compilerPath,
                                                          compilerArguments,
                                                          nil, {
                        '/p:UseSharedCompilation=false'
                    })

                }
            end
        end
    }
    if OperatingSystem == 'windows' then
        return windowsMatchers
    else
        return posixMatchers
    end
end

-- Return a list of minimum supported versions of the configuration file format
-- return one entry per supported major version.
function GetCompatibleVersions() return {'1.0.0'} end
