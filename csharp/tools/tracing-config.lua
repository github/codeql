function RegisterExtractorPack()
    local extractorDirectory = "tools" .. PathSep .. PlatformDirectory ..
                                   PathSep
    local csharpExtractor = extractorDirectory ..
                                'Semmle.Extraction.CSharp.Driver'
    if OperatingSystem == 'windows' then
        csharpExtractor = extractorDirectory ..
                              'Semmle.Extraction.CSharp.Driver.exe'
    end

    -- TODO Windows support for the entire file
    -- everything here is very experimental and only a proof of concept
    function DotnetMatcherBuild(compilerName, compilerPath, argv)
        if compilerName ~= 'dotnet' then return nil end

        -- this is probably too simplistic, but works for now
        local match = false
        for _, arg in ipairs(argv) do
            if arg == 'build' then
                match = true
                break
            end
        end
        if match then
            table.insert(argv, '/p:UseSharedCompilation=false')
            return {
                trace = true,
                replace = true,
                invocations = {{path = compilerPath, argv = argv}}
            }
        else
            return nil
        end
    end

    function DotnetMatcherExec(compilerName, compilerPath, argv)
        if compilerName ~= 'dotnet' then return nil end
        -- TODO on windows this doesn't split argv correctly
        local match = false
        local newArgv = {'--compiler'}
        for i, arg in ipairs(argv) do
            -- TODO check if this is the correct regex, or if it should be more specific (and escape the dots!)
            if arg:match('csc.exe') or arg:match('mcs.exe') or
                arg:match('csc.dll') then
                match = true
                -- newArgv contains all elements of argv from i+1 to the end
                table.insert(newArgv, arg)
                table.insert(newArgv, '--cil')
                for j = i + 1, #argv do
                    table.insert(newArgv, argv[j])
                end
                break
            end
        end
        if match then
            return {
                trace = true,
                replace = false,
                invocations = {
                    {
                        path = GetExtractorPath('csharp', csharpExtractor),
                        argv = newArgv
                    }
                }
            }
        else
            return nil
        end
    end

    -- TODO windows matchers patterns
    local matchers = {
        CreatePatternMatcher('csharp', {'^mcs.exe$', '^csc.exe$'},
                             MatchCompilerName, csharpExtractor,
                             {prepend = {'--compiler', '${compiler}', '--cil'}}),
        DotnetMatcherBuild, DotnetMatcherExec
    }

    RegisterLanguage('csharp', matchers)
end
