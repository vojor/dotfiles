set(SUB_SRC1_FILES sub1.c)

add_library(LIB_SRC1 ${SUB_SRC1_FILES})

target_include_directories(LIB_SRC1 PUBLIC ${PROJECT_SOURCE_DIR}/inc)
