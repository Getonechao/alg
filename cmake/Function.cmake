# # # # # # # # # 
#  function name: AddCMakeLists()
#  简介：
#      以CMAKE_CURRENT_SOURCE_DIR为根目录，
#      递归查找CMakeLists.txt文件，
#      将其所在目录加入add_subdirectory
# # # # # # # # # 
function(AddSubCMakeLists)
  message(" ")
    file(GLOB_RECURSE RET RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} CMakeLists.txt)
    foreach(item ${RET})
        get_filename_component(dir ${item} DIRECTORY)
        if(dir STREQUAL "")
            continue()
        else()
          add_subdirectory(${dir})
          message(STATUS "I have added subdirectory: ${dir}")    
        endif()
    endforeach()  
endfunction(AddSubCMakeLists)

# # # # # # # # # 
#  function name: Sys_link_LIBS()
#  简介：
#      系统库查找
#  参数：
#      TARGET_NAME: 目标名称
#      libname: 库名称
#      version: 版本
#      component: 组件
# # # # # # # # #
function(Sys_link_LIBS TARGET_NAME libname )
  set(oneValueArgs VERSION )
  set(multiValueArgs COMPONENT)
  cmake_parse_arguments(LIBS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
  
  message(STATUS "I will try to find \"${libname}(${LIBS_VERSION}):${LIBS_COMPONENT}\" by system")
  
   if(LIBS_VERSION)
    if(LIBS_COMPONENT)
      find_package(${libname} ${LIBS_VERSION} REQUIRED COMPONENTS ${LIBS_COMPONENT})
    else()
      find_package(${libname} ${LIBS_VERSION} REQUIRED)
    endif()
  else()
    if(LIBS_COMPONENT)
      find_package(${libname} REQUIRED COMPONENTS ${LIBS_COMPONENT})
    else()
      find_package(${libname} REQUIRED)
    endif()
  endif()
 
  find_package(${libname} ${version} REQUIRED  COMPONENTS ${component} )
  
  if(${libname}_FOUND)
    target_include_directories(${TARGET_NAME} PUBLIC ${${libname}_INCLUDE_DIRS})
    target_link_directories(${PROJECT_NAME} PUBLIC ${${libname}_LIBDIR})
    target_link_libraries(${TARGET_NAME} PUBLIC ${${libname}_LIBRARIES})
  else()
    message(FATAL_ERROR "you don't install ${libname}; ${libname} not found")
  endif()
endfunction(Sys_link_LIBS)




# # # # # # # # # 
#  function name: Pkgconfig_Link_LIBS()
#  简介：
#      pkgconfig查找库
#  参数：
#      TARGET_NAME: 目标名称
#      libname: 库名称
#      PKGCONFIG_PATH: pkgconfig路径
#
# # # # # # # # # 
function(Pkgconfig_Link_LIBS TARGET_NAME libname PKGCONFIG_PATH )
  message(" ")
  message(STATUS "I will try to find \"${libname}\" by PkgConfig ")
  set(ENV{PKG_CONFIG_PATH}  "$ENV{PKG_CONFIG_PATH};${PKGCONFIG_PATH}")
  if(PkgConfig_FOUND)
    pkg_check_modules(LIBVAR REQUIRED ${libname})
    target_include_directories(${TARGET_NAME} PUBLIC  ${LIBVAR_INCLUDE_DIRS})
    target_link_directories(${PROJECT_NAME} PUBLIC ${LIBVAR_LIBDIR})
    target_link_libraries(${TARGET_NAME} PUBLIC ${LIBVAR_LIBRARIES})
  else()
    message(STATUS "PkgConfig not found, I will try find_package(PkgConfig)")
    find_package(PkgConfig REQUIRED)
    if(PkgConfig_FOUND)
      pkg_check_modules(LIBVAR REQUIRED ${libname})
      target_include_directories(${TARGET_NAME}  PUBLIC ${LIBVAR_INCLUDE_DIRS})
      target_link_directories(${PROJECT_NAME} PUBLIC ${LIBVAR_LIBDIR})
      target_link_libraries(${TARGET_NAME} PUBLIC ${LIBVAR_LIBRARIES})
    else()
      message(FATAL_ERROR "you don't install pkg-config; PkgConfig not found")
    endif()
  endif()
endfunction(Pkgconfig_Link_LIBS)


# # # # # # # # #
#  function name: Target_Link_myLIBS()
#  简介：
#      link TARGET库
#  参数：
#      TARGET_NAME: 目标名称
#      libname: 库名称
# # # # # # # # #
function(Target_Link_myLIBS TARGET_NAME  libname)
  message(" ")
  if(TARGET ${libname})
    target_link_libraries(${TARGET_NAME} ${libname})
  else()
    message(FATAL_ERROR "target ${libname}) not exit")
  endif()
endfunction(Target_Link_myLIBS)


# # # # # # # # #
# function name: CloseSource_Link_LIBS()
# 简介：
#     link 闭源库
# 参数：
#     TARGET_NAME: 目标名称
#     LIB_TARGET_NAME: 闭源库在cmake中的target名称
#     LIB_TYPE: 库类型 "STATIC" "SHARED"
#     CS_INCLUDE_PATH: 闭源库头文件路径
#     CS_LIB_PATH: 闭源库路径
#     CS_LIBS: 闭源库名称 eg: "libxxx1.a;libxxx2.a"
# # # # # # # # #
function(CloseSource_Link_LIBS TARGET_NAME LIB_TARGET_NAME LIB_TYPE CS_INCLUDE_PATH CS_LIB_PATH CS_LIBS)
  message(" ")
  # add lib
  add_library(${LIB_TARGET_NAME} ${LIB_TYPE} IMPORTED)
  # interface include

  if(EXISTS ${CMAKE_SOURCE_DIR}/${CS_INCLUDE_PATH})
    target_include_directories(${LIB_TARGET_NAME} INTERFACE ${CMAKE_SOURCE_DIR}/${CS_INCLUDE_PATH})
  else()
    message(FATAL_ERROR "interface: ${CMAKE_SOURCE_DIR}/${CS_INCLUDE_PATH} not exit")
  endif()
  # interface lib  
  foreach(item ${CS_LIBS})
  #判断item为空

    if("${item}" EQUAL "")
      break() 
      message(STATUS "interface:  CS_LIBS is empty")     
    endif(item)
    
    if(EXISTS ${CMAKE_SOURCE_DIR}/${CS_LIB_PATH}/${item})
    set_property(TARGET ${LIB_TARGET_NAME} PROPERTY IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/${CS_LIB_PATH}/${item}")
    else()
      message(FATAL_ERROR "interface: ${CMAKE_SOURCE_DIR}/${CS_LIB_PATH}/${item} not exit")
    endif()
  endforeach()

  # link TARGET_NAME
  target_link_libraries(${TARGET_NAME} PUBLIC ${LIB_TARGET_NAME})

endfunction()


