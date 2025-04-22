class c_10_1;
    bit[31:0] addr = 32'h85de7407;
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

program p_10_1;
    c_10_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "x0x0100xzxx0z0xz000x11zz100z101xxxxxxzzzxxzzxxxzzxzzzxxzxxzzzxxx";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
