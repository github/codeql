option(BUILD_SHARED_LIBS "Build and use shared libraries" 0)
option(CREATE_COMPILATION_DATABASE_LINK "Create compilation database link. Implies CMAKE_EXPORT_COMPILE_COMMANDS" 1)

if (CREATE_COMPILATION_DATABASE_LINK)
    set(CMAKE_EXPORT_COMPILE_COMMANDS 1)
endif ()

macro(bazel)
    execute_process(COMMAND bazel ${ARGN}
            COMMAND_ERROR_IS_FATAL ANY
            OUTPUT_STRIP_TRAILING_WHITESPACE
            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
endmacro()

bazel(info workspace OUTPUT_VARIABLE BAZEL_WORKSPACE)

bazel(info output_base OUTPUT_VARIABLE BAZEL_OUTPUT_BASE)
string(REPLACE "-" "_" BAZEL_EXEC_ROOT ${PROJECT_NAME})
set(BAZEL_EXEC_ROOT ${BAZEL_OUTPUT_BASE}/execroot/${BAZEL_EXEC_ROOT})

macro(include_generated BAZEL_TARGET)
    bazel(build ${BAZEL_TARGET})
    string(REPLACE "@" "/external/" BAZEL_TARGET_PATH ${BAZEL_TARGET})
    string(REPLACE "//" "/" BAZEL_TARGET_PATH ${BAZEL_TARGET_PATH})
    string(REPLACE ":" "/" BAZEL_TARGET_PATH ${BAZEL_TARGET_PATH})
    include(${BAZEL_WORKSPACE}/bazel-bin${BAZEL_TARGET_PATH}.cmake)
endmacro()

if (CREATE_COMPILATION_DATABASE_LINK)
    file(CREATE_LINK ${PROJECT_BINARY_DIR}/compile_commands.json ${PROJECT_SOURCE_DIR}/compile_commands.json SYMBOLIC)
endif ()
