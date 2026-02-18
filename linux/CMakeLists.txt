cmake_minimum_required(VERSION 3.10)
project(runner LANGUAGES CXX)

set(BINARY_NAME "video_downloader")
set(APPLICATION_ID "com.videodownloader.app")

cmake_policy(SET CMP0063 NEW)

set(CMAKE_INSTALL_RPATH "$ORIGIN/lib")

# Configure build
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Compilation settings
if(NOT CONFIGURATION)
  set(CONFIGURATION "Debug")
endif()

# Flutter tool
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")

# Application build
add_executable(${BINARY_NAME}
  "main.cc"
  "my_application.cc"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
)

# Apply Flutter standard settings (inline version)
set_target_properties(${BINARY_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${BINARY_NAME} PRIVATE "$<$<NOT:$<CONFIG:Debug>>:NDEBUG>")

# Add Flutter dependency
add_dependencies(${BINARY_NAME} flutter flutter_assemble)

# Find required packages
find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK REQUIRED gtk+-3.0)

target_link_libraries(${BINARY_NAME} PRIVATE flutter)
target_link_libraries(${BINARY_NAME} PRIVATE PkgConfig::GTK)

# Install
install(TARGETS ${BINARY_NAME} RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}")

# Custom target for flutter_assemble
add_custom_target(flutter_assemble)
