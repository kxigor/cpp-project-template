# cmake/CompilerWarnings.cmake

include_guard()

add_library(project_options INTERFACE)

# ========================================
# 1. Compiler Presets (COMPILE OPTIONS)
# ========================================

# --- GCC/Clang Compiler ---
set(GCC_BASE_COMPILE
  -Wall -Wextra -Wpedantic
  -fPIE
  -fstack-protector-strong
)

set(GCC_AGGRESSIVE_COMPILE
  -Werror -Waggressive-loop-optimizations -Wmissing-declarations -Wcast-align 
  -Wcast-qual -Wchar-subscripts -Wconversion -Wempty-body -Wformat-nonliteral 
  -Wsuggest-final-methods -Wsuggest-final-types -Wswitch-default  -Werror=vla 
  -Wsign-conversion -Wstrict-overflow=2 -Wsuggest-attribute=noreturn -Wunused
  -Wno-varargs -fcheck-new -fstrict-overflow -fno-omit-frame-pointer -Winline
  -Wvariadic-macros  -Wno-missing-field-initializers  -Wno-narrowing -Wpacked
  -Wswitch-enum   -Wsync-nand    -Wundef  -Wunreachable-code   -Wno-self-move 
  -Wformat-security      -Wformat-signedness      -Wformat=2     -Wlogical-op 
  -Wopenmp-simd       -Wpointer-arith      -Winit-self      -Wredundant-decls 
  
)

set(GCC_DEBUG_COMPILE -g -D_DEBUG -ggdb3 -O0)
set(GCC_RELWITHDEB -O2 -g -DNDEBUG)
set(GCC_RELEASE -O3 -DNDEBUG)

# --- MSVC Compiler ---
set(MSVC_BASE_COMPILE /W4 /WX /permissive- /Zc:__cplusplus)
set(MSVC_DEBUG_COMPILE /Zi /Ob0 /Od /RTC1)
set(MSVC_RELWITHDEB /Zi /O2 /DNDEBUG)
set(MSVC_RELEASE /O2 /Oi /Gy /DNDEBUG /Zi /GL)

# ========================================
# 2. Linker Presets (LINK OPTIONS)
# ========================================

# --- GCC/Clang Linker ---
set(GCC_BASE_LINK
  -pie
  -Wl,-z,relro
  -Wl,-z,now
)

# --- MSVC Linker ---
set(MSVC_BASE_LINK
  /DYNAMICBASE
  /NXCOMPAT
)

# ========================================
# 3. Applying Logic
# ========================================

target_compile_options(project_options INTERFACE
  # --- Base Flags ---
  # --- GNU/CLANG ---
  $<$<COMPILE_LANG_AND_ID:CXX,GNU,Clang>: ${GCC_BASE_COMPILE}>
  # --- MSVC ---
  $<$<COMPILE_LANG_AND_ID:CXX,MSVC>: ${MSVC_BASE_COMPILE}>

  # --- Debug ---
  # --- GNU/CLANG ---
  $<$<AND:$<CONFIG:Debug>,$<COMPILE_LANG_AND_ID:CXX,GNU,Clang>>: ${GCC_DEBUG_COMPILE} ${GCC_AGGRESSIVE_COMPILE}>
  # --- MSVC ---
  $<$<AND:$<CONFIG:Debug>,$<COMPILER_ID:MSVC>>: ${MSVC_DEBUG_COMPILE}>

  # --- RelWithDebInfo ---
  # --- GNU/CLANG ---
  $<$<AND:$<CONFIG:RelWithDebInfo>,$<COMPILE_LANG_AND_ID:CXX,GNU,Clang>>: ${GCC_RELWITHDEB}>
  # --- MSVC ---
  $<$<AND:$<CONFIG:RelWithDebInfo>,$<COMPILER_ID:MSVC>>: ${MSVC_RELWITHDEB}>

  # --- Release ---
  # --- GNU/CLANG ---
  $<$<AND:$<CONFIG:Release>,$<COMPILE_LANG_AND_ID:CXX,GNU,Clang>>: ${GCC_RELEASE}>
  # --- MSVC ---
  $<$<AND:$<CONFIG:Release>,$<COMPILER_ID:MSVC>>: ${MSVC_RELEASE}>
)

target_link_options(project_options INTERFACE
  # --- Base Flags ---
  # --- GNU/CLANG ---
  $<$<COMPILE_LANG_AND_ID:CXX,GNU,Clang>: ${GCC_BASE_LINK}>
  # --- MSVC ---
  $<$<COMPILE_LANG_AND_ID:CXX,MSVC>: ${MSVC_BASE_LINK}>

  # --- Release ---
  # --- MSVC ---
  $<$<AND:$<CONFIG:Release>,$<COMPILER_ID:MSVC>>: /LTCG>
)