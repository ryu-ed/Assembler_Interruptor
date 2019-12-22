# Assembler_Interruptor


PROGRAMA CON INTERRUPCIONES TRAP, 7.5, 6.5, 5.5 EN ENSAMBLADOR PARA MICRO 8085 INTEL

Las variables estan documentadas en el archivo .asm

El programa se trata de hacer funcionar un display 7 segmentos con interrupciones. 

![alt text](https://github.com/ryu-ed/Assembler_Interruptor/raw/master/simulador1.PNG "Simulador 8085 Intel")

Este es un programa que con un display 7 segmentos creamos un contador de forma ascendente y descendente con los numeros 0 a 99 o 99 a 0.

![alt text](https://github.com/ryu-ed/Assembler_Interruptor/raw/master/display.PNG "Simulador 8085 Intel")
![alt text](https://github.com/ryu-ed/Assembler_Interruptor/raw/master/display2.png "Simulador 8085 Intel")

En la imagen observamos 4 colores que representan los puertos de los contadores de forma ascendente y descendente.

Rojo (INT 7.5) y Azul (INT 5.5) : contador 0 a 99 - Forma Ascendente

Verde(INT 6.5) y Amarillo (INT TRAP) : contador 99 a 0 - Forma Descendente

-------------------------------------------------------------------------------------------------------

Ahora para hacerlo funcionar nos vamos a opciones, opciones de interrupcion  y nos sale una imagen como esta.

![alt text](https://github.com/ryu-ed/Assembler_Interruptor/raw/master/confi.PNG "Simulador 8085 Intel")

En donde debemos habilitar las casillas de interrupcines por milisegundos. 

Podemos utilizar la frecuencia que queramos, pero para efectos de este proyecto se utilizo:

Puerto Rojo 7.5 : 1 Hz -> 1000 milisegundos 

Puerto Verde 6.5 : 2 Hz -> 500 milisegundos

Puerto Azul 5.5 : 4 Hz -> 250 milisegundos 

Puerto Amarillo TRAP : 15 Hz -> 66.66 milisegundos


![alt text](https://github.com/ryu-ed/Assembler_Interruptor/raw/master/confi1.PNG "Simulador 8085 Intel")


Y nos da como resultado algo como esto: 

![alt text](https://github.com/ryu-ed/Assembler_Interruptor/raw/master/display3.png.jpg "Simulador 8085 Intel")
