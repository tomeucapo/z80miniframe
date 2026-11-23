;; CompactFlash IDE task-file ports.
;; The backplane decodes IOCS6 and maps the task-file registers at $A0-$A7.

CF_DATA         .EQU    $A0
CF_ERROR        .EQU    $A1             ; Read
CF_FEATURES     .EQU    $A1             ; Write
CF_SECTOR_COUNT .EQU    $A2
CF_LBA_LOW      .EQU    $A3
CF_LBA_MID      .EQU    $A4
CF_LBA_HIGH     .EQU    $A5
CF_DEVICE       .EQU    $A6
CF_STATUS       .EQU    $A7             ; Read
CF_COMMAND      .EQU    $A7             ; Write

CF_CMD_READ     .EQU    $20
CF_CMD_WRITE    .EQU    $30
CF_CMD_SET_FEAT .EQU    $EF
CF_FEATURE_8BIT .EQU    $01

CF_STATUS_ERR   .EQU    $01
CF_STATUS_DRQ   .EQU    $08
CF_STATUS_DF    .EQU    $20
CF_STATUS_BSY   .EQU    $80

CF_ERR_TIMEOUT  .EQU    $FF
CF_ERR_LBA      .EQU    $FE
