# cmake 最低版本
cmake_minimum_required(VERSION 4.0.0)
# 设置工程名
project(arcp VERSION 1.0.0 DESCRIPTION "A simple project for cmake" LANGUAGES C)
# 生成 compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# 设置可执行文件名
set(EXECUTABLE_NAME arcp)
# 列出主要源文件
set(MAIN_SOURCE_FILES main.c)
# 添加 src 子目录
add_subdirectory(src/subdir1)
add_subdirectory(src/subdir2)
# 生成可执行文件
add_executable(${EXECUTABLE_NAME} ${MAIN_SOURCE_FILES})
# 输出目录（将目标的输出路径更精确地设置为构建类型）
set_target_properties(
    ${EXECUTABLE_NAME}
    PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/bin/$<CONFIG>
)
# 头文件搜索路径
target_include_directories(${EXECUTABLE_NAME} PRIVATE ${PROJECT_SOURCE_DIR}/inc)
# 添加链接库
target_link_libraries(${EXECUTABLE_NAME} PUBLIC LIB_SRC1 LIB_SRC2)

# 设置编译选项和标准 (仅支持 c17)
set_target_properties(
    ${EXECUTABLE_NAME}
    PROPERTIES
        C_STANDARD 17
        C_STANDARD_REQUIRED ON
        COMPILE_OPTIONS "-g;-Wall;-Wextra"
)
