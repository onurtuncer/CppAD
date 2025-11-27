# SPDX-License-Identifier: EPL-2.0 OR GPL-2.0-or-later
# SPDX-FileCopyrightText: Bradley M. Bell <bradbell@seanet.com>
# SPDX-FileContributor: 2003-24 Bradley M. Bell, 2025 Onur Tuncer
# ----------------------------------------------------------------------------
# eigen_info()
#
# cppad_has_eigen: (out)
# is 1 (0) if eigen is found (not found)
# If this is 1, the include directory for eigen will automatically be
# added using INCLUDE_DIRECTORIES with the SYSTEM flag.
#
# eigen_LINK_LIBRARIES: (out)
# if cppad_has_eigen is 1,
# is a list of absolute paths to libraries necessary to use eigen
# (should be empty becasuse eigen is a header only library).
#
# This macro may use variables with the name eigen_*

if(WIN32)
    message(STATUS "eigen_info.cmake: using direct include path for Eigen (MSVC override)")

    if(NOT EIGEN3_INCLUDE_DIR)
        set(EIGEN3_INCLUDE_DIR
            "${CMAKE_SOURCE_DIR}/vendor/eigen"
            CACHE PATH "Eigen3 include directory" FORCE
        )
    endif()

    if(NOT EXISTS "${EIGEN3_INCLUDE_DIR}/Eigen/Dense")
        message(FATAL_ERROR "Eigen not found at ${EIGEN3_INCLUDE_DIR}")
    endif()

    include_directories("${EIGEN3_INCLUDE_DIR}")

    # ?? FIX: define macro so MSVC doesn't error on #if CPPAD_HAS_EIGEN
    add_compile_definitions(CPPAD_HAS_EIGEN=1)

    return()
endif()



MACRO(eigen_info)
   #
   # check for pkg-config
   IF( NOT PKG_CONFIG_FOUND )
      FIND_PACKAGE(PkgConfig REQUIRED)
   ENDIF( )
   #
   #
   IF( NOT ${use_cplusplus_2014_ok} )
      MESSAGE(STATUS "Eigen not supportedL: because c++14 not supported")
      SET(cppad_has_eigen 0)
   ELSE( )
      #
      # eigen_*
      pkg_check_modules(eigen QUIET eigen3 )
      #
      IF( eigen_FOUND )
         MESSAGE(STATUS "Eigen found")
         SET(cppad_has_eigen 1)
         INCLUDE_DIRECTORIES( SYSTEM ${eigen_INCLUDE_DIRS} )
      ELSE( )
         MESSAGE(STATUS "Eigen not Found: eigen3.pc not in PKG_CONFIG_PATH")
         SET(cppad_has_eigen 0)
      ENDIF( )
   ENDIF( )
   #
   print_variable( cppad_has_eigen )
ENDMACRO(eigen_info)
