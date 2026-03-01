cmake_minimum_required(VERSION 3.14)
project(flutter)

set(EPHEMERAL_DIR "${CMAKE_CURRENT_SOURCE_DIR}/ephemeral")

# Configuration provided via temporary CMakeLists.txt file within the flutter
# temporary build directory.
include(${EPHEMERAL_DIR}/generated_config.cmake)

# Serves the same purpose as list(APPEND ...) but operates on paths.
function(list_prepend LIST_NAME)
    set(LOCAL_LIST "${${LIST_NAME}}")
    foreach(argument ${ARGN})
        set(LOCAL_LIST "${argument};${LOCAL_LIST}")
    endforeach(argument)
    set(${LIST_NAME} "${LOCAL_LIST}" PARENT_SCOPE)
endfunction()

# === Flutter Library ===
# System-level dependencies.
find_package(OpenGL REQUIRED)

add_library(flutter INTERFACE)
set(FLUTTER_LIBRARY "${EPHEMERAL_DIR}/flutter_windows.dll")

# Published to parent scope for install step.
set(FLUTTER_LIBRARY ${FLUTTER_LIBRARY} PARENT_SCOPE)
set(FLUTTER_ICU_DATA_FILE "${EPHEMERAL_DIR}/icudtl.dat" PARENT_SCOPE)
set(PROJECT_BUILD_DIR "${PROJECT_DIR}/build/" PARENT_SCOPE)
set(AOT_LIBRARY "${PROJECT_DIR}/build/windows/app.so" PARENT_SCOPE)

list(APPEND FLUTTER_LIBRARY_HEADERS
  "flutter/dart_project.h"
  "flutter/flutter_engine.h"
  "flutter/flutter_plugin_registrar.h"
  "flutter/flutter_view.h"
  "flutter/flutter_view_controller.h"
  "flutter/flutter_windows.h"
  "flutter/method_call.h"
  "flutter/method_channel.h"
  "flutter/method_codec.h"
  "flutter/method_result.h"
  "flutter/plugin_registrar.h"
  "flutter/plugin_registrar_windows.h"
  "flutter/standard_method_codec.h"
)
list_prepend(FLUTTER_LIBRARY_HEADERS "${EPHEMERAL_DIR}/")
target_sources(flutter INTERFACE
  ${FLUTTER_LIBRARY_HEADERS}
)
target_include_directories(flutter INTERFACE
  "${EPHEMERAL_DIR}"
)
target_link_libraries(flutter INTERFACE "${FLUTTER_LIBRARY}.lib")
add_custom_target(flutter_assemble DEPENDS
  "${FLUTTER_LIBRARY}"
  "${FLUTTER_ICU_DATA_FILE}"
)

# === Flutter Wrapper ===
list(APPEND CPP_WRAPPER_SOURCES_CORE
  "flutter/cpp_client_wrapper/core_implementations.cc"
  "flutter/cpp_client_wrapper/standard_codec.cc"
)
list(APPEND CPP_WRAPPER_SOURCES_AND_HEADERS
  ${CPP_WRAPPER_SOURCES_CORE}
  "flutter/cpp_client_wrapper/include/flutter/basic_message_channel.h"
  "flutter/cpp_client_wrapper/include/flutter/binary_messenger.h"
  "flutter/cpp_client_wrapper/include/flutter/encodable_value.h"
  "flutter/cpp_client_wrapper/include/flutter/engine_method_result.h"
  "flutter/cpp_client_wrapper/include/flutter/message_codec.h"
  "flutter/cpp_client_wrapper/include/flutter/method_call.h"
  "flutter/cpp_client_wrapper/include/flutter/method_channel.h"
  "flutter/cpp_client_wrapper/include/flutter/method_codec.h"
  "flutter/cpp_client_wrapper/include/flutter/method_result.h"
  "flutter/cpp_client_wrapper/include/flutter/method_result_functions.h"
  "flutter/cpp_client_wrapper/include/flutter/plugin_registrar.h"
  "flutter/cpp_client_wrapper/include/flutter/plugin_registry.h"
  "flutter/cpp_client_wrapper/include/flutter/standard_message_codec.h"
  "flutter/cpp_client_wrapper/include/flutter/standard_method_codec.h"
)
list_prepend(CPP_WRAPPER_SOURCES_AND_HEADERS "${EPHEMERAL_DIR}/")
add_library(flutter_wrapper_app STATIC
  ${CPP_WRAPPER_SOURCES_AND_HEADERS}
)
apply_standard_settings(flutter_wrapper_app)
target_link_libraries(flutter_wrapper_app PUBLIC flutter)
target_include_directories(flutter_wrapper_app PUBLIC
  "${EPHEMERAL_DIR}/flutter/cpp_client_wrapper/include"
)
