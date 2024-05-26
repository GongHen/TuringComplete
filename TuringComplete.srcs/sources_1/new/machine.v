`timescale 1ns/1ns

// ��״̬����CPU�Ŀ��ƺ��ģ����ڲ���һϵ�п����źš�
// ָ��������8��ʱ��������ɣ�ÿ��ʱ�����ڶ�Ҫ��ɹ̶��Ĳ�����
// ��1����0��ʱ�ӣ�CPU״̬�����������rd��load_ir Ϊ�ߵ�ƽ������Ϊ�͵�ƽ��ָ��Ĵ����Ĵ���ROM�����ĸ�8λָ����롣
// ��2����1��ʱ�ӣ�����һ��ʱ�����ֻ��inc_pc��0��Ϊ1����PC��1��ROM������8λָ����룬ָ��Ĵ����Ĵ��8λָ����롣
// ��3����2��ʱ�ӣ��ղ�����
// ��4����3��ʱ�ӣ�PC��1��ָ����һ��ָ�
// ������ΪHLT������ź�HLTΪ�ߡ�
// ��������ΪHLT����PC��1�⣬������������Ϊ0.
// ��5����4��ʱ�ӣ�������
// ������ΪAND��ADD��XOR��LDA����ȡ��Ӧ��ַ�����ݣ�
// ������ΪJMP����Ŀ�ĵ�ַ�͸������������
// ������ΪSTO������ۼ������ݡ�
// ��6����5��ʱ�ӣ���������ΪANDD��ADD����XORR�����������������Ӧ�ļ��㣻
// ������ΪLDA���Ͱ�����ͨ�������������͸��ۼ�����
// ������ΪSKZ�����ж��ۼ�����ֵ�Ƿ�Ϊ0����Ϊ0��PC��1�����򱣳�ԭֵ��
// ������ΪJMP������Ŀ�ĵ�ַ��
// ������ΪSTO��������д���ַ����
// (7)��6��ʱ�ӣ��ղ�����
// (8)��7��ʱ�ӣ���������ΪSKZ���ۼ���Ϊ0����PCֵ�ټ�1������һ��ָ�����PC�ޱ仯��


module machine (
    input               clk         ,
    input               ena         ,//contr_ena��machine_ctrlʹ��
    input               zero        ,
    input   [2:0]       opcode      ,
    output  reg         inc_pc      ,//counter��ʱ���źţ�loadpcΪ0ʱ��pcaddr+1
    output  reg         load_acc    ,//�����accum���洢����
    output  reg         load_pc     ,//�����counter����ַ����,
    output  reg         rd          ,
    output  reg         wr          ,
    output  reg         load_ir     ,//register ena�ź�
    output  reg         data_ctrl_ena   ,
    output  reg         halt         //��ͣ         
);

    reg [2:0] state         ;

    parameter 
            HLT = 3'b000  ,//��ָͣ���������accum���䵽�������һ��ָ�����ڣ�8��ʱ������
            SKZ = 3'b001  ,//����ָ�Ҳ�ǽ����������䵽���
            ADD = 3'b010  ,//
            ANDD = 3'b011 ,//
            XORR = 3'b100 ,//
            LDA = 3'b101  ,//����ָ���data���䵽�����������
            STO = 3'b110  ,//�洢ָ���accum���䵽�����д����
            JMP = 3'b111  ;//��תָ���accum���䵽���

    always @(posedge clk ) begin
        if (!ena) begin
            state <= 3'b000     ;
            {inc_pc,load_acc,load_pc,rd} <= 4'b0000     ;
            {wr,load_ir,data_ctrl_ena,halt} <= 4'b0000  ;
        end else begin
            clt_cycle   ;
        end
    end
    
    task clt_cycle;
        begin
            casex (state)
                //rd,load_irΪ�ߵ�ƽ��register��������rom��ȡ����
                3'b000: //load high 8bits in struction
                        begin
                            {inc_pc,load_acc,load_pc,rd} <= 4'b0001     ;
                            {wr,load_ir,data_ctrl_ena,halt} <= 4'b0100  ;
                            state <= 3'b001     ;
                        end
                //������һ�֣�inc_pcΪ�ߵ�ƽ,counter������pc_addr + 1
                3'b001: //pc increased by one then load low 8bits instruction
                        begin
                            {inc_pc,load_acc,load_pc,rd} <= 4'b1001     ;
                            {wr,load_ir,data_ctrl_ena,halt} <= 4'b0100  ;
                            state <= 3'b010     ;
                        end
                //�ղ�������0
                3'b010: //idle
                        begin
                            {inc_pc,load_acc,load_pc,rd} <= 4'b0000     ;
                            {wr,load_ir,data_ctrl_ena,halt} <= 4'b0000  ;
                            state <= 3'b011     ;
                        end
                //HLT״̬��inc_pcΪ�ߵ�ƽ,counter������pc_addr + 1�����halt��ͣ�źţ�
                //��HLT��inc_pcΪ�ߵ�ƽ,counter������pc_addr + 1��
                3'b011: 
                        begin
                            if (opcode == HLT) begin
                                {inc_pc,load_acc,load_pc,rd} <= 4'b1000     ;
                                {wr,load_ir,data_ctrl_ena,halt} <= 4'b0001  ;
                            end else begin
                                {inc_pc,load_acc,load_pc,rd} <= 4'b1000     ;
                                {wr,load_ir,data_ctrl_ena,halt} <= 4'b0000  ;
                            end
                            state <= 3'b100     ;
                        end
                // ������ΪAND��ADD��XOR��LDA����ȡ��Ӧ��ַ�����ݣ�
                // ������ΪJMP����Ŀ�ĵ�ַ�͸������������
                // ������ΪSTO������ۼ������ݡ�
                3'b100: //ȡ��������
                        begin
                            if (opcode == JMP) begin
                                {inc_pc,load_acc,load_pc,rd} <= 4'b0010     ;//load_pcΪ1��inc����pc��Ϊ1��ʱ�Ӳ�����û����
                                {wr,load_ir,data_ctrl_ena,halt} <= 4'b0000  ;
                            end else if (opcode == ADD || opcode == ANDD ||opcode ==XORR ||opcode == LDA) begin
                                {inc_pc,load_acc,load_pc,rd} <= 4'b0001     ;//��ȡ��ǰ��ַ����
                                {wr,load_ir,data_ctrl_ena,halt} <= 4'b0000  ;
                            end else if (opcode == STO) begin
                                {inc_pc,load_acc,load_pc,rd} <= 4'b0000     ;//ʹ��data����ctrlģ�飬data=alu����out
                                {wr,load_ir,data_ctrl_ena,halt} <= 4'b0010  ;
                            end else begin
                                {inc_pc,load_acc,load_pc,rd} <= 4'b0000     ;
                                {wr,load_ir,data_ctrl_ena,halt} <= 4'b0000  ;
                            end    
                            state <= 3'b101    ;      
                        end
                3'b101: //operation
                        begin
                            if (opcode == ADD || opcode == ANDD ||opcode ==XORR ||opcode == LDA) begin
                                {inc_pc,load_acc,load_pc,rd} <= 4'b0101     ;
                                {wr,load_ir,data_ctrl_ena,halt} <= 4'b0000  ;
                            end else if (opcode == SKZ && zero == 1) begin
                                {inc_pc,load_acc,load_pc,rd} <= 4'b1000     ;//pc����addr+1
                                {wr,load_ir,data_ctrl_ena,halt} <= 4'b0000  ;
                            end else if (opcode == JMP) begin
                                {inc_pc,load_acc,load_pc,rd} <= 4'b1010     ;//jump��loadΪ1��pc_addr = ir_addr
                                {wr,load_ir,data_ctrl_ena,halt} <= 4'b0000  ;
                            end else if (opcode == STO) begin
                                {inc_pc,load_acc,load_pc,rd} <= 4'b0000     ;//wr = 1��ʹ��ram��д����data,д��ram��
                                {wr,load_ir,data_ctrl_ena,halt} <= 4'b1010  ;//ʹ��data����ctrlģ�飬data=alu����out
                            end else begin                                    
                                {inc_pc,load_acc,load_pc,rd} <= 4'b0000     ;
                                {wr,load_ir,data_ctrl_ena,halt} <= 4'b0000  ;
                            end   
                            state <= 3'b110    ;       
                        end
                3'b110: //operation
                        begin
                            if (opcode == STO) begin//�����STO����ô��Ҫʹ���ݿ���ģ��enable��data=alu����out
                                {inc_pc,load_acc,load_pc,rd} <= 4'b0000     ;
                                {wr,load_ir,data_ctrl_ena,halt} <= 4'b0010  ;
                            end else if (opcode == ADD || opcode == ANDD ||opcode ==XORR ||opcode == LDA) begin
                                {inc_pc,load_acc,load_pc,rd} <= 4'b0001     ;
                                {wr,load_ir,data_ctrl_ena,halt} <= 4'b0000  ;
                            end else begin
                                {inc_pc,load_acc,load_pc,rd} <= 4'b0000     ;
                                {wr,load_ir,data_ctrl_ena,halt} <= 4'b0000  ;
                            end
                            state <= 3'b111    ;       
                        end
                3'b111: //operation
                        begin
                            if (opcode == SKZ && zero == 1) begin
                                {inc_pc,load_acc,load_pc,rd} <= 4'b1000     ;
                                {wr,load_ir,data_ctrl_ena,halt} <= 4'b0000  ;
                            end else begin
                                {inc_pc,load_acc,load_pc,rd} <= 4'b0000     ;
                                {wr,load_ir,data_ctrl_ena,halt} <= 4'b0000  ;
                            end 
                            state <= 3'b000    ;      
                        end
                default:
                        begin
                            {inc_pc,load_acc,load_pc,rd} <= 4'b0000     ;
                            {wr,load_ir,data_ctrl_ena,halt} <= 4'b0000  ;
                            state <= 3'b000     ;
                        end 
            endcase
        end
    endtask
endmodule