cmake_minimum_required(VERSION 3.16)
project(Z80MiniFrameFirmware NONE)

set(FIRMWARE_SYSTEM "Z80AIO" CACHE STRING "System define passed to zmac")
set(EPROM_MEMTYPE "27256" CACHE STRING "EPROM type used by epromng")
set(EPROM_COM_PORT "COM6" CACHE STRING "Serial port used by epromng")

find_program(ZMAC_EXECUTABLE NAMES zmac)
find_program(LD80_EXECUTABLE NAMES ld80)
find_program(DOS2UNIX_EXECUTABLE NAMES dos2unix)
find_program(EPROMNG_EXECUTABLE NAMES epromng)

if(NOT ZMAC_EXECUTABLE)
    message(FATAL_ERROR "zmac was not found. Install ZMAC or set ZMAC_EXECUTABLE.")
endif()
if(NOT LD80_EXECUTABLE)
    message(FATAL_ERROR "ld80 was not found. Install LD80 or set LD80_EXECUTABLE.")
endif()

set(SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/source")
set(BIN_DIR "${CMAKE_CURRENT_BINARY_DIR}/bin")
file(GLOB_RECURSE ASSEMBLER_INCLUDES CONFIGURE_DEPENDS
    "${SOURCE_DIR}/include/*.inc")

set(ASSEMBLY_MODULES
    ppi psg pit vdp buffer serial keyboard conio casette cf fat32 monitor common
    svcroutine main bas32K)

set(OBJECT_FILES)
foreach(module IN LISTS ASSEMBLY_MODULES)
    set(object_file "${BIN_DIR}/${module}.rel")
    add_custom_command(
        OUTPUT "${object_file}"
        COMMAND "${CMAKE_COMMAND}" -E make_directory "${BIN_DIR}"
        COMMAND "${ZMAC_EXECUTABLE}"
            "${module}.asm"
            -I "${SOURCE_DIR}/include"
            --rel7
            "-D${FIRMWARE_SYSTEM}"
            -DIM_2
            -o "${object_file}"
        DEPENDS
            "${SOURCE_DIR}/${module}.asm"
            ${ASSEMBLER_INCLUDES}
        WORKING_DIRECTORY "${SOURCE_DIR}"
        COMMENT "Assembling ${module}.asm"
        VERBATIM)
    list(APPEND OBJECT_FILES "${object_file}")
endforeach()

# Keep the link order used by the original Makefile.
set(LINK_OBJECTS
    main.rel svcroutine.rel monitor.rel common.rel conio.rel ppi.rel pit.rel
    psg.rel vdp.rel buffer.rel serial.rel keyboard.rel casette.rel cf.rel
    fat32.rel bas32K.rel)
set(LINK_INPUTS)
foreach(object IN LISTS LINK_OBJECTS)
    list(APPEND LINK_INPUTS "${BIN_DIR}/${object}")
endforeach()

set(FIRMWARE_HEX "${BIN_DIR}/firmware.hex")
set(HEX_NORMALIZE_COMMAND)
if(DOS2UNIX_EXECUTABLE)
    set(HEX_NORMALIZE_COMMAND
        COMMAND "${DOS2UNIX_EXECUTABLE}" firmware.hex)
endif()

add_custom_command(
    OUTPUT "${FIRMWARE_HEX}"
    COMMAND "${CMAKE_COMMAND}" -E make_directory "${BIN_DIR}"
    COMMAND "${LD80_EXECUTABLE}" -O hex -o firmware.hex -s symbols.sym
        ${LINK_OBJECTS}
    ${HEX_NORMALIZE_COMMAND}
    DEPENDS ${LINK_INPUTS}
    WORKING_DIRECTORY "${BIN_DIR}"
    COMMENT "Linking firmware.hex"
    VERBATIM)

add_custom_target(firmware ALL DEPENDS "${FIRMWARE_HEX}")

if(EPROMNG_EXECUTABLE)
    add_custom_target(burn
        COMMAND "${EPROMNG_EXECUTABLE}" -mem "${EPROM_MEMTYPE}" -spi y -auto y
            "${FIRMWARE_HEX}" "${EPROM_COM_PORT}"
        DEPENDS "${FIRMWARE_HEX}"
        COMMENT "Programming firmware into the EPROM"
        VERBATIM)
else()
    message(STATUS "epromng not found; the burn target will not be available")
endif()
