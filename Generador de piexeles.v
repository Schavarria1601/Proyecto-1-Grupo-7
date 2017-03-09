`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2017 06:03:09 PM
// Design Name: 
// Module Name: Generador de piexeles
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


    module Generador_de_pixeles(
    //reset,
    clk,
    video_on,
    sw,
    pixel_x, pixel_y,
    rgb_text
    );
    //input reset;    //  Entrada reset para inicializar las señales
    input wire clk; //  Entrada del reloj del módulo
    input wire video_on;    //  Señal de encendido de la pantalla: si ella no está encendida, no se desplegará
    input [2:0] sw;                        //  nada en pantalla aunque se tenga un dato leído de la memoria
                            
    //  Parametrización del bus de datos
    parameter bus_pixeles = 10; 
    parameter bus_rgb = 3;
    
    input wire [bus_pixeles-1:0] pixel_x, pixel_y;    //  Bus de datos para los pixeles con la parametrización
    output reg [bus_rgb-1:0] rgb_text;  //  Bus de datos para las salidas con la parametrización
    
    //  Señales locales creadas con el fin de acceder a la memoria.  
    //  Parametrización del bus de datos de dichas locales.
    parameter bus_rom_addr = 10;
    parameter bus_char_addr = 6;
    parameter bus_row_addr = 3;
    parameter bus_bit_addr = 2;
    parameter bus_font_word = 7; 
    wire [bus_rom_addr:0] rom_addr;   
    wire [bus_char_addr:0] char_addr;
    wire [bus_row_addr:0] row_addr;
    wire [bus_bit_addr:0] bit_addr;
    wire [bus_font_word:0] font_word;
    wire font_bit, text_bit_on;
    wire [2:0] sw_reg;
    assign  sw_reg = sw;
      
    //  Instanceación del módulo de Memoria.
    font_rom memoria(
    .clk(clk),
    .addr(rom_addr),
    .rom_data(font_word)
    );
         
    //  Asignación de las señales locales creadas en la parte superior con sus respectivas señales locales debidamente
    //  parametrizadas.
    assign char_addr = {pixel_y[bus_pixeles-5:4], pixel_x[bus_pixeles-3:3]};
    assign row_addr = pixel_y[bus_pixeles-3:0];
    assign rom_addr = {char_addr, row_addr};
    assign bit_addr = pixel_x[bus_pixeles-8:0];
    assign font_bit = font_word[~bit_addr];
    assign text_bit_on = (pixel_x[bus_pixeles-1:8]==0 && pixel_y[bus_pixeles-1:6]==0) ? font_bit : 1'b0;
    
    always @*   //  Siempre que exista una lógica combinacional:
        if (~video_on)  //  Si vide_on no está encendidad:
            rgb_text = 3'b000; //  La pantalla se torna de color blanco.
        else    //  Sino,
            if (text_bit_on)    //  Si la señal text_bit_on está encendida:
                rgb_text = sw_reg;  //  La pantalla se torna de color verde.
            else    //  Sino,
                rgb_text = 3'b000; //  La pantalla se torna de color negro.
                   
endmodule   //  Fin del módulo.