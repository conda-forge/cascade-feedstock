mkdir build
cd build

cmake ^
    -G "Ninja" ^
    -DCMAKE_C_COMPILER=clang-cl ^
    -DCMAKE_CXX_COMPILER=clang-cl ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DPython3_EXECUTABLE=%PREFIX%\python.exe ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DCASCADE_BUILD_TESTS=yes ^
    -DBoost_NO_BOOST_CMAKE=ON ^
    -DCASCADE_BUILD_PYTHON_BINDINGS=yes ^
    ..

cmake --build . --target install

ctest --output-on-failure -j${CPU_COUNT} -V
