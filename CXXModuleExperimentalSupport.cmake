# Ack use of experimental features in CMake 3.27
set(CMAKE_EXPERIMENTAL_CXX_MODULE_CMAKE_API "ac01f462-0f5f-432a-86aa-acef252918a6")

# This setup is MSVC-only for now, for `std` and `std.compat` standard C++ modules.
# These Standard Library Modules are available only in C++23 and up.  Make sure you've
# the most recent preview of the Visual Studio C++IDE or MSVC toolset.
if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
    # Set up location for standard library modules
    find_path(STD_INCLUDE_DIR "vector")
    if (NOT DEFINED STD_INCLUDE_DIR)
        message(FATAL_ERROR "Could not find header file <vector>")
    endif()
    cmake_path(GET STD_INCLUDE_DIR PARENT_PATH STD_INCLUDE_PARENT_DIR)
    set(STD_MODULE_DIR "${STD_INCLUDE_PARENT_DIR}/modules")
    message("Standard Library Modules directory set to: ${STD_MODULE_DIR}")

    # Define the C++ Standard Library Modules target based on installed C++ modules
    # interface source files.  Explicitly link your CMake target to this when using
    # these modules in your project.  Ideally, this target should be conceptually set up
    # automatically by the build system when it detects that you're using C++23 and up.
    add_library(cxx-std-modules STATIC)
    target_sources(cxx-std-modules
        PUBLIC                                          # Why can't this just be INTERFACE?
            FILE_SET CXX_MODULES
            BASE_DIRS ${STD_MODULE_DIR}
            FILES
                ${STD_MODULE_DIR}/std.ixx
                ${STD_MODULE_DIR}/std.compat.ixx
    )
endif()

