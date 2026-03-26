# cmake 最低版本要求
cmake_minimum_required(VERSION 4.0.0)
# 工程名字
project(ccpj VERSION 0.1.0 DESCRIPTION "Primary C++ Program" LANGUAGES CXX)
# 设置可执行文件名
set(EXECUTABLE_NAME program)
# 设置编译器
# set(CMAKE_CXX_COMPILER "clang++")
# 设置链接器
# set(CMAKE_LINKER "ld.lld")
# 生成 compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# 生成可执行文件
add_executable(${EXECUTABLE_NAME})
# 头文件搜索路径
target_include_directories(
    ${EXECUTABLE_NAME}
    PRIVATE ${PROJECT_SOURCE_DIR}/includes
)
# 添加源文件
file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS ${PROJECT_SOURCE_DIR}/src/*.cpp)
target_sources(${EXECUTABLE_NAME} PRIVATE ${SOURCES})
#target_sources(${EXECUTABLE_NAME} PRIVATE ${SOURCES})
#target_sources(${EXECUTABLE_NAME} PRIVATE src/main.cpp src/add.cpp)

# 输出目录，CMAKE_BINARY_DIR 在 build 目录下，CMAKE_SOURCE_DIR 在根目录下
#set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin)
set_target_properties(
    ${EXECUTABLE_NAME}
    PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/bin/$<CONFIG>
)
set_target_properties(
    ${EXECUTABLE_NAME}
    PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_SOURCE_DIR}/bin/Debug
        RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_SOURCE_DIR}/bin/Release
)
# 设置构建类型（如果未指定时默认使用 Debug）
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type" FORCE)
endif()
# 设置 C++ 标准 (至少支持 c++20)
target_compile_features(${EXECUTABLE_NAME} PRIVATE cxx_std_20)
# 编译选项
target_compile_options(
    ${EXECUTABLE_NAME}
    PRIVATE
        $<$<CONFIG:DEBUG>:
        -g
        -Wall
        -Werror
        -Wextra
        -pedantic
        -Wconversion
        >
        $<$<CONFIG:Release>:
        -O3>
)
# 编译定义（通常仅在需要时设置）
target_compile_definitions(${EXECUTABLE_NAME} PRIVATE $<$<CONFIG:DEBUG>:DEBUG>)
