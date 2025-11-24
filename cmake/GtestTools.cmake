# cmake/GtestTools.cmake

include_guard()

# ==============================================================================
# FUNCTION: add_gtest(TEST_NAME ...)
# 
# Description: Creates an executable for a Google Test suite, links it with
# GTest framework and specified dependencies, and registers it with CTest.
#
# Usage:
# add_gtest(MyTestSuiteName
#   SOURCES test_file_1.cpp [test_file_2.cpp ...]
#   LIBRARIES MyCoreLib::MyCoreLib [Another::Lib ...]
#   COMPILE_OPTIONS -Wno-conversion
#   PROPERTIES TIMEOUT 60
# )
# 
# Requires: GTest::gtest_main to be available (i.e., GTest_FOUND must be TRUE).
# ==============================================================================
function(add_gtest TEST_NAME)
  cmake_parse_arguments(
    TEST_ARGS
    # OPTIONS
    "EXCLUSIVE"
    # ONE_VALUE
    "WORKING_DIRECTORY"
    # MULTI_VALUE
    "SOURCES;LIBRARIES;INCLUDE_DIRECTORIES;COMPILE_OPTIONS;COMPILE_DEFINITIONS;LINK_OPTIONS;PROPERTIES"
    ${ARGN}
  )

  # --- Checking the availability of sources ---
  if(NOT TEST_ARGS_SOURCES)
    message(FATAL_ERROR "add_gtest requires SOURCES to be specified for test ${TEST_NAME}")
  endif()
  
  # --- 1. Creating an executable file ---
  add_executable(${TEST_NAME} ${TEST_ARGS_SOURCES})

  # --- 2. Using compilation/linking options ---
  if(TEST_ARGS_COMPILE_OPTIONS)
      target_compile_options(${TEST_NAME} PRIVATE ${TEST_ARGS_COMPILE_OPTIONS})
  endif()

  if(TEST_ARGS_COMPILE_DEFINITIONS)
      target_compile_definitions(${TEST_NAME} PRIVATE ${TEST_ARGS_COMPILE_DEFINITIONS})
  endif()
  
  if(TEST_ARGS_INCLUDE_DIRECTORIES)
      target_include_directories(${TEST_NAME} PRIVATE ${TEST_ARGS_INCLUDE_DIRECTORIES})
  endif()
  
  if(TEST_ARGS_LINK_OPTIONS)
      target_link_options(${TEST_NAME} PRIVATE ${TEST_ARGS_LINK_OPTIONS})
  endif()
  
  # --- 3. Linking (GTest + custom libraries) ---
  target_link_libraries(${TEST_NAME}
    PRIVATE
    GTest::gtest_main
    ${TEST_ARGS_LIBRARIES}
  )

  # --- 4. Registration of the CTest test ---
  add_test(NAME ${TEST_NAME} COMMAND ${TEST_NAME})
  
  # --- 5. Applying additional CTest options ---
  if(TEST_ARGS_WORKING_DIRECTORY)
      set_tests_properties(${TEST_NAME} PROPERTIES WORKING_DIRECTORY ${TEST_ARGS_WORKING_DIRECTORY})
  endif()

  if(TEST_ARGS_PROPERTIES)
      # PROPERTIES is passed as a K/V list (e.g., TIMEOUT 60)
      set_tests_properties(${TEST_NAME} PROPERTIES ${TEST_ARGS_PROPERTIES})
  endif()

endfunction()
