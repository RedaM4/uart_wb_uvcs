class c_4_1;
    bit[31:0] addr = 32'hb13d18c7;
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

program p_4_1;
    c_4_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "zz1z0z0zx1z1x0z0x0z0zzxx1zzz00x0zxzzzzxzzzxzzxzxzxxxxxxzxxzzxxzx";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
