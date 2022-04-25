library ieee;
library work;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pin_package.all;
use work.saldo_package.all;
use work.type_package.all;


entity test555 is
port (
    clk : in std_logic;
     up,down,move,action_button : in bit;
	 switches : in std_logic_vector(17 downto 0);
	 reset : in std_logic;
	 red_diod : out std_logic_vector(17 downto 0) := "000000000000000000";
	 green_diod : out std_logic_vector(8 downto 0) := "000000000";
	 seven_segment_display1 : out std_logic_vector(6 downto 0);
	 seven_segment_display2 : out std_logic_vector(6 downto 0);
	 seven_segment_display3 : out std_logic_vector(6 downto 0);
	 seven_segment_display4 : out std_logic_vector(6 downto 0);
	 seven_segment_display5 : out std_logic_vector(6 downto 0);
	 seven_segment_display6 : out std_logic_vector(6 downto 0);
	 seven_segment_display7 : out std_logic_vector(6 downto 0);
	 seven_segment_display8 : out std_logic_vector(6 downto 0)
	 );
	 
end entity;

architecture test of test555 is
	component dekoderBCD is
		port( 
			inputBCD: in std_logic_vector(3 downto 0);
			outputHEX: out std_logic_vector(6 downto 0)
			);
	end component;

	component read_file is
		port (
			arrayUser : out userArray
			);
			end component;

	component write_file is
		port (
			arrayUser : in userArray;
			start_write : in boolean
			);
			end component;


	type State is (ready,choose_fuel,
	choose_refueling_speed, choose_refueling_price, simulate_refueling,
	set_card_number, set_charging_percentage, simulate_charging);

	signal a : boolean := false;
	signal set_blinking_screen : boolean := false;
	signal ST: State;
	signal output_1b : std_logic_vector(3 downto 0);
	signal arrayUserSignalRead : userArray;
	signal arrayUserSignalWrite : userArray;
	signal startSignal : boolean := false;
	signal chargingAmountSignal : chargingAmountArray;
	signal pinArraySignal : pinArray;
	signal refuelSpeedSignal : boolean;
	signal fuelTypeSignal : integer;
	signal refuelPriceSignal : pinArray;

	signal screen1Value : std_logic_vector(3 downto 0) := "0000";
	signal screen2Value : std_logic_vector(3 downto 0) := "0000";
	signal screen3Value : std_logic_vector(3 downto 0) := "0000";
	signal screen4Value : std_logic_vector(3 downto 0) := "0000";
	signal screen5Value : std_logic_vector(3 downto 0) := "0000";
	signal screen6Value : std_logic_vector(3 downto 0) := "0000";
	signal screen7Value : std_logic_vector(3 downto 0) := "0000";
	signal screen8Value : std_logic_vector(3 downto 0) := "0000";
	signal screen_value : screenValue := (screen1Value, screen2Value, 
		screen3Value, screen4Value, screen5Value, screen6Value, screen7Value,screen8Value );
	
	signal screen1Value2 : std_logic_vector(3 downto 0) := "0000";
	signal screen2Value2 : std_logic_vector(3 downto 0) := "0000";
	signal screen3Value2 : std_logic_vector(3 downto 0) := "0000";
	signal screen4Value2 : std_logic_vector(3 downto 0) := "0000";
	signal screen5Value2 : std_logic_vector(3 downto 0) := "0000";
	signal screen6Value2 : std_logic_vector(3 downto 0) := "0000";
	signal screen7Value2 : std_logic_vector(3 downto 0) := "0000";
	signal screen8Value2 : std_logic_vector(3 downto 0) := "0000";
	signal screen_value2 : screenValue := (screen1Value2, screen2Value2, 
		screen3Value2, screen4Value2, screen5Value2, screen6Value2, screen7Value2,screen8Value2 );

	signal screen1Value3 : std_logic_vector(3 downto 0) := "0000";
	signal screen2Value3 : std_logic_vector(3 downto 0) := "0000";
	signal screen3Value3 : std_logic_vector(3 downto 0) := "0000";
	signal screen4Value3 : std_logic_vector(3 downto 0) := "0000";
	signal screen5Value3 : std_logic_vector(3 downto 0) := "0000";
	signal screen6Value3 : std_logic_vector(3 downto 0) := "0000";
	signal screen7Value3 : std_logic_vector(3 downto 0) := "0000";
	signal screen8Value3 : std_logic_vector(3 downto 0) := "0000";
	signal screen_value3 : screenValue := (screen1Value3, screen2Value3, 
		screen3Value3, screen4Value3, screen5Value3, screen6Value3, screen7Value3,screen8Value3 );	
	
	signal startSignalDiod3 : boolean := false;

    signal diod : std_logic_vector(8 downto 0) := "000000000";
    signal diod2 : std_logic_vector(8 downto 0) := "000000000";

	begin 
		
		screen1 : dekoderBCD port map ( screen_value3(0), seven_segment_display1);
		screen2 : dekoderBCD port map ( screen_value3(1), seven_segment_display2);
		screen3 : dekoderBCD port map ( screen_value3(2), seven_segment_display3);
		screen4 : dekoderBCD port map ( screen_value3(3), seven_segment_display4);
		screen5 : dekoderBCD port map ( screen_value(4), seven_segment_display5);
		screen6 : dekoderBCD port map ( screen_value(5), seven_segment_display6);
		screen7 : dekoderBCD port map ( screen_value(6), seven_segment_display7);
		screen8 : dekoderBCD port map ( screen_value(7), seven_segment_display8);

		getUser : read_file port map (arrayUserSignalRead);
		setUser : write_file port map (arrayUserSignalWrite,startSignal);

		process(up,down,move,action_button,reset)
		
		variable userFinalArray: userArray := arrayUserSignalRead;
		
		variable flag : bit :=  '0';
		variable flag2 : bit :=  '0';
		variable userIndex : integer := -1;
		variable pin : pinArray := (0,0,0,0);
		variable saldoArray : pinArray := (0,0,0,0);
		variable chargingAmount: chargingAmountArray := (0,0,0);
		variable currentScreenPosition : integer := 0;
		variable outputSize : std_logic_vector(3 downto 0);
		variable fuelType : integer := 0;
		variable chargingPrice : integer := 0;
		variable refuelingSpeed : boolean := false;
		variable refuelingPrice : pinArray:= (0,0,0,0);
		variable fuelPrice : integer := 5;
		variable fuelAmountInLiters: pinArray := (0,0,0,0);

		begin 
		userFinalArray := arrayUserSignalRead;
		chargingAmountSignal <= chargingAmount;
		pinArraySignal <= pin;
		refuelPriceSignal <= refuelingPrice;

		if reset = '1' then
			ST <= ready;
			red_diod <= printError(0);
			else
				case ST is
					when ready => 
						startSignal <= false;
						diod <= "111111111";
						if action_button = '1' then
							ST <= choose_fuel;
							diod <= "000000000";
							else
								ST <= ready;
						end if;
						
					when choose_fuel =>
						if action_button = '1' then
							if switches(17 downto 1) = "00000000000000000" then
								ST <= choose_fuel;
								red_diod <= printError(4);
								elsif switches (17 downto 1) = "00000000000000001" then
									ST <= set_card_number;
									red_diod <= printError(0);
								else
									ST <= choose_refueling_speed;
									red_diod <= printError(0);
									if switches(17 downto 1) = "10000000000000000" then
										fuelType := 0;
										fuelPrice := 5;
										end if;
									if switches(17 downto 1) = "01000000000000000" then
										fuelType := 1;
										fuelPrice := 5;
										end if;
									if switches(17 downto 1) = "00100000000000000" then
										fuelType := 2;
										fuelPrice := 6;
										end if;
									if switches(17 downto 1) = "00010000000000000" then
										fuelType := 3;
										fuelPrice := 4;
									end if;
									if switches(17 downto 1) = "00001000000000000" then
										fuelType := 4;
										fuelPrice := 6;
									end if;
									fuelTypeSignal <= fuelType;

							end if;
						else 
							ST <= choose_fuel;
						end if;
						
					when set_card_number =>

						set_blinking_screen <= false;
							if flag = '0' then 
								set_blinking_screen <= true;
								flag :=  '1';
							end if;
							if action_button = '1' then
								-- sprawdzanie pinu podanego przez usera
								report integer'image(pin(0))  & " " & integer'image(pin(1)) & " " &integer'image(pin(2)) & " " & integer'image(pin(3));
								if checkPin(pin,userFinalArray) then
									ST <= set_charging_percentage;
									userIndex := getUserId(pin,userFinalArray);
									red_diod <= printError(0);
									currentScreenPosition := 2;
								else 
									flag := '0';
									ST <= set_card_number;
									red_diod <= printError(1);
									currentScreenPosition := 0;
								end if;
							end if;

							if currentScreenPosition = 4 then
								currentScreenPosition := 0;
								elsif currentScreenPosition = -1 then
									currentScreenPosition := 3;
							end if;

							-- drugi od prawej strony - przesunięcie
							if move = '1' then
								set_blinking_screen <= false;
								currentScreenPosition := currentScreenPosition + 1;
								-- trzeci od prawej strony - inkrementacja
							elsif down = '1' then
								set_blinking_screen <= false;
								pin(currentScreenPosition) := pin(currentScreenPosition) - 1;
								if pin(currentScreenPosition) = -1 then 
									pin(currentScreenPosition) := 9;
								end if;
								screen_value(currentScreenPosition) <=
										std_logic_vector(to_signed(pin(currentScreenPosition),outputSize'length));

								-- lewy - przesunięcie w 
							elsif up = '1' then
								set_blinking_screen <= false;
								pin(currentScreenPosition) := pin(currentScreenPosition) + 1;
								if pin(currentScreenPosition) = 10 then 
									pin(currentScreenPosition) := 0;
								end if;
								--report "Entity: data_in=" & integer'image(pin(currentScreenPosition));
								--report "Entity: data_in=" & to_hstring(std_logic_vector(to_signed(pin(currentScreenPosition),outputSize'length))) & "h";
									screen_value(currentScreenPosition) <= std_logic_vector(to_signed(pin(currentScreenPosition),outputSize'length));
							end if;
						
					when set_charging_percentage =>

						set_blinking_screen <= false;
							if flag2 = '0' then 
								set_blinking_screen <= true;
								flag2 :=  '1';
							end if;

						if action_button = '1' then
							chargingPrice := userFinalArray(userIndex).cenaza1 * changeChargingArrayToInt(chargingAmount);
							if changeChargingArrayToInt(chargingAmount) > 0 and 
							changeChargingArrayToInt(chargingAmount) <= 100 and checkSaldo(userIndex,userFinalArray,chargingPrice) then 
									ST <= simulate_charging;
									red_diod <= printError(0);
								else
									red_diod <= printError(2);
									ST <= set_charging_percentage;
							end if;
						end if;

						if currentScreenPosition = 3 then
							currentScreenPosition := 0;
							elsif currentScreenPosition = -1 then
								currentScreenPosition := 2;
						end if;

						-- drugi od prawej strony - przesunięcie
						if move = '1' then
							set_blinking_screen <= false;
							currentScreenPosition := currentScreenPosition - 1;
							--trzeci od prawej strony - inkrementacja
						elsif down = '1' then
							set_blinking_screen <= false;
							chargingAmount(currentScreenPosition) := chargingAmount(currentScreenPosition) - 1;
							if chargingAmount(currentScreenPosition) = -1 then 
								chargingAmount(currentScreenPosition) := 9;
							end if;
							screen_value(currentScreenPosition) <=
								std_logic_vector(to_signed(chargingAmount(currentScreenPosition),outputSize'length));
							
						--lewy - przesunięcie w 
						elsif up = '1' then
							set_blinking_screen <= false;
							chargingAmount(currentScreenPosition) := chargingAmount(currentScreenPosition) + 1;
							if chargingAmount(currentScreenPosition) = 10 then 
							chargingAmount(currentScreenPosition) := 0;
								end if;
								screen_value(currentScreenPosition) <=
									std_logic_vector(to_signed(chargingAmount(currentScreenPosition),outputSize'length));
						end if;

					when simulate_charging =>

						-- wywołanie metody rozpoczynającej ładowanie
						a <= true;
						if diod2 = "111111111" then
							setSaldo(userIndex,userFinalArray,
							changeChargingArrayToInt(chargingAmount)*userFinalArray(userIndex).cenaza1);
							a <= false;
							arrayUserSignalWrite <= userFinalArray;
							startSignal <= true;
							report "FFFFFFFFFFFFFFFFFFFFFF" & integer'image(userFinalArray(0).saldo);
							report "FFFFFFFFFFFFFFFFFFFFFF" & integer'image(userFinalArray(1).saldo);
							report "FFFFFFFFFFFFFFFFFFFFFF" & integer'image(userFinalArray(2).saldo);
							report "FFFFFFFFFFFFFFFFFFFFFF" & integer'image(userFinalArray(3).saldo);
						end if;
						-- zakończenie ładowania
						if action_button = '1' and diod2 = "111111111" then
							ST <= ready;
						end if;

					when choose_refueling_speed =>

						if action_button = '1' then

							if switches(0) = '0' then
								refuelingSpeed := false;
								refuelSpeedSignal <= refuelingSpeed;
								else
								refuelingSpeed:= true;
								refuelSpeedSignal <= refuelingSpeed;
							end if;
							ST <= choose_refueling_price;

						end if;

					when choose_refueling_price => 

					set_blinking_screen <= false;
							if flag = '0' then 
								set_blinking_screen <= true;
								flag :=  '1';
							end if;

					if action_button = '1' then
						if changeIntArrayToInt(refuelingPrice) = 0 then
							ST <= choose_refueling_price;
							red_diod <= printError(1);
							currentScreenPosition := 0;
							flag := '1';
							else 
							ST <= simulate_refueling;
							red_diod <= printError(0);
						end if;
					end if;

						if currentScreenPosition = 4 then
							currentScreenPosition := 0;
							elsif currentScreenPosition = -1 then
								currentScreenPosition := 3;
						end if;

						-- drugi od prawej strony - przesunięcie
						if move = '1' then
							set_blinking_screen <= false;
							currentScreenPosition := currentScreenPosition + 1;
							-- trzeci od prawej strony - inkrementacja
						elsif down = '1' then
							set_blinking_screen <= false;
							refuelingPrice(currentScreenPosition) := refuelingPrice(currentScreenPosition) - 1;
							if refuelingPrice(currentScreenPosition) = -1 then 
								refuelingPrice(currentScreenPosition) := 9;
							end if;
							screen_value(currentScreenPosition) <=
									std_logic_vector(to_signed(refuelingPrice(currentScreenPosition),outputSize'length));

							-- lewy - przesunięcie w 
						elsif up = '1' then
							set_blinking_screen <= false;
							refuelingPrice(currentScreenPosition) := refuelingPrice(currentScreenPosition) + 1;
							if refuelingPrice(currentScreenPosition) = 10 then 
								refuelingPrice(currentScreenPosition) := 0;
							end if;
								screen_value(currentScreenPosition) <= std_logic_vector(to_signed(refuelingPrice(currentScreenPosition),outputSize'length));
						end if;
				
					when simulate_refueling =>

					fuelAmountInLiters := convertIntegerToIntegerArray(changeIntArrayToInt(refuelingPrice)/fuelPrice);

						screen_value(0) <= std_logic_vector(to_signed(fuelAmountInLiters(0),outputSize'length));
						screen_value(1) <= std_logic_vector(to_signed(fuelAmountInLiters(1),outputSize'length));
						screen_value(2) <= std_logic_vector(to_signed(fuelAmountInLiters(2),outputSize'length));
						screen_value(3) <= std_logic_vector(to_signed(fuelAmountInLiters(3),outputSize'length));
						
						screen_value(4) <= std_logic_vector(to_signed(fuelType,outputSize'length));
						
						-- wywołanie metody rozpoczynającej tankowanie
						-- po zakończonym tankowaniu powrot do stanu ready
						a <= true;
						if diod2 = "111111111" then
							a <= false;
						end if;
						-- zakończenie ładowania
						if action_button = '1' and diod2 = "111111111" then
							ST <= ready;
						end if;
				end case;
			end if;
		end process;
	
		process
			variable index : integer := 0;
			begin
				wait until a = true;
				if a then
				for	i in 0 to 9 loop
				case i is
				
					when 0 =>
					diod2 <= "000000000";
					when 1 =>
					diod2 <= "100000000";
					when 2 =>
					diod2 <= "110000000";
					when 3 =>
					diod2 <= "111000000";
					when 4 =>
					diod2 <= "111100000";
					when 5 =>
					diod2 <= "111110000";
					when 6 =>
					diod2 <= "111111000";
					when 7 =>
					diod2 <= "111111100";
					when 8 =>
					diod2 <= "111111110";
					when 9 =>
					diod2 <= "111111111";
				
				end case;
				if refuelSpeedSignal then
					wait for 20 ps;
					else 
					wait for 40 ps;
					end if;
				end loop;
				end if;
		end process;
		
		process(up,down,move,action_button,reset, ST, clk)
            begin
            if a then
                green_diod <= diod2;
            else 
                green_diod <= diod;
            end if;
            if set_blinking_screen then
                for i in 0 to 3 loop
                    screen_value3(i) <= screen_value2(i);
                    end loop;
            else 
                for i in 0 to 3 loop
                    screen_value3(i) <= screen_value(i);
                end loop;
                end if;
        end process;

		process
			begin
				wait until set_blinking_screen = true;
				while set_blinking_screen loop
					for i in 0 to 3 loop
					if screen_value2(i) = "0000" then
						screen_value2(i) <= "1111";
					else 
						screen_value2(i) <= "0000";	
					end if;	
					end loop;
					wait for 40 ps;
				end loop;
				for i in 0 to 3 loop
					screen_value2(i) <= "0000";
				end loop;
		end process;
end test;