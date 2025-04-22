class c_22_1;
    bit[31:0] addr = 32'hd3c74bc4;
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

program p_22_1;
    c_22_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "xx001x0z111x1x1x1xxz11z11x00zx0zzzzxzxzxxxzzxxxzzxzxxxxzzzzzxxxz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
