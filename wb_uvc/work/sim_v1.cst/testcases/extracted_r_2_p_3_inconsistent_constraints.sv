class c_2_3;
    bit[31:0] dataa = 32'h2afcaa05;
    rand bit[7:0] req_data; // rand_mode = ON 

    constraint WITH_CONSTRAINT_this    // (constraint_mode = ON) (../sv/wb_master_seqs.sv:60)
    {
       (req_data == dataa);
    }
endclass

program p_2_3;
    c_2_3 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "zxzx1000zzz0zzz1x000xx0x1zx00zz1zxzzxxzzzxzzxzxzxxzxzxxzxxxzzzxz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
