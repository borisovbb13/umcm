cmake_minimum_required(VERSION 3.5)

project(umcm_server VERSION 0.0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(SOURCES main.cpp logger.cpp socket_server.cpp)
set(HEADERS utilities.hpp logger.hpp socket_server.hpp)

add_executable(umcm_server ${SOURCES} ${HEADERS})
