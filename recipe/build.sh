#!/usr/bin/env bash

mkdir build
cd build

cmake ${CMAKE_ARGS} -G "Ninja" \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DPython3_EXECUTABLE=$PREFIX/bin/python \
    -DCMAKE_BUILD_TYPE=Release \
    -DCASCADE_BUILD_TESTS=yes \
    -DBoost_NO_BOOST_CMAKE=ON \
    -DCASCADE_BUILD_PYTHON_BINDINGS=yes \
    ..

cmake --build . -- -v

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
ctest -j${CPU_COUNT} --output-on-failure
fi

cmake --build . --target install
