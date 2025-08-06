# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(libre_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
conan_find_apple_frameworks(libre_FRAMEWORKS_FOUND_RELEASE "${libre_FRAMEWORKS_RELEASE}" "${libre_FRAMEWORK_DIRS_RELEASE}")

set(libre_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET libre_DEPS_TARGET)
    add_library(libre_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET libre_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Release>:${libre_FRAMEWORKS_FOUND_RELEASE}>
             $<$<CONFIG:Release>:${libre_SYSTEM_LIBS_RELEASE}>
             $<$<CONFIG:Release>:openssl::openssl;ZLIB::ZLIB>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### libre_DEPS_TARGET to all of them
conan_package_library_targets("${libre_LIBS_RELEASE}"    # libraries
                              "${libre_LIB_DIRS_RELEASE}" # package_libdir
                              "${libre_BIN_DIRS_RELEASE}" # package_bindir
                              "${libre_LIBRARY_TYPE_RELEASE}"
                              "${libre_IS_HOST_WINDOWS_RELEASE}"
                              libre_DEPS_TARGET
                              libre_LIBRARIES_TARGETS  # out_libraries_targets
                              "_RELEASE"
                              "libre"    # package_name
                              "${libre_NO_SONAME_MODE_RELEASE}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${libre_BUILD_DIRS_RELEASE} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Release ########################################
    set_property(TARGET libre::libre
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${libre_OBJECTS_RELEASE}>
                 $<$<CONFIG:Release>:${libre_LIBRARIES_TARGETS}>
                 )

    if("${libre_LIBS_RELEASE}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET libre::libre
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     libre_DEPS_TARGET)
    endif()

    set_property(TARGET libre::libre
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Release>:${libre_LINKER_FLAGS_RELEASE}>)
    set_property(TARGET libre::libre
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${libre_INCLUDE_DIRS_RELEASE}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET libre::libre
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Release>:${libre_LIB_DIRS_RELEASE}>)
    set_property(TARGET libre::libre
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${libre_COMPILE_DEFINITIONS_RELEASE}>)
    set_property(TARGET libre::libre
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:${libre_COMPILE_OPTIONS_RELEASE}>)

########## For the modules (FindXXX)
set(libre_LIBRARIES_RELEASE libre::libre)
