# cmake/Sanitizers.cmake

include_guard()

add_library(project_sanitizers INTERFACE)

# ========================================
# 1. Mode configuration
# ========================================

set(SANITIZER_MODE "Address" CACHE STRING "Sanitizer mode: None, Address, Thread, Memory, Undefined")
set_property(CACHE SANITIZER_MODE PROPERTY STRINGS "None" "Address" "Thread" "Memory" "Undefined")

# ========================================
# 2. Sanitizer Presets
# ========================================

# --- GNU/CLANG ---
# --- UBSAN ---
set(UBSAN_FLAGS
  -fsanitize=undefined
  -fno-sanitize-recover=undefined
  -fno-omit-frame-pointer)

# --- ASAN + UBSAN ---
set(ASAN_FLAGS
  -fsanitize=address
  ${UBSAN_FLAGS})

# --- TSAN + UBSAN ---
set(TSAN_FLAGS
  -fsanitize=thread
  ${UBSAN_FLAGS})

# --- MSAN + UBSAN ---
set(MSAN_FLAGS
  -fsanitize=memory
  -fsanitize-memory-track-origins
  ${UBSAN_FLAGS})

# --- MSVC ---
# --- ASAN ---
set(MSVC_ASAN_FLAGS
  /fsanitize=address)

# ========================================
# 3. Applying Logic
# ========================================

if(NOT SANITIZER_MODE STREQUAL "None")
  list(APPEND SAN_APPLIED_FLAGS
    # --- ASAN + UBSAN ---
    $<$<AND:$<STREQUAL:${SANITIZER_MODE},Address>,$<COMPILE_LANG_AND_ID:CXX,GNU,Clang>>:${ASAN_UBSAN_FLAGS}>
    $<$<AND:$<STREQUAL:${SANITIZER_MODE},Address>,$<COMPILER_ID:MSVC>>:${MSVC_ASAN_FLAGS}>

    # --- TSAN + UBSAN ---
    $<$<AND:$<STREQUAL:${SANITIZER_MODE},Thread>,$<COMPILE_LANG_AND_ID:CXX,GNU,Clang>>:${TSAN_UBSAN_FLAGS}>

    # --- MSAN + UBSAN ---
    $<$<AND:$<STREQUAL:${SANITIZER_MODE},Memory>,$<COMPILE_LANG_AND_ID:CXX,GNU,Clang>>:${MSAN_UBSAN_FLAGS}>

    # --- UBSAN ---
    $<$<AND:$<STREQUAL:${SANITIZER_MODE},Undefined>,$<COMPILE_LANG_AND_ID:CXX,GNU,Clang>>:${UBSAN_FLAGS}>
  )

  target_compile_options(project_sanitizers INTERFACE ${SAN_APPLIED_FLAGS})
  target_link_options(project_sanitizers INTERFACE ${SAN_APPLIED_FLAGS})
endif()
