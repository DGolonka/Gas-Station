library ieee;
use ieee.std_logic_1164.all;

package type_package is
    type pinArray is array (0 to 3) of integer;
	type screenValue is array (0 to 7) of std_logic_vector(3 downto 0);

	type usersRecord is record
	id: pinArray;
	saldo: integer;
	-- cena za 1%
	cenaza1: integer;
	end record;

	type userArray is array (0 to 4) of usersRecord;
    type chargingAmountArray is array (0 to 2) of integer;
end package;
