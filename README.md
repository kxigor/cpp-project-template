# cpp-project-template
A modern C++ project template with CMake


# Building/Testing
```shell
cmake --build --preset dev-debug-asan
cmake --build --preset dev-debug-tsan

cmake --build --preset ci-relwithdebinfo
cmake --build --preset ci-release

ctest --preset dev-debug-asan
ctest --preset dev-debug-tsan
ctest --preset ci-release

cmake --build --preset dev-debug-asan --target clean
cmake --build --preset ci-release --target clean

cmake --preset dev-debug-asan --fresh

cmake --build --preset dev-debug-asan --target format
ctest --preset dev-debug-asan --include TidyCheck
```

# TODO
fix CXX_COMPILER_ID:MSVC
