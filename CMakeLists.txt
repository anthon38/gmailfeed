cmake_minimum_required(VERSION 3.5.0)

project(gmailfeed)

set(QT_MAJOR_VERSION 6)

find_package(ECM 0.0.11 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules)

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)

find_package(Qt6 ${REQUIRED_QT_VERSION} CONFIG REQUIRED Quick Concurrent)
find_package(Plasma REQUIRED)
find_package(KF6I18n NO_MODULE)

plasma_install_package(package org.kde.plasma.gmailfeed)
 
add_subdirectory( plugin )
add_subdirectory( icons )

install(FILES gmailfeed.notifyrc DESTINATION ${KDE_INSTALL_KNOTIFYRCDIR})

ki18n_install( po )
