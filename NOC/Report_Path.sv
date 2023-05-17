module Report_Path(
    input   logic         clock, 
    input   logic [4:0]   h_ack,
    input   logic [4:0]   free_i,
    input   logic [15:0]  address_i,
    input   logic [31:0]  data_i [4:0],
    input   logic [4:0]   credit
);

    logic [4:0] free_r;
    int fd;
    int flit_count_N = 0;
    int flit_count_S = 0;
    int flit_count_E = 0;
    int flit_count_W = 0;
    int flit_count_L = 0;
    initial 
        fd = $fopen ("outputs/Path.txt", "a");

    always_ff @(posedge clock ) begin
        free_r <= free_i;
    end

    always_ff @(posedge clock ) begin
        automatic logic [4:0] pos;
        if (h_ack != '0) begin
            pos = free_r ^ free_i;
            case (pos)
                    1: begin
                        flit_count_E <= 1; 
                    end
                    2: begin
                        flit_count_W <= 1; 
                    end
                    4: begin
                        flit_count_N <= 1; 
                    end
                    8: begin
                        flit_count_S <= 1; 
                    end
                    default: begin
                        flit_count_L <= 1; 
                    end
                endcase
        end
        else begin
            automatic int i;

            if (flit_count_E == 4) begin
                i = 0;
                $fwrite(fd,"PKT %0d %0d %0d %s\n", address_i[15:8], address_i[7:0], data_i[i], "E");
                flit_count_E <= 0;
            end

            if (flit_count_W == 4) begin
                i = 1;
                $fwrite(fd,"PKT %0d %0d %0d %s\n", address_i[15:8], address_i[7:0], data_i[i], "W");
                flit_count_W <= 0;
            end

            if (flit_count_N == 4) begin
                i = 2;
                $fwrite(fd,"PKT %0d %0d %0d %s\n", address_i[15:8], address_i[7:0], data_i[i], "N");
                flit_count_N <= 0;
            end

            if (flit_count_S == 4) begin
                i = 3;
                $fwrite(fd,"PKT %0d %0d %0d %s\n", address_i[15:8], address_i[7:0], data_i[i], "S");
                flit_count_S <= 0;
            end

            if (flit_count_L == 4) begin
                i = 4;
                $fwrite(fd,"PKT %0d %0d %0d %s\n", address_i[15:8], address_i[7:0], data_i[i], "L");
                flit_count_L <= 0;
            end

            

            if (flit_count_E != 0 && credit[0] == 1)
                flit_count_E <= flit_count_E + 1;
            
            if (flit_count_W != 0 && credit[1] == 1)
                flit_count_W <= flit_count_W + 1;

            if (flit_count_N != 0 && credit[2] == 1)
                flit_count_N <= flit_count_N + 1;
            
            if (flit_count_S != 0 && credit[3] == 1)
                flit_count_S <= flit_count_S + 1;
            
            if (flit_count_L != 0 && credit[4] == 1)
                flit_count_L <= flit_count_L + 1;
        end
    end

endmodule