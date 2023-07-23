cmake_minimum_required(VERSION 3.15)

project(PROJECT_XXX VERSION 0.0.0 )

#C/C++标准
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 14)


#设置编译器
set (CMAKE_C_COMPILER "/usr/bin/gcc")
set (CMAKE_CXX_COMPILER "/usr/bin/g++")

######### build 变量 #####
set(CMAKE_BUILD_TYPE Debug#[[Release | Debug| RelWithDebInfo |MinSizeRel]])
set(CMAKE_BUILD_PARALLEL_LEVEL 4)#编译处理器数量
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)#clang
set(CMAKE_GENERATOR "Unix Makefiles")#“Ninja”、“Unix Makefiles”、“Visual Studio”
#add_compile_options()#等同CMAKE_CXXFLAGS_RELESE,前者可以对所有的编译器设置，后者只能是C++编译器

########## vcpkg #######
#set(CMAKE_TOOLCHAIN_FILE  $ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake)
#set(ENV{PKG_CONFIG_PATH}  "$ENV{PKG_CONFIG_PATH};${CMAKE_SOURCE_DIR}/vcpkg_installed/x64-linux/lib/pkgconfig")


#lib&&bin输出目录
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/build/bin)#可执行文件
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/build/lib)#动态库
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/build/lib/static)#静态库


###### sub directory #####
add_subdirectory(src)
#add_subdirectory(external)

########## TEST ##########
if(FALSE)
	enable_testing()
	add_subdirectory(test)
	add_test(NAME test COMMAND ${PROJECT_NAME} -arg1 -arg2)
endif()

########## istanll #######
set(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR}/install)
# 1.target  放到 DESTINATION 指定的目录
#install(TARGETS ... RUNTIME DESTINATION bin)#exe
#install(TARGETS ... LIBRARY DESTINATION lib)#*.so
#install(TARGETS ... ARCHIVE DESTINATION lib/static)#*.lib
#install(TARGETS ... PUBLIC_HEADER DESTINATION include)#公共头文件的安装路径
#install(TARGETS ... RESOURCE 	   DESTINATION <dir>)#私有头文件的安装路径
# 2.普通文件 放置放到 DESTINATION 指定的目录,eg:readme.md config.ini
#install(FILES ... DESTINATION etc)
# 3.目录
#install(DIRECTORY ... DESTINATION ...)
# 4.脚本    放置到 DESTINATION 指定的目录,eg:install.sh
#install(PROGRAMS ... DESTINATION ...)
# 5.target集合
#install(TARGETS ...  EXPORT export_name RUNTIME DESTINATION bin)#exe
#install(EXPORT export_name NAMESPACE namespace DESTINATION <dir>)

########## PACK ##########
if(FALSE)
# 安装包名称
set(CPACK_PACKAGE_NAME ${PROJECT_NAME})
# 版本号                       
set(CPACK_PACKAGE_VERSION "1.0.0") 
# 描述信息
set(CPACK_PACKAGE_DESCRIPTION "My awesome application")
# 许可证                                  
set(CPACK_RPM_PACKAGE_LICENSE "Apache 2.0 + Common Clause 1.0")
# vendor                             
set(CPACK_PACKAGE_VENDOR "vesoft")  
# 安装包图标
#set(CPACK_PACKAGE_ICON )

#配置软件包类型和生成器ZIP、TGZ、RPM、NSIS
set(CPACK_GENERATOR ZIP)#二进制包
#set(CPACK_SOURCE_GENERATOR ZIP)#源码包

#安装系统依赖库
include(InstallRequiredSystemLibraries)

#安装安装包时的依赖关系
#set(CPACK_DEBIAN_PACKAGE_DEPENDS "")#Debian自动安装依赖
#set(CPACK_RPM_PACKAGE_REQUIRES "")

#添加脚本和配置
#set(CPACK_PRE_INSTALL_SCRIPTS "${CMAKE_CURRENT_SOURCE_DIR}/pre_install_script.sh")#安装前,目录权限
#set(CPACK_POST_INSTALL_SCRIPTS "${CMAKE_CURRENT_SOURCE_DIR}/post_install_script.sh")#安装后，systemctl自启动脚本

# 设置支持指定安装目录的控制为 ON;设置安装到的目录路径                                   
#set(CPACK_SET_DESTDIR ON)
#set(CPACK_INSTALL_PREFIX )   
include(CPack)
endif()