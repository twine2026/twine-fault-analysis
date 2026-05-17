LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY FaultGen IS
	PORT(	CLK				: IN		STD_LOGIC;
			EncStart		: IN		STD_LOGIC;
			start1			: IN		STD_LOGIC_VECTOR(12 DOWNTO 0);
			OffSet1			: IN		STD_LOGIC_VECTOR(6 DOWNTO 0);
			start2			: IN		STD_LOGIC_VECTOR(12 DOWNTO 0);
			OffSet2			: IN		STD_LOGIC_VECTOR(6 DOWNTO 0);
			CLKo			: BUFFER	STD_LOGIC;
			Noise			: OUT		STD_LOGIC;
			rst				: OUT		STD_LOGIC
			);
END FaultGen;
ARCHITECTURE behavioral OF FaultGen IS
	SIGNAL CLK4M_Count					: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL EncStartS					: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Fault_Count					: STD_LOGIC_VECTOR(14 DOWNTO 0);
BEGIN
	PROCESS(CLK)
	BEGIN
		IF RISING_EDGE(CLK) THEN
			EncStartS	<= EncStartS(2 DOWNTO 0) & EncStart;
			IF Fault_Count <32000 THEN
				Fault_Count	<= Fault_Count+1;
				Noise		<= '0';
			ELSE
				Noise	<= '1';
			END IF;
			Noise	<= '0';
			IF (Fault_Count>Start1 AND Fault_Count<(Start1+OffSet1)) OR
			   (Fault_Count>Start2 AND Fault_Count<(Start2+OffSet2)) THEN
				--CLKo	<= NOT CLKo;
				IF CLK4M_Count <3 THEN
					CLK4M_Count	<= CLK4M_Count+1;
				ELSE
					CLK4M_Count<= (OTHERS=>'0');
				END IF;
				IF CLK4M_Count <2 THEN
					CLKo		<= '0';
				ELSE
					CLKo	<= '1';
				END IF;
--				CLK4M_Count	<= "0011";
				Noise		<= '1';
			ELSE
				IF CLK4M_Count <9 THEN
					CLK4M_Count	<= CLK4M_Count+1;
				ELSE
					CLK4M_Count<= (OTHERS=>'0');
				END IF;
				IF CLK4M_Count <5 THEN
					CLKo		<= '0';
				ELSE
					CLKo	<= '1';
				END IF;
			END IF;
			IF EncStartS="0011" THEN
				Fault_Count<= (OTHERS=>'0');
			END IF;
		END IF;
	END PROCESS;
END behavioral;