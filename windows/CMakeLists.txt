cmake_minimum_required(VERSION 3.14)
project(video_downloader LANGUAGES CXX)

set(BINARY_NAME "video_downloader")

cmake_policy(SET CMP0063 NEW)

set(CMAKE_INSTALL_RPATH "$ORIGIN/lib")

# Configure build
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Compilation settings
add_definitions(-DUNICODE -D_UNICODE)

# Flutter tool
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")

# Application executable
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

apply_standard_settings(${BINARY_NAME})

# Flutter
add_dependencies(${BINARY_NAME} flutter flutter_assemble)
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_SOURCE_DIR}")

# Install
install(TARGETS ${BINARY_NAME} RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}")
