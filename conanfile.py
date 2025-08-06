from conan import ConanFile
from conan.tools.cmake import CMakeToolchain, CMake, cmake_layout, CMakeDeps
from conan.tools.files import copy, save
from conan.tools.scm import Version
import os


class LibreConan(ConanFile):
    name = "libre"
    version = "4.0.0"
    
    # Package metadata
    description = "Generic library for real-time communications with async IO support"
    homepage = "https://github.com/baresip/re"
    url = "https://github.com/baresip/re"
    license = "BSD-3-Clause"
    topics = ("sip", "rtp", "networking", "communications", "real-time")
    
    # Package configuration
    package_type = "library"
    settings = "os", "compiler", "build_type", "arch"
    
    options = {
        "shared": [True, False],
        "fPIC": [True, False],
        # SSL/TLS options
        "with_openssl": [True, False],
        "with_mbedtls": [True, False],
        # Protocol support
        "with_sip": [True, False],
        "with_bfcp": [True, False],
        "with_pcp": [True, False], 
        "with_rtmp": [True, False],
        # Compression
        "with_zlib": [True, False],
        # Platform features
        "with_unixsock": [True, False],
        "with_trace": [True, False],
        "tls13_post_handshake_auth": [True, False],
    }
    
    default_options = {
        "shared": False,
        "fPIC": True,
        # Enable SSL by default
        "with_openssl": True,
        "with_mbedtls": False,
        # Enable all protocols by default
        "with_sip": True,
        "with_bfcp": True,
        "with_pcp": True,
        "with_rtmp": True,
        # Enable compression
        "with_zlib": True,
        # Platform features
        "with_unixsock": True,
        "with_trace": False,
        "tls13_post_handshake_auth": True,
    }
    
    def export_sources(self):
        copy(self, "CMakeLists.txt", src=self.recipe_folder, dst=self.export_sources_folder)
        copy(self, "src/*", src=self.recipe_folder, dst=self.export_sources_folder)
        copy(self, "include/*", src=self.recipe_folder, dst=self.export_sources_folder)
        copy(self, "rem/*", src=self.recipe_folder, dst=self.export_sources_folder)
        copy(self, "cmake/*", src=self.recipe_folder, dst=self.export_sources_folder)
        copy(self, "packaging/*", src=self.recipe_folder, dst=self.export_sources_folder)
        copy(self, "test/*", src=self.recipe_folder, dst=self.export_sources_folder)
        copy(self, "LICENSE", src=self.recipe_folder, dst=self.export_sources_folder)
        copy(self, "README.md", src=self.recipe_folder, dst=self.export_sources_folder)

    def config_options(self):
        if self.settings.os == "Windows":
            self.options.rm_safe("fPIC")
            # Unix sockets not available on Windows
            self.options.with_unixsock = False
        
        # Can't enable both SSL libraries
        if self.options.with_mbedtls:
            self.options.with_openssl = False

    def configure(self):
        if self.options.shared:
            self.options.rm_safe("fPIC")
        
        # This is a C library
        self.settings.rm_safe("compiler.libcxx")
        self.settings.rm_safe("compiler.cppstd")

    def layout(self):
        cmake_layout(self)

    def requirements(self):
        # SSL/TLS libraries
        if self.options.with_openssl:
            self.requires("openssl/[>=1.1.1]")
        elif self.options.with_mbedtls:
            self.requires("mbedtls/3.6.0")
        
        # Compression
        if self.options.with_zlib:
            self.requires("zlib/1.3.1")

    def system_requirements(self):
        # System libraries that are usually available
        pass

    def generate(self):
        deps = CMakeDeps(self)
        deps.generate()
        
        tc = CMakeToolchain(self)
        
        # Configure options
        tc.variables["USE_OPENSSL"] = self.options.with_openssl
        tc.variables["USE_MBEDTLS"] = self.options.with_mbedtls
        tc.variables["USE_SIP"] = self.options.with_sip
        tc.variables["USE_BFCP"] = self.options.with_bfcp
        tc.variables["USE_PCP"] = self.options.with_pcp
        tc.variables["USE_RTMP"] = self.options.with_rtmp
        tc.variables["USE_UNIXSOCK"] = self.options.with_unixsock
        tc.variables["USE_TRACE"] = self.options.with_trace
        tc.variables["USE_TLS1_3_PHA"] = self.options.tls13_post_handshake_auth
        
        # Build configuration
        tc.variables["BUILD_SHARED_LIBS"] = self.options.shared
        
        # Disable tests and packaging for Conan builds
        tc.variables["BUILD_TESTING"] = False
        tc.variables["SKIP_INSTALL_ALL"] = False
        
        tc.generate()

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()

    def package(self):
        copy(self, "LICENSE", dst=os.path.join(self.package_folder, "licenses"), src=self.source_folder)
        cmake = CMake(self)
        cmake.install()

    def package_info(self):
        # Main library
        self.cpp_info.libs = ["re"]
        
        # Include directories
        self.cpp_info.includedirs = ["include/re"]
        
        # System libraries
        if self.settings.os in ["Linux", "FreeBSD"]:
            self.cpp_info.system_libs.extend(["pthread", "m", "dl"])
            # Add resolv library for DNS resolution on some systems
            if self.settings.os == "Linux":
                self.cpp_info.system_libs.append("resolv")
        elif self.settings.os == "Macos":
            self.cpp_info.system_libs.extend(["pthread", "m", "dl"])
            self.cpp_info.frameworks.extend(["SystemConfiguration", "CoreFoundation"])
        elif self.settings.os == "Windows":
            self.cpp_info.system_libs.extend([
                "qwave", "iphlpapi", "wsock32", "ws2_32", "dbghelp"
            ])
        
        # Compiler flags are handled automatically by CMake
        
        # Definitions based on enabled features
        self.cpp_info.defines.append('RE_VERSION="%s"' % self.version)
        
        if self.options.with_openssl:
            self.cpp_info.defines.extend([
                "USE_OPENSSL", "USE_TLS", "USE_DTLS", 
                "USE_OPENSSL_AES", "USE_OPENSSL_HMAC"
            ])
        
        if self.options.with_mbedtls:
            self.cpp_info.defines.append("USE_MBEDTLS")
        
        if self.options.with_zlib:
            self.cpp_info.defines.append("USE_ZLIB")
        
        if self.options.with_unixsock:
            self.cpp_info.defines.append("USE_UNIXSOCK")
        
        if self.options.with_trace:
            self.cpp_info.defines.append("USE_TRACE")
        
        # Set modern Conan 2.x properties
        self.cpp_info.set_property("cmake_target_name", "libre::libre")
        self.cpp_info.set_property("pkg_config_name", "libre")