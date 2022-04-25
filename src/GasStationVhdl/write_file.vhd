library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.type_package.all;

entity write_file is
    port (
        arrayUser : in userArray;
        start_write : in boolean
    );
end write_file;

architecture rtl of write_file is
    begin
        process is
          variable line_v : line;
          file write_file : text;
          variable temp : integer;
          variable pin : pinArray;
          variable space : character := ' ';
          variable user_array : userArray;
          
        begin
          wait until start_write = true;
          user_array := arrayUser;
          file_open(write_file, "source.txt", write_mode);
          for j in user_array'range loop
            temp := user_array(j).saldo;
            write (line_v, temp);
            write (line_v, space);
            for i in user_array(j).id'range loop
                temp := user_array(j).id(i);
                write (line_v, temp);
                write (line_v, space);
            end loop;
            temp := user_array(j).cenaza1;
            write (line_v, temp);
            write (line_v, space);
            writeline(write_file, line_v);
          end loop;
          file_close(write_file);
        end process;

end architecture;