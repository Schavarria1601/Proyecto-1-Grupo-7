`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2017 10:31:29 PM
// Design Name: 
// Module Name: Sincronizador_S
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

// 25Mhz es la frecuencia necesaria, esto permite recorrer 25 millones
// de pixeles en un segundo.

module Sincronizador_S(
      clk_in,
      rst, 
      hsync,
      vsync, 
      video_on, 
      p_tick,
      pixel_x, 
      pixel_y
     
    );
    
    parameter largo = 10;
    input wire clk_in,rst;
    output wire hsync, vsync, video_on, p_tick;
    output wire [largo-1:0] pixel_x, pixel_y;
    
  //Declaración de constantes*** Parámetros de sincronización.
    localparam HDisplayArea = 640; //parte visible
    localparam HFront = 48; //H front border
    localparam HBack = 16; //H back border
    localparam HRetrace = 96; 
    localparam VDisplayArea = 480;
    localparam VFront = 10;
    localparam VBack = 33;
    localparam VRetrace = 2;
  
  //contador mod-2
  reg mod2_reg;
  wire mod2_next;
  
  //contadores de sincronizacion
  reg [largo-1:0] h_count_reg, h_count_next;
  reg [largo-1:0] v_count_reg , v_count_next;
  //output buffer
  reg v_sync_reg, h_sync_reg;
  wire v_sync_next, h_sync_next;
  
  //estado de la señal
  wire  h_end, v_end, pixel_tick;
  
  //ClkDivider clkdivider(clk,rst, pixel_tick);
  
  //Asignación de Registros
  always @(posedge clk_in, posedge rst)
  if (rst)//reinicia los valores
    begin
        mod2_reg <= 1'b0;
        v_count_reg <= 0;
        h_count_reg <= 0;
        v_sync_reg <= 1'b0;
        h_sync_reg <= 1'b0;
    end
  else 
    begin //Le asignan el valor
        mod2_reg <= mod2_next;
        v_count_reg <= v_count_next;
        h_count_reg <= h_count_next;
        v_sync_reg <= v_sync_next;
        h_sync_reg <= h_sync_next;  
    end    
  
  //Circuito para generar 25Mhz
  assign mod2_next = ~mod2_reg;
  assign pixel_tick = mod2_reg;
  
  //Estado de señal: termino de recorrido
  //Término de recorrido horizontal (799)
  assign h_end = (h_count_reg ==( HDisplayArea + HFront + HBack + HRetrace -1));
  //Termino de recorrido vertical (524)
  assign v_end = (v_count_reg == ( VDisplayArea + VFront + VBack + VRetrace -1));
  
  //Contador de Pixel Horizontal
  always @* 
    if (pixel_tick)// pulso de 25Mhz que se debe instancear
        if (h_end)// si se termina el recorrido horizontal
            h_count_next = 0; //Se reinicia el contador a 0;
        else 
            h_count_next = h_count_reg + 1; // si no toma el valor actual de registro más uno
    else 
        h_count_next = h_count_reg;// quiere decir que esta en la parte negativa del clk.
        
   //Contador Pixel Vertica
   always  @*
   if( pixel_tick & h_end)
        if (v_end)
            v_count_next = 0 ;
        else
           v_count_next = v_count_reg + 1;
   else
   v_count_next = v_count_reg ;
          
 assign  h_sync_next = ~(h_count_reg >=(HDisplayArea + HBack) && h_count_reg <=(HDisplayArea + HBack + HRetrace-1));
 assign  v_sync_next = ~(v_count_reg >= (VDisplayArea + VBack) && v_count_reg <=(VDisplayArea +VBack + HRetrace-1));
 
 //Encendido y Apagado de Video
 assign video_on = (h_count_reg < HDisplayArea) && (v_count_reg < VDisplayArea);
 //Asignación de salidas
 
 // output
 assign hsync = h_sync_reg;
 assign vsync = v_sync_reg;
 assign pixel_x = h_count_reg;
 assign pixel_y = v_count_reg;
 assign p_tick = pixel_tick;
 
  

endmodule


