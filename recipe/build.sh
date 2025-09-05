#!/usr/bin/env bash

# Build & run the tests?
if [[ "$target_platform" == linux-ppc64le ]]; then
    export ENABLE_TESTS=no
else
    export ENABLE_TESTS=yes
fi

if [[ "$target_platform" == osx-* ]]; then
    # Workaround for compile issue on older OSX SDKs.
    export CXXFLAGS="$CXXFLAGS -fno-aligned-allocation -D_LIBCPP_DISABLE_AVAILABILITY"
fi

mkdir build
cd build

cmake ${CMAKE_ARGS} -G "Ninja" \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DPython3_EXECUTABLE=$PREFIX/bin/python \
    -DCMAKE_BUILD_TYPE=Release \
    -DCASCADE_BUILD_TESTS=yes \
    -DCASCADE_BUILD_PYTHON_BINDINGS=yes \
    ..

cmake --build . -- -v

if [[ "$ENABLE_TESTS" == yes ]]; then
    if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
        ctest -j${CPU_COUNT} --output-on-failure
    fi
fi

cmake --build . --target install
