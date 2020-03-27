`timescale 1ns / 1ps

// Модуль main:
 module main(
    input       [9:0] sw,       // 10-ти разрядный вход
    output      [9:0] led,      // Выход LED индикаторов
    output reg  [6:0] hex,      // Выход на 7-ми сегментный индикатор
    output      [7:0] hex_on    // Выход для управления активными индикаторами
    );
    
    ///////////////////////////////////////////// ОБЪЯВЛЕНИЯ //////////////////////////////////////
    
    // Объявляем цепи DC1 DC2 и DC Switcher:
    wire [3:0] dc1;
    wire [3:0] dc2;
    wire [1:0] dc_switcher;
    
    // Объявляем выходы DC1, DC2 и Function:
    reg [3:0] dc1_output;
    reg [3:0] dc2_output;
    reg function_output;
    
    // Объявляем вход DC-DEC:
    reg [3:0] dc_dec;
    
    ///////////////////////////////////////////// ИНИЦИАЛИЗАЦИЯ ///////////////////////////////////
    
    // Включаем один индикатор:
    assign hex_on = 8'b11111110;
    
    // Подсвечиваем включенные переключатели:
    assign led = sw;
    
    // Разветвляем sw на DC1, DC2 и DC switcher:
    assign dc1          = sw[3:0];
    assign dc2          = sw[7:4];
    assign dc_switcher  = sw[9:8];
    
    ///////////////////////////////////////////// ИСПОЛНЯЕМЫЙ КОД /////////////////////////////////
    
    // DC1:
    always @(*) begin
        dc1_output = 4'b0;
        if ((dc1[3] + dc1[2]) == 2'b10)
            dc1_output = dc1_output + 1'b1;
        if ((dc1[2] + dc1[1]) == 2'b10)
            dc1_output = dc1_output + 1'b1;
        if ((dc1[1] + dc1[0]) == 2'b10)
            dc1_output = dc1_output + 1'b1;
    end
    
    // DC2:
    always @(*) begin
        dc2_output = dc2 & 4'b1101;
    end
    
    // Function:
    always @(*) begin
        function_output = (sw[0] & sw[1]) ^ (sw[2] | sw[3]);
    end
    
    // DC switcher:
    always @(*) begin
        case (dc_switcher)
            2'b00 : dc_dec = dc1_output;
            2'b01 : dc_dec = dc2_output;
            2'b10 : dc_dec = function_output;
            2'b11 : dc_dec = dc1;
        endcase
    end
    
    // DC-DEC:
    always @(*) begin
        case (dc_dec)
            4'h0 : hex = 7'b1000000; 
            4'h1 : hex = 7'b1111001; 
            4'h2 : hex = 7'b0100100;
            4'h3 : hex = 7'b0110000;
            4'h4 : hex = 7'b0011001;
            4'h5 : hex = 7'b0010010;
            4'h6 : hex = 7'b0000010;
            4'h7 : hex = 7'b1111000;
            4'h8 : hex = 7'b0000000;
            4'h9 : hex = 7'b0010000;
            4'hA : hex = 7'b0001000;
            4'hB : hex = 7'b0000011;
            4'hC : hex = 7'b1000110;
            4'hD : hex = 7'b0100001;
            4'hE : hex = 7'b0000110;
            4'hF : hex = 7'b0001110;
        endcase
    end
    
endmodule
