add_definitions(-DTRANSLATION_DOMAIN="plasma_applet_org.kde.plasma.gmailfeed")
option (USE_QT5 "Use Qt5 instead of Qt4" ON)

find_package(Qt5 ${QT_MIN_VERSION} CONFIG REQUIRED COMPONENTS Network)
find_package(KF5Notifications)

set(gmailfeedplugin_SRCS
    gmailfeedplugin.cpp
    networkstatus.cpp
    notification.cpp
)

install(FILES qmldir DESTINATION ${QML_INSTALL_DIR}/org/kde/plasma/private/gmailfeed)
add_library(gmailfeedplugin SHARED ${gmailfeedplugin_SRCS})

target_link_libraries(gmailfeedplugin
                        Qt5::Quick
                        Qt5::Network
                        KF5::Notifications
                        )

install(TARGETS gmailfeedplugin DESTINATION ${QML_INSTALL_DIR}/org/kde/plasma/private/gmailfeed)