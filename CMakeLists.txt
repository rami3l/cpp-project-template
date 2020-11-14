# Brief: CMakeLists.txt script for building Boost.ASIO projects.

cmake_minimum_required(VERSION 3.5)

# ========== Project =======================================#
# Set project name.
project(hello LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_VERBOSE_MAKEFILE ON)

# Set this option to OFF in order to not use Conan and use a locally installed
# Boost.
set(BUILD_WITH_CONAN ON)

# ========== Functions =======================================#

# Copy target file to path ${CURRENT DIRECTORY}/bin whenever it is rebuilt. It
# is easier to find and run executable targets from the command line.
function(copy_after_build TARGET_NAME)
  # Note: CMAKE_CURRENT_LIST_DIR is the directory where is this CMakeLists.txt
  # file.
  set(DESTDIR ${CMAKE_CURRENT_LIST_DIR}/bin/)
  file(MAKE_DIRECTORY ${DESTDIR})
  # Copy binary file to <CMakeLists.txt didctory>./bin after target is compiled.
  add_custom_command(
    TARGET ${TARGET_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${TARGET_NAME}> ${DESTDIR})
endfunction()

# ========= Conan Bootstrap ======================#

if(BUILD_WITH_CONAN)
  message([INFO] " =>> Building with CONAN OK.")

  # Download automatically, you can also just copy the conan.cmake file
  if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
    message(
      STATUS
        "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
    file(DOWNLOAD
         "https://github.com/conan-io/cmake-conan/raw/v0.15/conan.cmake"
         "${CMAKE_BINARY_DIR}/conan.cmake" TLS_VERIFY ON)
  endif()

  include(${CMAKE_BINARY_DIR}/conan.cmake)

  # Add all dependencies here
  conan_cmake_run(REQUIRES CLI11/1.8.0@cliutils/stable BASIC_SETUP BUILD
                  missing)
endif()

# ========== Target Configurations ================#

add_executable(${PROJECT_NAME} ./src/main.cpp)
# copy_after_build(${PROJECT_NAME})

add_custom_target(
  run
  COMMAND ./build/bin/${PROJECT_NAME} ${ARGS}
  DEPENDS ${PROJECT_NAME}
  WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
