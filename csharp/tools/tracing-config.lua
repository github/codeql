function RegisterExtractorPack(id)
    function Exify(path)
        if OperatingSystem == 'windows' then return path .. '.exe' else return path end
    end

    local extractor = Exify(GetPlatformToolsDirectory() .. 'Semmle.Extraction.CSharp.Driver')

    local function isDotnet(name)
        return name == 'dotnet' or name == 'dotnet.exe'
    end

    local function isDotnetPath(path)
        return path:match('dotnet[.]exe$') or path:match('dotnet$')
    end

    local function isPossibleDotnetSubcommand(arg)
        -- dotnet options start with either - or / (both are legal)
        -- It is possible to run dotnet with dotnet, e.g., `dotnet dotnet build`
        -- but we shouldn't consider `dotnet` to be a subcommand.
        local firstCharacter = string.sub(arg, 1, 1)
        return not (firstCharacter == '-') and
               not (firstCharacter == '/') and
               not isDotnetPath(arg)
    end

    local function isPathToExecutable(path)
        return path:match('%.exe$') or path:match('%.dll')
    end

    function DotnetMatcherBuild(compilerName, compilerPath, compilerArguments,
                                _languageId)
        if not isDotnet(compilerName) then
            return nil
        end

        -- The dotnet CLI has the following usage instructions:
        -- dotnet [sdk-options] [command] [command-options] [arguments] OR
        -- dotnet [runtime-options] [path-to-application] [arguments]
        -- we are interested in dotnet build, which has the following usage instructions:
        -- dotnet [options] build [<PROJECT | SOLUTION>...]
        -- For now, parse the command line as follows:
        -- Everything that starts with `-` (or `/`) will be ignored.
        -- The first non-option argument is treated as the command (except if it is dotnet itself).
        -- if that's `build` or similar, we append `-p:UseSharedCompilation=false`
        -- and `-p:EmitCompilerGeneratedFiles=true` to the command line,
        -- otherwise we do nothing.
        local match = false
        local testMatch = false
        local dotnetRunNeedsSeparator = false;
        local dotnetRunInjectionIndex = nil;
        -- A flag indicating whether we are in a position where we expect a sub-command such as `build`.
        -- Once we have found one, we set this to `false` to not accidentally pick up on things that
        -- look like sub-command names later on in the argument vector.
        local inSubCommandPosition = true;
        local argv = compilerArguments.argv
        if OperatingSystem == 'windows' then
            -- let's hope that this split matches the escaping rules `dotnet` applies to command line arguments
            -- or, at least, that it is close enough
            argv =
            NativeArgumentsToArgv(compilerArguments.nativeArgumentPointer)
        end
        for i, arg in ipairs(argv) do
            -- if dotnet is being used to execute any application except dotnet itself, we should
            -- not inject any flags.
            if not match and isPathToExecutable(arg) and not isDotnetPath(arg) then
                Log(1, 'Execute a .NET application usage detected')
                Log(1, 'Dotnet path-to-application detected: %s', arg)
                break
            end
            if isPossibleDotnetSubcommand(arg) then
                if not match and inSubCommandPosition then
                    Log(1, 'Execute a .NET SDK command usage detected')
                    Log(1, 'Dotnet subcommand detected: %s', arg)
                end
                -- only respond to strings that look like sub-command names if we have not yet
                -- encountered something that looks like a sub-command
                if inSubCommandPosition then
                    if arg == 'build' or arg == 'msbuild' or arg == 'publish' or arg == 'pack' then
                        match = true
                        break
                    end
                    if arg == 'run' then
                        -- for `dotnet run`, we need to make sure that `-p:UseSharedCompilation=false` is
                        -- not passed in as an argument to the program that is run
                        match = true
                        dotnetRunNeedsSeparator = true
                        dotnetRunInjectionIndex = i + 1
                    end
                    if arg == 'test' then
                        match = true
                        testMatch = true
                    end
                end

                -- we have found a sub-command, ignore all strings that look like sub-command names from now on
                inSubCommandPosition = false
            end
            -- for `dotnet test`, we should not append `-p:UseSharedCompilation=false` to the command line
            -- if an `exe` or `dll` is passed as an argument as the call is forwarded to vstest.
            if testMatch and isPathToExecutable(arg) then
                match = false
                break
            end
            -- if we see a separator to `dotnet run`, inject just prior to the existing separator
            if arg == '--' then
                dotnetRunNeedsSeparator = false
                dotnetRunInjectionIndex = i
                break
            end
            -- if we see an option to `dotnet run` (e.g., `--project`), inject just prior
            -- to the last option
            if string.sub(arg, 1, 1) == '-' then
                dotnetRunNeedsSeparator = false
                dotnetRunInjectionIndex = i
            end
        end
        if match then
            local injections = { '-p:UseSharedCompilation=false', '-p:EmitCompilerGeneratedFiles=true' }
            if dotnetRunNeedsSeparator then
                table.insert(injections, '--')
            end
            if dotnetRunInjectionIndex == nil then
                -- Simple case; just append at the end
                return {
                    order = ORDER_REPLACE,
                    invocation = BuildExtractorInvocation(id, compilerPath, compilerPath, compilerArguments, nil,
                        injections)
                }
            end

            -- Complex case; splice injections into the middle of the command line
            for i, injectionArg in ipairs(injections) do
                table.insert(argv, dotnetRunInjectionIndex + i - 1, injectionArg)
            end

            if OperatingSystem == 'windows' then
                return {
                    order = ORDER_REPLACE,
                    invocation = {
                        path = AbsolutifyExtractorPath(id, compilerPath),
                        arguments = {
                            commandLineString = ArgvToCommandLineString(argv)
                        }
                    }
                }
            else
                return {
                    order = ORDER_REPLACE,
                    invocation = {
                        path = AbsolutifyExtractorPath(id, compilerPath),
                        arguments = {
                            argv = argv
                        }
                    }
                }
            end
        end
        return nil
    end

    function MsBuildMatcher(compilerName, compilerPath, compilerArguments, _languageId)
        if MatchCompilerName('^' .. Exify('msbuild') .. '$', compilerName, compilerPath,
            compilerArguments) or
            MatchCompilerName('^' .. Exify('xbuild') .. '$', compilerName, compilerPath,
                compilerArguments) then
            return {
                order = ORDER_REPLACE,
                invocation = BuildExtractorInvocation(id, compilerPath,
                    compilerPath,
                    compilerArguments,
                    nil, {
                    '/p:UseSharedCompilation=false',
                    '/p:MvcBuildViews=true',
                    '/p:EmitCompilerGeneratedFiles=true',
                })

            }
        end
    end

    local windowsMatchers = {
        DotnetMatcherBuild,
        MsBuildMatcher,
        CreatePatternMatcher({ '^csc.*%.exe$' }, MatchCompilerName, extractor, {
            prepend = { '--compiler', '"${compiler}"' },
            order = ORDER_BEFORE
        }),
        CreatePatternMatcher({ '^fakes.*%.exe$', 'moles.*%.exe' },
            MatchCompilerName, nil, { trace = false }),
        function(compilerName, compilerPath, compilerArguments, _languageId)
            -- handle cases like `dotnet.exe exec csc.dll <args>`
            if compilerName ~= 'dotnet.exe' then
                return nil
            end

            local seenCompilerCall = false
            local argv = NativeArgumentsToArgv(compilerArguments.nativeArgumentPointer)
            local extractorArgs = { '--compiler' }
            for _, arg in ipairs(argv) do
                if arg:match('csc%.dll$') then
                    seenCompilerCall = true
                end
                if seenCompilerCall then
                    table.insert(extractorArgs, arg)
                end
            end

            if seenCompilerCall then
                return {
                    order = ORDER_AFTER,
                    invocation = {
                        path = AbsolutifyExtractorPath(id, extractor),
                        arguments = {
                            commandLineString = ArgvToCommandLineString(extractorArgs)
                        }
                    }
                }
            end
            return nil
        end
    }
    local posixMatchers = {
        DotnetMatcherBuild,
        CreatePatternMatcher({ '^mcs%.exe$', '^csc%.exe$' }, MatchCompilerName,
            extractor, {
            prepend = { '--compiler', '"${compiler}"' },
            order = ORDER_BEFORE
        }),
        MsBuildMatcher,
        function(compilerName, compilerPath, compilerArguments, _languageId)
            -- handle cases like `dotnet exec csc.dll <args>` and `mono(-sgen64) csc.exe <args>`
            if compilerName ~= 'dotnet' and not compilerName:match('^mono') then
                return nil
            end

            local seenCompilerCall = false
            local argv = compilerArguments.argv
            local extractorArgs = { '--compiler' }
            for _, arg in ipairs(argv) do
                if arg:match('csc%.dll$') or arg:match('csc%.exe$') or arg:match('mcs%.exe$') then
                    seenCompilerCall = true
                end
                if seenCompilerCall then
                    table.insert(extractorArgs, arg)
                end
            end

            if seenCompilerCall then
                return {
                    order = ORDER_AFTER,
                    invocation = {
                        path = AbsolutifyExtractorPath(id, extractor),
                        arguments = {
                            argv = extractorArgs
                        }
                    }
                }
            end
            return nil
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
function GetCompatibleVersions() return { '1.0.0' } end
