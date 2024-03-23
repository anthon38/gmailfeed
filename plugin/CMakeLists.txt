add_definitions(-DTRANSLATION_DOMAIN="plasma_applet_org.kde.plasma.gmailfeed")

find_package(Qt6 ${QT_MIN_VERSION} CONFIG REQUIRED COMPONENTS Network Xml)
find_package(KF6Notifications)

find_package(KAccounts6 REQUIRED)
find_package(Intltool REQUIRED)
find_package(AccountsQt6 ${ACCOUNTS_MIN_VERSION} REQUIRED CONFIG)
include_directories(
    ${ACCOUNTSQT_INCLUDE_DIRS}
)

kaccounts_add_service(${CMAKE_CURRENT_SOURCE_DIR}/gmail-feed.service.in)
kaccounts_add_provider(${CMAKE_CURRENT_SOURCE_DIR}/google-gmail.provider.in)

set(gmailfeedplugin_SRCS
    gmailfeedplugin.cpp
    networkstatus.cpp
    account.cpp
    accountsModel.cpp
    gxmlModel.cpp
)

install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/plasma/private/gmailfeed)
add_library(gmailfeedplugin SHARED ${gmailfeedplugin_SRCS})

target_link_libraries(gmailfeedplugin
                        Qt6::Quick
                        Qt6::Network
                        Qt6::Concurrent
                        KF6::Notifications
                        KAccounts6
                        )

install(TARGETS gmailfeedplugin DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/plasma/private/gmailfeed)
