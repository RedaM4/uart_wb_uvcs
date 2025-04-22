class c_25_1;
    bit[31:0] addr = 32'h571cf384;
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

program p_25_1;
    c_25_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "z0100z1z0z0z1x001x11xzzzz11zx1x1xzzzzxzzzzxzzxzzxzxxzxxzzxzzxxzz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
