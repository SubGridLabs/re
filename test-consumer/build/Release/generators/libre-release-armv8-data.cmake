########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(libre_COMPONENT_NAMES "")
if(DEFINED libre_FIND_DEPENDENCY_NAMES)
  list(APPEND libre_FIND_DEPENDENCY_NAMES OpenSSL ZLIB)
  list(REMOVE_DUPLICATES libre_FIND_DEPENDENCY_NAMES)
else()
  set(libre_FIND_DEPENDENCY_NAMES OpenSSL ZLIB)
endif()
set(OpenSSL_FIND_MODE "NO_MODULE")
set(ZLIB_FIND_MODE "NO_MODULE")

########### VARIABLES #######################################################################
#############################################################################################
set(libre_PACKAGE_FOLDER_RELEASE "/Users/palmarti/.conan2/p/b/libref1088ac6f3d1d/p")
set(libre_BUILD_MODULES_PATHS_RELEASE )


set(libre_INCLUDE_DIRS_RELEASE "${libre_PACKAGE_FOLDER_RELEASE}/include/re")
set(libre_RES_DIRS_RELEASE )
set(libre_DEFINITIONS_RELEASE "-DRE_VERSION=\"4.0.0\""
			"-DUSE_OPENSSL"
			"-DUSE_TLS"
			"-DUSE_DTLS"
			"-DUSE_OPENSSL_AES"
			"-DUSE_OPENSSL_HMAC"
			"-DUSE_ZLIB"
			"-DUSE_UNIXSOCK")
set(libre_SHARED_LINK_FLAGS_RELEASE )
set(libre_EXE_LINK_FLAGS_RELEASE )
set(libre_OBJECTS_RELEASE )
set(libre_COMPILE_DEFINITIONS_RELEASE "RE_VERSION=\"4.0.0\""
			"USE_OPENSSL"
			"USE_TLS"
			"USE_DTLS"
			"USE_OPENSSL_AES"
			"USE_OPENSSL_HMAC"
			"USE_ZLIB"
			"USE_UNIXSOCK")
set(libre_COMPILE_OPTIONS_C_RELEASE )
set(libre_COMPILE_OPTIONS_CXX_RELEASE )
set(libre_LIB_DIRS_RELEASE "${libre_PACKAGE_FOLDER_RELEASE}/lib")
set(libre_BIN_DIRS_RELEASE )
set(libre_LIBRARY_TYPE_RELEASE STATIC)
set(libre_IS_HOST_WINDOWS_RELEASE 0)
set(libre_LIBS_RELEASE re)
set(libre_SYSTEM_LIBS_RELEASE pthread m dl)
set(libre_FRAMEWORK_DIRS_RELEASE )
set(libre_FRAMEWORKS_RELEASE SystemConfiguration CoreFoundation)
set(libre_BUILD_DIRS_RELEASE )
set(libre_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(libre_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${libre_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${libre_COMPILE_OPTIONS_C_RELEASE}>")
set(libre_LINKER_FLAGS_RELEASE
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${libre_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${libre_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${libre_EXE_LINK_FLAGS_RELEASE}>")


set(libre_COMPONENTS_RELEASE )