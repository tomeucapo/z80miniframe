;; FAT32 on-disk layout and API return codes.
FAT32_SECTOR_BUFFER .EQU $FE00

FAT32_ERR_IO        .EQU $F1
FAT32_ERR_FORMAT    .EQU $F2
FAT32_ERR_NOTFOUND  .EQU $F3
FAT32_ERR_RANGE     .EQU $F4
FAT32_ERR_CHAIN     .EQU $F5

;; API: F32MNT mounts the volume; F32DIR lists its FAT32 root directory.
