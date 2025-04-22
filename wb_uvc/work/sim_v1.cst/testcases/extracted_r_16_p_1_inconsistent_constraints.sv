class c_16_1;
    bit[31:0] addr = 32'h98527c4;
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

program p_16_1;
    c_16_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "1101xzzxx0xxxxz11000010xz101z1x1zzxxxxzzzxxxzzxzzxxxxxxxzzxzxxxx";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
