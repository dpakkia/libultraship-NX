# cmake/dependencies/switch.cmake
# Nintendo Switch (devkitPro / libnx) dependency setup

if(NOT DEFINED ENV{DEVKITPRO})
  message(FATAL_ERROR "DEVKITPRO environment variable not set (expected in devkitPro container).")
endif()

set(DEVKITPRO "$ENV{DEVKITPRO}")
set(SWITCH_PORTLIBS_INC "${DEVKITPRO}/portlibs/switch/include")
set(SWITCH_PORTLIBS_LIB "${DEVKITPRO}/portlibs/switch/lib")

# Helpful when portlibs ship libs but no CMake package config files.
# ---- tinyxml2 ----
if(NOT TARGET tinyxml2::tinyxml2)
  find_path(TINYXML2_INCLUDE_DIR
    NAMES tinyxml2.h
    PATHS "${SWITCH_PORTLIBS_INC}"
    NO_DEFAULT_PATH
  )

  find_library(TINYXML2_LIBRARY
    NAMES tinyxml2
    PATHS "${SWITCH_PORTLIBS_LIB}"
    NO_DEFAULT_PATH
  )

  if(NOT TINYXML2_INCLUDE_DIR OR NOT TINYXML2_LIBRARY)
    message(FATAL_ERROR
      "tinyxml2 not found in devkitPro portlibs.\n"
      "Looked for tinyxml2.h in: ${SWITCH_PORTLIBS_INC}\n"
      "Looked for libtinyxml2.a in: ${SWITCH_PORTLIBS_LIB}\n"
      "If it's missing, install tinyxml2 in portlibs or vendor it as a submodule."
    )
  endif()

  add_library(tinyxml2::tinyxml2 STATIC IMPORTED GLOBAL)
  set_target_properties(tinyxml2::tinyxml2 PROPERTIES
    IMPORTED_LOCATION "${TINYXML2_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${TINYXML2_INCLUDE_DIR}"
  )
endif()
