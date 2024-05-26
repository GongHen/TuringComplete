`timescale 1ns/1ns

//������������ʵ�ֲ�ͬ���㹦��
//ʵ�ָ��ֲ���
module alu (
    input           clk             ,
    input           alu_ena         ,
    input   [2:0]   opcode          ,//״̬��
    input   [7:0]   data            ,
    input   [7:0]   accum           ,
    output              zero        ,    //��һ��data
    output  reg [7:0]   alu_out      
);
    parameter HLT = 3'b000  ,//��ͣ
              SKZ = 3'b001  ,
              ADD = 3'b010  ,
              ANDD = 3'b011 ,
              XORR = 3'b100 ,
              LDA = 3'b101  ,
              STO = 3'b110  ,
              JMP = 3'b111  ;
    
    always @(posedge clk) begin
        if (alu_ena) begin
            casex (opcode)
                HLT: alu_out    <=  accum               ;
                SKZ: alu_out    <=  accum               ;
                ADD: alu_out    <=  data + accum        ;
                ANDD: alu_out   <=  data & accum        ;
                XORR: alu_out   <=  data ^ accum        ;
                LDA: alu_out    <=  data                ;
                STO: alu_out    <=  accum               ;
                JMP: alu_out    <=  accum               ;
                default: alu_out    <=  8'bxxxx_xxxx    ;
            endcase
        end
    end

    assign zero = !accum    ;//��accumΪ0�źţ������1
endmodule