cmake_minimum_required(VERSION 3.18)
project(test-libre)

find_package(libre REQUIRED)

add_executable(test-libre test.c)
target_link_libraries(test-libre libre::libre)
