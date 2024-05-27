library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;


entity CPU is
    Port (
           clock : in STD_LOGIC;
           clear : in STD_LOGIC;
           ram_address : out STD_LOGIC_VECTOR (11 downto 0);
           ram_datain : out STD_LOGIC_VECTOR (15 downto 0);
           ram_dataout : in STD_LOGIC_VECTOR (15 downto 0);
           ram_write : out STD_LOGIC;
           rom_address : out STD_LOGIC_VECTOR (11 downto 0);
           rom_dataout : in STD_LOGIC_VECTOR (35 downto 0);
           dis : out STD_LOGIC_VECTOR (15 downto 0));
end CPU;



architecture Behavioral of CPU is

-- Clases que ocupamos --

component Reg
    Port ( clock    : in  std_logic;                        -- Señal del clock (reducido).
           clear    : in  std_logic;                        -- Señal de reset.
           load     : in  std_logic;                        -- Señal de carga.
           up       : in  std_logic;                        -- Señal de subida.
           down     : in  std_logic;                        -- Señal de bajada.
           datain   : in  std_logic_vector (15 downto 0);   -- Señales de entrada de datos.
           dataout  : out std_logic_vector (15 downto 0));  -- Señales de salida de datos.
end component;


component RegSP
    Port ( clock    : in  std_logic;                        -- Señal del clock (reducido).
           clear    : in  std_logic;                        -- Señal de reset.
           load     : in  std_logic;                        -- Señal de carga.
           up       : in  std_logic;                        -- Señal de subida.
           down     : in  std_logic;                        -- Señal de bajada.
           datain   : in  std_logic_vector (15 downto 0);   -- Señales de entrada de datos.
           dataout  : out std_logic_vector (15 downto 0));  -- Señales de salida de datos.
end component;


component ALU
    Port ( a        : in  std_logic_vector (15 downto 0);   -- Primer operando.
           b        : in  std_logic_vector (15 downto 0);   -- Segundo operando.
           sop      : in  std_logic_vector (2 downto 0);   -- Selector de la operación.
           c        : out std_logic;                       -- Señal de 'carry'.
           z        : out std_logic;                       -- Señal de 'zero'.
           n        : out std_logic;                       -- Señal de 'nagative'.
           result   : out std_logic_vector (15 downto 0));  -- Resultado de la operación.
end component;


component MUX16x4
    Port ( I1 : in STD_LOGIC_VECTOR (15 downto 0);
           I2 : in STD_LOGIC_VECTOR (15 downto 0);
           I3 : in STD_LOGIC_VECTOR (15 downto 0);
           I4 : in STD_LOGIC_VECTOR (15 downto 0);
           SEL : in STD_LOGIC_VECTOR (1 downto 0);
           OUTPUT : out STD_LOGIC_VECTOR (15 downto 0));
end component;


component ControlUnit
    Port ( rom_dataout : in STD_LOGIC_VECTOR (19 downto 0);
           StaCU : in STD_LOGIC_VECTOR (2 downto 0);
           enableA : out STD_LOGIC;
           enableB : out STD_LOGIC;
           selA : out STD_LOGIC_VECTOR (1 downto 0);
           selB : out STD_LOGIC_VECTOR (1 downto 0);
           loadPC : out STD_LOGIC;
           selALU : out STD_LOGIC_VECTOR (2 downto 0);
           w : out STD_LOGIC;
           selAdd: out STD_LOGIC_VECTOR (1 downto 0);
           selDIn: out STD_LOGIC;
           selPC: out STD_LOGIC;
           incSP: out STD_LOGIC;
           decSp: out STD_LOGIC);
end component;

--- Señales que ocupamos ---

signal enableA: std_logic;
signal enableB: std_logic;

signal ReMu_A: std_logic_vector(15 downto 0);
signal ReMu_B: std_logic_vector(15 downto 0);

signal selA: std_logic_vector(1 downto 0);
signal selB: std_logic_vector(1 downto 0);

signal selALU: std_logic_vector(2 downto 0);

signal C_S: std_logic;
signal Z_S: std_logic;
signal N_S: std_logic;

signal Status_in: std_logic_vector(15 downto 0);
signal Status_out: std_logic_vector(15 downto 0);

signal StaCU: std_logic_vector(2 downto 0);


signal MuALU_A: std_logic_vector(15 downto 0);
signal MuALU_B: std_logic_vector(15 downto 0);

signal Result: std_logic_vector(15 downto 0);

signal PCin: std_logic_vector(15 downto 0);
signal RamDoIn: std_logic_vector(15 downto 0);
signal SelMuxPC: std_logic_vector(1 downto 0);
signal MuxPCout: std_logic_vector(15 downto 0);

signal SPout: std_logic_vector(15 downto 0) := "0000111111111111";

signal PCout: std_logic_vector(15 downto 0);

signal Adderout: std_logic_vector(15 downto 0);

signal SelMuxDin: std_logic_vector(1 downto 0);

signal MuxSout: std_logic_vector(15 downto 0); 

--- Señales de la Control unit ---

signal loadPC: std_logic;

signal w: std_logic;

signal selPC: std_logic;

signal selDIn: std_logic;

signal incSP: std_logic;

signal decSP: std_logic;

signal selAdd: std_logic_vector(1 downto 0);


begin

RegA: Reg port map(
    clock   => clock,
    clear   => clear,
    load    => enableA,
    up      => '0',
    down    => '0',
    datain  => Result,
    dataout => ReMu_A
    );

RegB: Reg port map(
    clock   => clock,
    clear   => clear,
    load    => enableB,
    up      => '0',
    down    => '0',
    datain  => Result,
    dataout => ReMu_B
    );


MuxA: MUX16x4 port map(
    I1 => "0000000000000000",
    I2 => rom_dataout(35 downto 20),
    I3 => "0000000000000001",
    I4 => ReMu_A,
    SEL => selA,
    OUTPUT => MuALU_A
    );


MuxB: MUX16x4 port map(
    I1 => "0000000000000000",
    I2 => ReMu_B,
    I3 => ram_dataout,
    I4 => rom_dataout(35 downto 20),
    SEL => selB,
    OUTPUT => MuALU_B
    );


ALU1: ALU port map (
    a  => MuALU_A,      
    b  =>  MuALU_B,
    sop => selALU,  
    c   => C_S,
    z   =>  Z_S,  
    n   => N_S,
    result => Result
);


Status_in <= C_S & Z_S & N_S & "0000000000000";

Status: Reg port map(
    clock   => clock,
    clear   => clear,
    load    => '1',
    up      => '0',
    down    => '0',
    datain  =>  Status_in,
    dataout => Status_out
    );


StaCU <= Status_out(15 downto 13);


PCin <= "0000" & rom_dataout(31 downto 20);

RamDoIn <= "0000" & ram_dataout(11 downto 0);

SelMuxPC <= '0' & selPC;


MuxPC: MUX16x4 port map(
    I1 => ram_dataout,
    I2 => PCin,
    I3 => "0000000000000000",
    I4 => "0000000000000000",
    SEL => selMuxPC,
    OUTPUT => MuxPCout
    );

PC: Reg port map(
    clock   => clock,
    clear   => clear,
    load    => loadPC,
    up      => '1',
    down    => '0',
    datain  => MuxPCout,
    dataout => PCout
    );


ADDER: ALU port map (
    a  => "0000000000000001",      
    b  =>  PCout,
    sop => "000",
    result => Adderout
);

selMuxDin <= '0' & selDIn;

MuxDataIn: MUX16x4 port map(
    I1 => Result,
    I2 => Adderout,
    I3 => "0000000000000000",
    I4 => "0000000000000000",
    SEL => selMuxDin,
    OUTPUT => ram_datain
    );



SP: RegSP port map(
    clock   => clock,
    clear   => clear,
    load    => '1',
    up      => incSP,
    down    => decSP,
    datain  => SPout,
    dataout => SPout
    );


MuxS: MUX16x4 port map(
    I1 => SPout,
    I2 => rom_dataout(35 downto 20),
    I3 => ReMu_B,
    I4 => "0000000000000000",
    SEL => selAdd,
    OUTPUT => MuxSout
    );

rom_address <= PCout(11 downto 0);

ram_address <= MuxSout(11 downto 0);


-- ram_datain <= Result; -- cable cortado

ram_write <= w;

dis <= ReMu_A(7 downto 0) & ReMu_B(7 downto 0);

CU: ControlUnit port map( 
    rom_dataout => rom_dataout(19 downto 0),
    StaCU => StaCU,
    enableA => enableA,
    enableB => enableB,
    selA => selA,
    selB => selB,
    loadPC => loadPC,
    selALU => selALU,
    w => w,
    selAdd => selAdd,
    selDIn => selDIn,
    selPC => selPC,
    incSP => incSP,
    decSp => decSP
    );




end Behavioral;

