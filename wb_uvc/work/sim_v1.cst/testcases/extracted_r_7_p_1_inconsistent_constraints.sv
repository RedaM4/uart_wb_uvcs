class c_7_1;
    bit[31:0] addr = 32'h9f7d78c1;
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

program p_7_1;
    c_7_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "0x1xxxxzz0xx0zx0z1x10xxx1000z111xzzxxxzzxzxxxxxzxxxzzzxxzxxzxxzz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
