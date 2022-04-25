library ieee;
library work;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.type_package.all;

package saldo_package is
	
    function checkSaldo(index: integer; user: userArray; saldo : integer) return boolean;
    procedure setSaldo (index: integer; variable user: inout userArray; saldo : integer);
	function changeChargingArrayToInt(arr : chargingAmountArray) return integer;
    function changeIntArrayToInt(arr : pinArray) return integer;
	function printError (errorType : integer) return std_logic_vector;
	function convertIntegerToIntegerArray(arg : integer) return pinArray;
end package;

package body saldo_package is


	function checkSaldo(index: integer; user: userArray; saldo : integer) return boolean is 
		begin 
			if index = -1 then
		return false;
			end if;
			if user(index).saldo >= saldo then
				return true;
			else 
				return false;
			end if;                                        
	end function;

	procedure setSaldo (index: integer; variable user: inout userArray; saldo : integer) is 
		begin 

		if index = -1 then
		elsif checkSaldo(index,user,saldo) = true then
			user(index).saldo := user(index).saldo - saldo;
			report "Wynik" & integer'image(user(index).saldo);
		end if;
	end procedure;

	function changeIntArrayToInt(arr : pinArray) return integer is
		variable sum : integer := 0;
		variable weight : integer := 1;
	begin
		for i in arr'length - 1 downto 0 loop
			sum := sum + arr(i) * weight;
			weight := weight * 10;
		end loop;
		report "Sprawdzenie:" & integer'image(sum);
		return sum;
	end function;

	function changeChargingArrayToInt(arr : chargingAmountArray) return integer is
		variable sum : integer := 0;
		variable weight : integer := 1;
	begin
		for i in arr'length - 1 downto 0 loop
			sum := sum + arr(i) * weight;
			weight := weight * 10;
		end loop;
		report "Sprawdzenie:" & integer'image(sum);
		return sum;
	end function;

	function convertIntegerToIntegerArray(arg : integer) return pinArray is 
	variable fuelAmountInLiters: pinArray := (0,0,0,0);
	variable temp : integer := arg;
	variable weight : integer := 1000;
		begin
			for i in fuelAmountInLiters'range loop
				fuelAmountInLiters(i) := temp/weight;
				temp := temp - fuelAmountInLiters(i) * weight;
				weight := weight/10;
			end loop;
			return fuelAmountInLiters;
	end function;

	function printError (errorType : integer) return std_logic_vector is
		variable test : std_logic_vector(17 downto 0);
		begin
		if errorType = 0 then 
		-- brak błędu
			test:= "000000000000000000";
		end if;
		if errorType = 1 then 
		-- błąd 0 
		-- kwota ładowania/tankowania nie może wynosić 0
			test:= "000000000000000001";
		end if;
		
		if errorType = 2 then 
		-- błąd 1 
		-- błędne dane albo użytkownik nie posiada wystarczających środków na koncie
			test := "000000000000000010";
		end if;
		
		if errorType = 3 then 
		-- błąd 2 
		-- wartość nie może wynosić 0
			test := "000000000000000011";
		end if;
		
		if errorType = 4 then 
		-- błąd 3 
		-- niewystarczające środki na koncie
			test := "000000000000000100";
		end if;
		if errorType = 5 then 
		-- błąd 4 
		-- nie wybrano żadnego przełącznika
			test := "000000000000000101";
		end if;
	
		return test;
		
	end function;
	
end package body;