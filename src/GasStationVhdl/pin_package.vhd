library ieee;
library work;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.type_package.all;

package pin_package is

    function checkPin (pin: pinArray; user: userArray) return boolean;
    function getUserId (pin: pinArray; user: userArray ) return integer;
end package;

package body pin_package is
    function checkPin (pin: pinArray; user: userArray) return boolean is
        begin
            report "pin I" & integer'image(pin(0));
            report "pin I" & integer'image(pin(1));
            report "pin I" & integer'image(pin(2));
            report "pin I" & integer'image(pin(3));
        for i in user'range loop
            report "User saldo 1 " & integer'image(user(i).id(0));  
            report "User saldo 2" & integer'image(user(i).id(1));  
            report "User saldo 3" & integer'image(user(i).id(2));  
            report "User saldo 4" & integer'image(user(i).id(3));  
            if user(i).id(0) = pin(0) and user(i).id(1) = pin(1) 
                and user(i).id(2) = pin(2) and user(i).id(3) = pin(3) then
                return true;
            end if;
        end loop;
        return false;
    end function;
    
    function getUserId (pin: pinArray; user: userArray ) return integer is 
        begin 
        if checkPin(pin,user) = true then
            for i in user'range loop
                if user(i).id(0) = pin(0) and user(i).id(1) = pin(1) 
                    and user(i).id(2) = pin(2) and user(i).id(3) = pin(3) then
                    return i;
                end if;
            end loop;
        end if;
        return -1;
    end function;
end package body;