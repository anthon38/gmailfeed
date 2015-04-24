add_definitions(-DTRANSLATION_DOMAIN="plasma_applet_org.kde.plasma.gmailfeed")
option (USE_QT5 "Use Qt5 instead of Qt4" ON)

find_package(Qt5 ${QT_MIN_VERSION} CONFIG REQUIRED COMPONENTS Network)
find_package(KF5Notifications)

find_package(KAccounts REQUIRED)
find_package(Intltool REQUIRED)
set(ACCOUNTS_MIN_VERSION "1.13")
find_package(AccountsQt5 ${ACCOUNTS_MIN_VERSION} REQUIRED CONFIG)
include_directories(
    ${ACCOUNTSQT_INCLUDE_DIRS}
)

# TODO: remove when depending on KDE Applications 15.08
if (NOT DEFINED kaccounts_add_service)
    include(../cmake/FindAccountsFileDir.cmake)

    function(kaccounts_add_service service_file_in)
        get_filename_component(service_filename ${service_file_in} NAME_WE)
        set(service_file ${CMAKE_CURRENT_BINARY_DIR}/${service_filename}.service)
        execute_process(COMMAND intltool-merge -x -u --no-translations ${service_file_in} ${service_file})
        install(FILES ${service_file} DESTINATION ${ACCOUNTS_SERVICES_DIR})
    endfunction()

    function(kaccounts_add_provider provider_in_file)
        get_filename_component(provider_filename ${provider_in_file} NAME_WE)
        set(provider_file ${CMAKE_CURRENT_BINARY_DIR}/${provider_filename}.provider)
        execute_process(COMMAND intltool-merge -x -u --no-translations ${provider_in_file} ${provider_file})
        install(FILES ${provider_file} DESTINATION ${ACCOUNTS_PROVIDERS_DIR})
    endfunction()

endif ()

kaccounts_add_service(${CMAKE_CURRENT_SOURCE_DIR}/gmail-feed.service.in)
kaccounts_add_provider(${CMAKE_CURRENT_SOURCE_DIR}/google-gmail.provider.in)

set(gmailfeedplugin_SRCS
    gmailfeedplugin.cpp
    networkstatus.cpp
    notification.cpp
    account.cpp
)

install(FILES qmldir DESTINATION ${QML_INSTALL_DIR}/org/kde/plasma/private/gmailfeed)
add_library(gmailfeedplugin SHARED ${gmailfeedplugin_SRCS})

target_link_libraries(gmailfeedplugin
                        Qt5::Quick
                        Qt5::Network
                        KF5::Notifications
                        KAccounts
                        )

install(TARGETS gmailfeedplugin DESTINATION ${QML_INSTALL_DIR}/org/kde/plasma/private/gmailfeed)
