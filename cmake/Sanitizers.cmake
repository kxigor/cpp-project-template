set(SANITIZER_MODE "Address" CACHE STRING "Sanitizer mode: None, Address, Thread, Memory, Undefined")
set_property(CACHE SANITIZER_MODE PROPERTY STRINGS "None" "Address" "Thread" "Memory" "Undefined")

add_library(project_sanitizers INTERFACE)

set(UBSAN_FLAGS 
  -fsanitize=undefined 
  -fno-sanitize-recover=undefined
  -fno-omit-frame-pointer)

set(ASAN_FLAGS 
    -fsanitize=address
    -fno-omit-frame-pointer)

set(TSAN_FLAGS 
  -fsanitize=thread
  -fno-omit-frame-pointer)

set(MSAN_FLAGS
  -fsanitize=memory
  -fsanitize-memory-track-origins
  -fno-omit-frame-pointer)

if(NOT SANITIZER_MODE STREQUAL "None")
  message(STATUS "Enabling Sanitizers: ${SANITIZER_MODE}")

  if(CMAKE_CXX_COMPILER_ID MATCHES "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    if(SANITIZER_MODE STREQUAL "Address")
      set(SAN_FLAGS ${ASAN_FLAGS} ${UBSAN_FLAGS})
    elseif(SANITIZER_MODE STREQUAL "Thread")
      set(SAN_FLAGS ${TSAN_FLAGS} ${UBSAN_FLAGS})
    elseif(SANITIZER_MODE STREQUAL "Memory")
      set(SAN_FLAGS ${MSAN_FLAGS} ${UBSAN_FLAGS})
    elseif(SANITIZER_MODE STREQUAL "Undefined")
      set(SAN_FLAGS ${UBSAN_FLAGS})
    endif()

    target_compile_options(project_sanitizers INTERFACE ${SAN_FLAGS})
    target_link_options(project_sanitizers INTERFACE ${SAN_FLAGS})
      
  elseif(CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
    if(SANITIZER_MODE STREQUAL "Address")
      target_compile_options(project_sanitizers INTERFACE /fsanitize=address)
    else()
      message(WARNING "Only Address sanitizer is supported on MSVC")
    endif()
  endif()
endif()