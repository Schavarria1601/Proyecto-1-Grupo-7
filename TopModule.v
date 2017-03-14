`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2017 01:12:05 PM
// Design Name: 
// Module Name: TopModule
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


module TopModule(
    clk,
    rst,
    RGB,
    RGB_VGA,
    HSyncVGA,
    VSyncVGA
        
    );
    parameter largo = 10;
    input wire clk;
    input wire rst;
    input wire [2:0] RGB;
    output wire [2:0] RGB_VGA;
    output HSyncVGA;
    output VSyncVGA;

    wire [largo-1:0]pixel_x;
    wire [largo-1:0]pixel_y;
    wire p_tick;
    wire video_on;
    reg [2:0] rgb_reg;
    wire [2:0] rgb_next;
    
    ClkDivider divisor(
        .clk(clk),
        .rst(rst),
        .clk_div(clk_div)
        );
        
        wire clk_div;
        wire clk_in;
        assign clk_in = clk_div;
//Aca tengo que instancear los otros modulos 
//Variable


Sincronizador_S Instanceacion (
              .clk_in(clk_in),
              .rst(rst), 
              .hsync(HSyncVGA), 
              .vsync(VSyncVGA), 
              .video_on(video_on), 
              .p_tick(p_tick),
              .pixel_x(pixel_x), 
              .pixel_y(pixel_y)             
            );   

Generador_de_pixeles Instanceacion2(

    .clk(clk),
    .sw(RGB),
    .video_on(video_on),
    .pixel_x(pixel_x), 
    .pixel_y(pixel_y),
    .rgb_text(rgb_next)
    );

  always @(negedge clk)
    if (p_tick)
        rgb_reg <= rgb_next;

  assign RGB_VGA = rgb_reg;

    
endmodule
