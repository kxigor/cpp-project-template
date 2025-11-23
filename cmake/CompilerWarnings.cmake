add_library(project_options INTERFACE)

# ========================================
# 1. Compiler Presets (COMPILE OPTIONS)
# ========================================

# --- GCC/Clang Compiler ---
set(GCC_BASE_COMPILE
  -Wall -Wextra -Wpedantic
  -Werror
  -fstack-protector-strong
  -fPIE
)

set(GCC_AGGRESSIVE_COMPILE
  -Waggressive-loop-optimizations -Wmissing-declarations -Wcast-align -Wcast-qual 
  -Wchar-subscripts -Wconversion -Wempty-body -Wformat-nonliteral -Wformat-security 
  -Wformat-signedness -Wformat=2 -Winline -Wlogical-op -Wopenmp-simd -Wpacked 
  -Wpointer-arith -Winit-self -Wredundant-decls -Wsign-conversion -Wstrict-overflow=2 
  -Wsuggest-attribute=noreturn -Wsuggest-final-methods -Wsuggest-final-types 
  -Wswitch-default -Wswitch-enum -Wsync-nand -Wunused -Wundef -Wunreachable-code 
  -Wvariadic-macros -Wno-missing-field-initializers -Wno-narrowing -Wno-varargs 
  -fcheck-new -fstrict-overflow -fno-omit-frame-pointer 
  -Werror=vla -Wno-self-move
)

set(GCC_DEBUG_COMPILE   -g -D_DEBUG -ggdb3 -O0)
set(GCC_RELWITHDEB      -O2 -g -DNDEBUG)
set(GCC_RELEASE         -O3 -DNDEBUG)

# --- MSVC Compiler ---
set(MSVC_BASE_COMPILE   /W4 /WX /permissive- /Zc:__cplusplus)
set(MSVC_DEBUG_COMPILE  /Zi /Ob0 /Od /RTC1)
set(MSVC_RELWITHDEB     /Zi /O2 /DNDEBUG)
set(MSVC_RELEASE        /O2 /Oi /Gy /DNDEBUG /Zi)

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

list(APPEND PROJECT_COMPILE_FLAGS
  $<$<COMPILE_LANG_AND_ID:CXX,GNU,Clang>: ${GCC_BASE_COMPILE}>
  $<$<COMPILE_LANG_AND_ID:CXX,MSVC>:      ${MSVC_BASE_COMPILE}>

  # Debug
  $<$<AND:$<CONFIG:Debug>,$<COMPILE_LANG_AND_ID:CXX,GNU,Clang>>: ${GCC_DEBUG_COMPILE} ${GCC_AGGRESSIVE_COMPILE}>
  $<$<AND:$<CONFIG:Debug>,$<COMPILER_ID:MSVC>>:                  ${MSVC_DEBUG_COMPILE}>

  # RelWithDebInfo
  $<$<AND:$<CONFIG:RelWithDebInfo>,$<COMPILE_LANG_AND_ID:CXX,GNU,Clang>>: ${GCC_RELWITHDEB}>
  $<$<AND:$<CONFIG:RelWithDebInfo>,$<COMPILER_ID:MSVC>>:                  ${MSVC_RELWITHDEB}>

  # Release
  $<$<AND:$<CONFIG:Release>,$<COMPILE_LANG_AND_ID:CXX,GNU,Clang>>: ${GCC_RELEASE}>
  $<$<AND:$<CONFIG:Release>,$<COMPILER_ID:MSVC>>:                  ${MSVC_RELEASE}>
)

list(APPEND PROJECT_LINK_FLAGS
  $<$<COMPILE_LANG_AND_ID:CXX,GNU,Clang>: ${GCC_BASE_LINK}>
  $<$<COMPILE_LANG_AND_ID:CXX,MSVC>:      ${MSVC_BASE_LINK}>
  
  $<$<AND:$<CONFIG:Release>,$<COMPILER_ID:MSVC>>: /LTCG> 
)

# ========================================
# 4. Setting Targets
# ========================================

target_compile_options(project_options INTERFACE ${PROJECT_COMPILE_FLAGS})
target_link_options(project_options INTERFACE ${PROJECT_LINK_FLAGS})