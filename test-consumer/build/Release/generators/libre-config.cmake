########## MACROS ###########################################################################
#############################################################################################

# Requires CMake > 3.15
if(${CMAKE_VERSION} VERSION_LESS "3.15")
    message(FATAL_ERROR "The 'CMakeDeps' generator only works with CMake >= 3.15")
endif()

if(libre_FIND_QUIETLY)
    set(libre_MESSAGE_MODE VERBOSE)
else()
    set(libre_MESSAGE_MODE STATUS)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/cmakedeps_macros.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/libreTargets.cmake)
include(CMakeFindDependencyMacro)

check_build_type_defined()

foreach(_DEPENDENCY ${libre_FIND_DEPENDENCY_NAMES} )
    # Check that we have not already called a find_package with the transitive dependency
    if(NOT ${_DEPENDENCY}_FOUND)
        find_dependency(${_DEPENDENCY} REQUIRED ${${_DEPENDENCY}_FIND_MODE})
    endif()
endforeach()

set(libre_VERSION_STRING "4.0.0")
set(libre_INCLUDE_DIRS ${libre_INCLUDE_DIRS_RELEASE} )
set(libre_INCLUDE_DIR ${libre_INCLUDE_DIRS_RELEASE} )
set(libre_LIBRARIES ${libre_LIBRARIES_RELEASE} )
set(libre_DEFINITIONS ${libre_DEFINITIONS_RELEASE} )


# Only the last installed configuration BUILD_MODULES are included to avoid the collision
foreach(_BUILD_MODULE ${libre_BUILD_MODULES_PATHS_RELEASE} )
    message(${libre_MESSAGE_MODE} "Conan: Including build module from '${_BUILD_MODULE}'")
    include(${_BUILD_MODULE})
endforeach()


