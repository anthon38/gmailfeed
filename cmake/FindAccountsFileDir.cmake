find_package(PkgConfig REQUIRED)

execute_process(
    COMMAND "${PKG_CONFIG_EXECUTABLE}" --variable=prefix libaccounts-glib
    OUTPUT_VARIABLE _pkgconfig_invoke_result
    RESULT_VARIABLE _pkgconfig_failed)

if (_pkgconfig_failed)
    message(FAILED "Couldn't find the prefix for libaccounts-glib")
else()
    string(REGEX REPLACE "[\r\n]"                  " " _pkgconfig_invoke_result "${_pkgconfig_invoke_result}")
    string(REGEX REPLACE " +$"                     ""  _pkgconfig_invoke_result "${_pkgconfig_invoke_result}")
    set(ACCOUNTS_PREFIX_DIR ${_pkgconfig_invoke_result})
endif()

execute_process(
    COMMAND "${PKG_CONFIG_EXECUTABLE}" --variable=providerfilesdir libaccounts-glib
    OUTPUT_VARIABLE _pkgconfig_invoke_result
    RESULT_VARIABLE _pkgconfig_failed)

if (_pkgconfig_failed)
    message(FAILED "Couldn't find the providerfilesdir for libaccounts-glib")
else()
    string(REGEX REPLACE "[\r\n]"                  " " _pkgconfig_invoke_result "${_pkgconfig_invoke_result}")
    string(REGEX REPLACE " +$"                     ""  _pkgconfig_invoke_result "${_pkgconfig_invoke_result}")
    if (NOT CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
        string(REPLACE ${ACCOUNTS_PREFIX_DIR} ${CMAKE_INSTALL_PREFIX} _pkgconfig_invoke_result "${_pkgconfig_invoke_result}")
    endif()
    set(ACCOUNTS_PROVIDERS_DIR ${_pkgconfig_invoke_result})
endif()

execute_process(
    COMMAND "${PKG_CONFIG_EXECUTABLE}" --variable=servicefilesdir libaccounts-glib
    OUTPUT_VARIABLE _pkgconfig_invoke_result
    RESULT_VARIABLE _pkgconfig_failed)

if (_pkgconfig_failed)
    message(FAILED "Couldn't find the servicefilesdir for libaccounts-glib")
else()
    string(REGEX REPLACE "[\r\n]"                  " " _pkgconfig_invoke_result "${_pkgconfig_invoke_result}")
    string(REGEX REPLACE " +$"                     ""  _pkgconfig_invoke_result "${_pkgconfig_invoke_result}")
    if (NOT CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
        message("yooo")
        string(REPLACE ${ACCOUNTS_PREFIX_DIR} ${CMAKE_INSTALL_PREFIX} _pkgconfig_invoke_result "${_pkgconfig_invoke_result}")
    endif()
    set(ACCOUNTS_SERVICES_DIR ${_pkgconfig_invoke_result})
endif()

find_package_handle_standard_args(AccountsFileDir DEFAULT_MSG
                                  ACCOUNTS_SERVICES_DIR ACCOUNTS_PROVIDERS_DIR)

