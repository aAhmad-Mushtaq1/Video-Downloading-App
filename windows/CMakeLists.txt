cmake_minimum_required(VERSION 3.14)
project(video_downloader LANGUAGES CXX)

set(BINARY_NAME "video_downloader")
set(APPLICATION_ID "com.videodownloader.app")

cmake_policy(SET CMP0063 NEW)

set(CMAKE_INSTALL_RPATH "$ORIGIN/lib")

# Configure build
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Compilation settings
add_definitions(-DUNICODE -D_UNICODE)

# Configure build type
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE "Debug" CACHE
      STRING "Flutter build mode" FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
    "Debug" "Profile" "Release")
endif()

# Flutter tool
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")

# Flutter wrapper
list(APPEND FLUTTER_LIBRARY_HEADERS
  "flutter/dart_project.h"
  "flutter/flutter_engine.h"
  "flutter/flutter_plugin_registrar.h"
  "flutter/flutter_view.h"
  "flutter/flutter_view_controller.h"
  "flutter/flutter_windows.h"
  "flutter/generated_plugin_registrant.h"
  "flutter/method_call.h"
  "flutter/method_channel.h"
  "flutter/method_codec.h"
  "flutter/method_result.h"
  "flutter/plugin_registrar.h"
  "flutter/plugin_registrar_windows.h"
  "flutter/standard_method_codec.h"
)
list(APPEND FLUTTER_LIBRARY_HEADERS
  "flutter/generated_plugin_registrant.h"
)
add_library(flutter INTERFACE)
target_include_directories(flutter INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}"
)
add_library(flutter_wrapper_app INTERFACE)
target_link_libraries(flutter_wrapper_app INTERFACE flutter)

# Application build
add_executable(${BINARY_NAME} WIN32
  "runner/main.cpp"
  "runner/flutter_window.cpp"
  "runner/run_loop.cpp"
  "runner/utils.cpp"
  "runner/win32_window.cpp"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
  "runner/Runner.rc"
  "runner/runner.exe.manifest"
)

# Apply Flutter standard settings (inline version)
set_target_properties(${BINARY_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${BINARY_NAME} PRIVATE "_UNICODE" "UNICODE")
target_compile_options(${BINARY_NAME} PRIVATE "/W4" "/WX" "/wd4100")

# Add Flutter dependency
add_dependencies(${BINARY_NAME} flutter_assemble)
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_SOURCE_DIR}")

# Install
install(TARGETS ${BINARY_NAME} RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}")

# Custom command for flutter_assemble
add_custom_target(flutter_assemble)
