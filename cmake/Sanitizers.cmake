add_library(project_sanitizers INTERFACE)

# ========================================
# 1. Mode configuration
# ========================================

set(SANITIZER_MODE "Address" CACHE STRING "Sanitizer mode: None, Address, Thread, Memory, Undefined")
set_property(CACHE SANITIZER_MODE PROPERTY STRINGS "None" "Address" "Thread" "Memory" "Undefined")

# ========================================
# 2. Sanitizer Presets
# ========================================

# --- UBSAN Sanitizer ---
set(UBSAN_FLAGS 
  -fsanitize=undefined 
  -fno-sanitize-recover=undefined
  -fno-omit-frame-pointer)

# --- ASAN Sanitizer ---
set(ASAN_FLAGS 
    -fsanitize=address
    -fno-omit-frame-pointer)

# --- TSAN Sanitizer ---
set(TSAN_FLAGS 
  -fsanitize=thread
  -fno-omit-frame-pointer)

# --- MSAN Sanitizer ---
set(MSAN_FLAGS
  -fsanitize=memory
  -fsanitize-memory-track-origins
  -fno-omit-frame-pointer)

# ========================================
# 3. Applying Logic
# ========================================

if(NOT SANITIZER_MODE STREQUAL "None")
  message(STATUS "Enabling Sanitizers: ${SANITIZER_MODE}")

  # --- GCC/Clang Sanitizers ---
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
      
  # --- MSVC Sanitizers ---
  elseif(CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
    if(SANITIZER_MODE STREQUAL "Address")
      target_compile_options(project_sanitizers INTERFACE /fsanitize=address)
    else()
      message(WARNING "Only Address sanitizer is supported on MSVC")
    endif()
  endif()
endif()