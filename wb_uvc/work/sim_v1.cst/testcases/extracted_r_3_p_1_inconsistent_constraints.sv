class c_3_1;
    bit[31:0] addr = 32'h62a7dd3c;
    randc bit[31:0] address; // rand_mode = ON 

    constraint address_range_this    // (constraint_mode = ON) (../sv/wb_sequence_item.sv:12)
    {
       (address < 64);
    }
    constraint WITH_CONSTRAINT_this    // (constraint_mode = ON) (../sv/wb_master_seqs.sv:61)
    {
       (address == addr);
    }
endclass

program p_3_1;
    c_3_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "xxx00xz11z0010zxxx101xz0x0011xz1zzzzxxxxzzzxzzxzzzxzxzzxzxxxxzzx";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
