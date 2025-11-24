# cmake/GtestTools.cmake

include_guard()

# ==============================================================================
# Add Google Test
# usage: add_gtest(TEST_NAME source1.cpp source2.cpp ... LIBRARIES lib1 lib2 ...)
# ==============================================================================
function(add_gtest TEST_NAME)
  cmake_parse_arguments(
    TEST_ARGS
    ""
    ""
    "LIBRARIES"
    ${ARGN}
  )

  add_executable(${TEST_NAME} ${TEST_ARGS_UNPARSED_ARGUMENTS})

  target_link_libraries(${TEST_NAME}
    PRIVATE
    GTest::gtest_main
  )

  if(TEST_ARGS_LIBRARIES)
    target_link_libraries(${TEST_NAME}
      PRIVATE
      ${TEST_ARGS_LIBRARIES}
    )
  endif()

  add_test(NAME ${TEST_NAME} COMMAND ${TEST_NAME})

endfunction()
