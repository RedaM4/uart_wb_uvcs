class c_13_1;
    bit[31:0] addr = 32'h306166f7;
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

program p_13_1;
    c_13_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "xxx0111xzxx11xz1z1z1zzx01xxxz00zxzzxzxzxxzxxzzxxxxxxzxxzxzxzzxzz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
