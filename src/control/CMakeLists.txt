
aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR} DIR_LIB_SRCS)

add_library(control )
target_sources(control PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
target_include_directories(control PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

