module Report_Path(
    input   logic         clock, 
    input   logic [4:0]   h_ack,
    input   logic [4:0]   free_i,
    input   logic [15:0]  address_i,
    input   logic [31:0]  data_i [4:0]
);

    logic [4:0] free_r, pos;
    int fd, flit_count = 0;
    initial 
        fd = $fopen ("outputs/Path.txt", "a");

    always_ff @(posedge clock ) begin
        free_r <= free_i;
    end

    always_ff @(posedge clock ) begin
        if (h_ack != '0) begin
            flit_count <= 1;
            pos <= free_r ^ free_i;
        end
        else begin
            automatic string port;
            automatic int i;
            if (flit_count == 4) begin
                case (pos)
                    1: begin
                        i = 0;
                        port = "E";
                    end
                    2: begin
                        i = 1;
                        port = "W";
                    end
                    4: begin
                        i = 2;
                        port = "N";
                    end
                    8: begin
                        i = 3;
                        port = "S";
                    end
                    default: begin
                        i = 4;
                        port = "L";
                    end
                endcase

                $fwrite(fd,"PKT %0d %0d %0d %s\n", address_i[15:8], address_i[7:0], data_i[i], port);
                flit_count <= 0;

            end

            if (flit_count != 0)
                flit_count <= flit_count + 1;
        end
    end

endmodule