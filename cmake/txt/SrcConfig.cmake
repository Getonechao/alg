######### Target EXE #########
include(${CMAKE_SOURCE_DIR}/cmake/Function.cmake)


# # # # #
# 1. Add source files to EXE_SRC_LISTS
# # # # #
aux_source_directory(${CMAKE_CURRENT_LIST_DIR} EXE_SRC_LISTS)

# # # # #
# 2. Add EXE target
# # # # #
add_executable(${PROJECT_NAME} )
target_sources(${PROJECT_NAME} PUBLIC  ${EXE_SRC_LISTS})

# # # # #
# 3. Add EXE target (which itself ) include directories
# # # # #
  #include选项
# target_include_directories(${PROJECT_NAME} PUBLIC )
  #link选项
# target_link_directories(${PROJECT_NAME} PUBLIC)
# target_link_libraries(${PROJECT_NAME} PUBLIC)
# target_link_options(${PROJECT_NAME} PUBLIC)
  #compile选项
# target_compile_options(${PROJECT_NAME} PUBLIC -Wall -O3 -std=c++11 )
# target_compile_definitions(${PROJECT_NAME} PUBLIC CMAKE_BUILD_TYPE=Release CMAKE_EXPORT_COMPILE_COMMANDS=ON)
# target_compile_features(${PROJECT_NAME} PUBLIC)
  #precompile选项
# target_precompile_headers(${PROJECT_NAME} PUBLIC)

# # # # #
# 4. third library( from vcpkg, 清单pkgconfig模式)
#  function name: Pkgconfig_Link_LIBS()
#  简介：
#      pkgconfig查找库
#  参数：
#      TARGET_NAME: 目标名称
#      libname: 库名称
#      PKGCONFIG_PATH: pkgconfig路径
# # # # #
find_package(PkgConfig REQUIRED)
set(VCPKG_PKGCONFIG_PATH "${CMAKE_SOURCE_DIR}/vcpkg_installed/x64-linux/lib/pkgconfig" )
Pkgconfig_Link_LIBS(${PROJECT_NAME}  sqlite3 ${VCPKG_PKGCONFIG_PATH})
Pkgconfig_Link_LIBS(${PROJECT_NAME}  libcjson ${VCPKG_PKGCONFIG_PATH})



# # # # #
# 5. my lib targets
#  function name: Target_Link_myLIBS()
#  简介：
#      link TARGET库
#  参数：
#      TARGET_NAME: 目标名称
#      libname: sub subdirectory中的库名称
# # # # #
AddSubCMakeLists()
# Target_Link_myLIBS(${PROJECT_NAME} libs)


# # # # #
# 6. close source库
# function name: CloseSource_Link_LIBS()
# 简介：
#     link 闭源库
# 参数：
#     TARGET_NAME: 目标名称
#     LIB_TARGETNAME: 闭源库在cmake中的target名称
#     LIB_TYPE: 库类型 "STATIC" "SHARED"
#     CS_INCLUDE_PATH: 闭源库头文件路径
#     CS_LIB_PATH: 闭源库路径
#     CS_LIBS: 闭源库名称 eg: "libxxx1.a;libxxx2.a"
# # # # #
CloseSource_Link_LIBS(${PROJECT_NAME} hello STATIC "extern" "extern" "liblibs.a" )

# # # # # # # # # 
# 7. system库
#  function name: Sys_link_LIBS()
#  简介：
#      系统库查找
#  参数：
#      TARGET_NAME: 目标名称
#      libname: 库名称
#      VERSION: 版本
#      COMPONENT: 组件
# # # # # # # # #

Sys_link_LIBS(${PROJECT_NAME} Boost VERSION 1.65  COMPONENT system filesystem)