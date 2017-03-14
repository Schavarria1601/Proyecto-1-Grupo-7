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
    rgb_text,
    font_bit
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
    output wire font_bit;
    //  Señales locales creadas con el fin de acceder a la memoria.  
    //  Parametrización del bus de datos de dichas locales.
    parameter bus_rom_addr = 10;
    parameter bus_char_addr = 6;
    parameter bus_row_addr = 3;
    parameter bus_bit_addr = 2;
    parameter bus_font_word = 7; 
    wire [bus_rom_addr:0] rom_addr;   
    reg [bus_char_addr:0] char_addr;
    wire [bus_row_addr:0] row_addr;
    wire [bus_bit_addr:0] bit_addr;
    wire [bus_font_word:0] font_word;
    wire [2:0] sw_reg;
    assign  sw_reg = sw;
      
    //  Instanceación del módulo de Memoria.
    font_rom memoria(
    .clk(clk),
    .addr(rom_addr),
    .data(font_word)
    );
         
    //  Asignación de las señales locales creadas en la parte superior con sus respectivas señales locales debidamente
    //  parametrizadas.
    //assign char_addr = {pixel_y[bus_pixeles-5:4], pixel_x[bus_pixeles-3:3]};
    assign row_addr = pixel_y[3:0];
    assign rom_addr = {char_addr, row_addr};
    assign bit_addr = pixel_x[2:0];
    assign font_bit = font_word[~bit_addr];
    //region delimitada para el texto
    assign text_bit_on = (pixel_y[9:4]==12);
   
    //Ubicación de letras en la pantalla
    always @*
    
        case(pixel_x[8:3])
            6'h25 :  char_addr = 7'h44 ;
            6'h27 :  char_addr = 7'h47 ;
            6'h29 :  char_addr = 7'h53 ;
    
            default: char_addr = 7'h00; // espacio en blanco
         endcase 
   
    
    always @*   //  Siempre que exista una lógica combinacional:
        if (~video_on)  //  Si vide_on no está encendidad:
            rgb_text = 3'b000; //  La pantalla se torna de color blanco.
        else    //  Sino,
            begin
            if (~text_bit_on)    //  Si la señal text_bit_on está encendida:
                begin
                rgb_text = 3'b000;  //  La pantalla se torna de color verde.
                end
            else    //  Sino,
                if (font_bit)
                begin
                rgb_text = sw_reg; //  La pantalla se torna de color negro.
                end
            else
                begin
                rgb_text = 3'b000;
                end
            end 
                   
endmodule   //  Fin del módulo.
