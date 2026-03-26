set(SUB_SRC2_FILES sub2.c)

add_library(LIB_SRC2 ${SUB_SRC2_FILES})

target_include_directories(LIB_SRC2 PUBLIC ${PROJECT_SOURCE_DIR}/inc)
