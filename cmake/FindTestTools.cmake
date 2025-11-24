# cmake/FindTestTools.cmake

include_guard()

message(STATUS "Searching for necessary external tools...")

find_package(GTest QUIET CONFIG)
find_package(Python3 QUIET)

find_program(CLANG_FORMAT_EXE
  NAMES
  clang-format-21
  clang-format-20
  clang-format-19
  DOC "Path to the preferred version of clang-format for formatting."
)

find_program(CLANG_TIDY_EXE
  NAMES
  clang-tidy-21
  clang-tidy-20
  clang-tidy-19
  DOC "Path to the preferred version of clang-tidy for static analysis."
)

# --- GTest ---
if(GTest_FOUND)
  message(STATUS "Found testing prerequisites (GTest). Unit tests are fully enabled.")
else()
  message(STATUS "Testing skipped (not required).")
endif()

# --- Clang-Format ---
if(CLANG_FORMAT_EXE)
  message(STATUS "Found clang-format: ${CLANG_FORMAT_EXE}")
else()
  message(STATUS "clang-format not found. Format targets will be skipped.")
endif()

# --- Clang-Tidy ---
if(CLANG_TIDY_EXE)
  if(Python3_FOUND)
    message(STATUS "Found clang-tidy: ${CLANG_TIDY_EXE} (and Python3). Tidy targets are enabled.")
  else()
    message(WARNING "Found clang-tidy, but Python3 (required by analysis script) was NOT found. Tidy targets disabled.")
    unset(CLANG_TIDY_EXE)
  endif()
else()
  message(STATUS "clang-tidy not found. Tidy targets will be skipped.")
endif()
