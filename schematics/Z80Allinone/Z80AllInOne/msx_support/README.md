# MSX support — primera versión

Esta carpeta reúne el trabajo inicial para añadir compatibilidad MSX1 al
Z80AIO mediante una placa conectada al bus de expansión.

## Alcance propuesto

- Reutilizar el VDP TMS9918A, el PSG AY-3-8910 y el PPI 8255 internos.
- Mantener la ROM y la RAM con el mapa fijo actual.
- Añadir alias de los puertos MSX mediante un ATF1502AS:
  - VDP: `98h–99h`
  - PSG: `A0h–A1h`
  - PPI: `A8h–ABh`
- Dejar para una versión posterior la selección de slots, memoria externa y
  mapeadores de cartucho.
- No cambiar en esta versión el cableado actual del teclado; su compatibilidad
  con el escaneo MSX queda pendiente.

## Decodificador de E/S

`msx_io_decode.v` contiene el bloque combinacional para el primer ATF1502AS.
Usa `A[7:0]` y `/IORQ` y entrega tres selecciones activas en bajo. Los bits
`A[8:15]` se ignoran para respetar la decodificación MSX del byte bajo.

En la placa base, cada salida se combina con la selección nativa activa en bajo
mediante una AND:

```text
/VDP_CE_FINAL = /VDP_CE_NATIVO AND /MSX_VDP_CE
/PSG_CE_FINAL = /PSG_CE_NATIVO AND /MSX_PSG_CE
/PPI_CE_FINAL = /PPI_CE_NATIVO AND /MSX_PPI_CE
```

No se deben unir directamente las salidas de los dos decodificadores. El ATF
necesitará tres conexiones desde sus salidas a las AND de la placa base. La
asignación de pines del PLCC-44 y la conexión física aún no están definidas.

## Conflicto con CompactFlash

El firmware actual asigna CompactFlash a `A0h–A7h` (`source/include/cf.inc`).
Esto se solapa con los puertos MSX del PSG en `A0h–A1h`. Si la interfaz CF está
conectada, deberá deshabilitarse en modo MSX o cambiarse su mapa de puertos.

El código Verilog actual todavía no implementa el jumper `MSX_MODE` ni la
inhibición de CF. Hay que añadirlos antes de generar el diseño final.

## Pendiente

- Definir el modo normal/MSX y el tratamiento de CompactFlash.
- Confirmar la polaridad de las señales `CE` en la placa base.
- Diseñar la interposición física de las tres AND y llevar las tres selecciones
  MSX desde la expansión.
- Asignar pines del ATF1502 y generar/verificar el archivo JEDEC con las
  herramientas de Microchip.
- Resolver por separado la compatibilidad del teclado y los usos actuales del
  PPI.
