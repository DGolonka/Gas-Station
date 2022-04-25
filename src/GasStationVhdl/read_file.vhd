library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.type_package.all;

entity read_file is
    port (
        arrayUser : out userArray
    );
end read_file;

architecture rtl of read_file is

    begin
        process is
          variable line_v : line;
          file read_file : text;
          variable temp : integer;
          variable users : usersRecord;
          variable pin : pinArray;
          variable user_array : userArray;
          variable index : integer := 0;
        begin
          file_open(read_file, "source.txt", read_mode);
          while not endfile(read_file) loop
            if index > user_array'length then 
              exit;
            end if;
            readline(read_file, line_v);
            read(line_v, temp);
            users.saldo := temp;
            for i in pin'range loop
                read(line_v, temp);
                pin(i) := temp;
            end loop;
            users.id := pin;
            read(line_v, temp);
            users.cenaza1 := temp;
            user_array(index) := users; 
            index := index + 1;
          end loop;
          file_close(read_file);
          arrayUser <= user_array;
          wait;
        end process;


end architecture;