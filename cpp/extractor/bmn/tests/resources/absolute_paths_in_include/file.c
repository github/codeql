// Two normal headers to have some include directories in the environment
#include <a_header_in_same_dir.h>
#include <a_header_in_subdir.h>
// A non existing header
#include <non_existing_header.h>
// A non existing header in a non existing folder
#include <non_existing_folder/non_existing_header.h>
// A non existing header specified using an absolute path
#include </non_existing_with_absolute_path.h>
// A header specified with absolute path that exists also on the project directory
#include </header_specified_through_absolute_path.h>
// An include to the root folder, but with no header file
#include </>

// Windows-style paths
// Valid include
#include <subdir_for_windows\header_windows_specified.h>
// A non existing file in an non existing folder
#include <non_existing_folder\non_existing_header.h>
// A non existing file specified with an absolute path
#include <\non_existing_with_absolute_path.h>
// A header specified with absolute path that exists also on the project directory
#include <\header_specified_through_absolute_path.h>
// An include to the root folder, but with no header file
#include <\>

// A non existing file specified with a drive and absolute path
#include <C:\non_existing_with_absolute_path.h>
// A header specified with a drive and absolute path that exists also on the project directory
#include <C:\header_specified_through_absolute_path.h>
// An include to the root folder of the C drive, but with no header file
#include <C:\>

// An empty include
#include <>
