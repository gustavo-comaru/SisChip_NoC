library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.NUMERIC_STD.all;
use work.HermesPackage.all;

entity SwitchControl is
port(
	clock :   in  std_logic;
	reset :   in  std_logic;
	h :       in  regNport;
	ack_h :   out regNport;
	address : in  regmetadeflit;
	data :    in  arrayNport_regflit;
	sender :  in  regNport;
	free :    out regNport;
	mux_in :  out arrayNport_reg3;
	mux_out : out arrayNport_reg3);
end SwitchControl;

architecture AlgorithmXY of SwitchControl is

type state is (S0,S1,S2,S3,S4,S7,VERT_ALIGN,EAST_BOUND,WEST_BOUND,CHOOSE_PORT,ROUTE);
signal ES, PES: state;

-- sinais do arbitro
signal ask: std_logic := '0';
signal sel,prox: integer range 0 to (NPORT-1) := 0;
signal incoming: reg3 := (others=> '0');
signal header : regflit := (others=> '0');

-- sinais do controle
signal dirx,diry: integer range 0 to (NPORT-1) := 0;
signal lx,ly,tx,ty: regquartoflit := (others=> '0');
signal auxfree: regNport := (others=> '0');
signal source:  arrayNport_reg3 := (others=> (others=> '0'));
signal sender_ant: regNport := (others=> '0');

-- odd-even
signal sx, sy				: regquartoflit;				-- source address
signal e0, e1				: integer;						-- delta x / delta y
signal directions 			: std_logic_vector(3 downto 0);	-- avail dimension set
signal current_column_odd	: std_logic;					-- current column is odd
signal target_column_odd	: std_logic;					-- target column is odd
signal forward_dir 			: integer range 0 to (NPORT-1);	-- direction to forward packet
signal available_dir 		: std_logic;					-- forward_dir contains valid value

begin

	ask <= '1' when h(LOCAL)='1' or h(EAST)='1' or h(WEST)='1' or h(NORTH)='1' or h(SOUTH)='1' else '0';
	incoming <= CONV_VECTOR(sel);
	header <= data(CONV_INTEGER(incoming));

	process(sel,h)
	begin
		case sel is
			when LOCAL=>
				if h(EAST)='1' then prox<=EAST;
				elsif h(WEST)='1' then  prox<=WEST;
				elsif h(NORTH)='1' then prox<=NORTH;
				elsif h(SOUTH)='1' then prox<=SOUTH;
				else prox<=LOCAL; end if;
			when EAST=>
				if h(WEST)='1' then prox<=WEST;
				elsif h(NORTH)='1' then prox<=NORTH;
				elsif h(SOUTH)='1' then prox<=SOUTH;
				elsif h(LOCAL)='1' then prox<=LOCAL;
				else prox<=EAST; end if;
			when WEST=>
				if h(NORTH)='1' then prox<=NORTH;
				elsif h(SOUTH)='1' then prox<=SOUTH;
				elsif h(LOCAL)='1' then prox<=LOCAL;
				elsif h(EAST)='1' then prox<=EAST;
				else prox<=WEST; end if;
			when NORTH=>
				if h(SOUTH)='1' then prox<=SOUTH;
				elsif h(LOCAL)='1' then prox<=LOCAL;
				elsif h(EAST)='1' then prox<=EAST;
				elsif h(WEST)='1' then prox<=WEST;
				else prox<=NORTH; end if;
			when SOUTH=>
				if h(LOCAL)='1' then prox<=LOCAL;
				elsif h(EAST)='1' then prox<=EAST;
				elsif h(WEST)='1' then prox<=WEST;
				elsif h(NORTH)='1' then prox<=NORTH;
				else prox<=SOUTH; end if;
		end case;
	end process;

	lx <= address((METADEFLIT - 1) downto QUARTOFLIT);
	ly <= address((QUARTOFLIT - 1) downto 0);

	tx <= header((METADEFLIT - 1) downto QUARTOFLIT);
	ty <= header((QUARTOFLIT - 1) downto 0);

	sx <= header((TAM_FLIT - 1) downto (METADEFLIT + QUARTOFLIT));	-- 31 downto 24
	sy <= header((METADEFLIT + QUARTOFLIT - 1) downto METADEFLIT);	-- 23 downto 16

	dirx <= WEST when lx > tx else EAST;
	diry <= NORTH when ly < ty else SOUTH;

	e0 <= to_integer(signed(tx)) - to_integer(signed(lx));
	e1 <= to_integer(signed(ty)) - to_integer(signed(ly));

	current_column_odd	<= lx(0); -- '1' if current column is odd, else '0'
	target_column_odd	<= tx(0); -- '1' if target column is odd, else '0'

	process(reset,clock)
	begin
		if reset='1' then
			ES<=S0;
		elsif clock'event and clock='0' then
			ES<=PES;
		end if;
	end process;

	------------------------------------------------------------------------------------------------------
	-- PARTE COMBINACIONAL PARA DEFINIR O PR�XIMO ESTADO DA M�QUINA.
	--
	-- SO -> O estado S0 � o estado de inicializa��o da m�quina. Este estado somente �
	--       atingido quando o sinal reset � ativado.
	-- S1 -> O estado S1 � o estado de espera por requisi��o de chaveamento. Quando o
	--       �rbitro recebe uma ou mais requisi��es o sinal ask � ativado fazendo a
	--       m�quina avan�ar para o estado S2.
	-- S2 -> No estado S2 a porta de entrada que solicitou chaveamento � selecionada. Se
	--       houver mais de uma, aquela com maior prioridade � a selecionada.
	-- S3 -> No estado S3 � realizado algoritmo de chaveamento XY. O algoritmo de chaveamento
	--       XY faz a compara��o do endere�o da chave atual com o endere�o da chave destino do
	--       pacote (armazenado no primeiro flit do pacote). O pacote deve ser chaveado para a
	--       porta Local da chave quando o endere�o xLyL* da chave atual for igual ao endere�o
	--       xTyT* da chave destino do pacote. Caso contr�rio, � realizada, primeiramente, a
	--       compara��o horizontal de endere�os. A compara��o horizontal determina se o pacote
	--       deve ser chaveado para o Leste (xL<xT), para o Oeste (xL>xT), ou se o mesmo j�
	--       est� horizontalmente alinhado � chave destino (xL=xT). Caso esta �ltima condi��o
	--       seja verdadeira � realizada a compara��o vertical que determina se o pacote deve
	--       ser chaveado para o Sul (yL<yT) ou para o Norte (yL>yT). Caso a porta vertical
	--       escolhida esteja ocupada, � realizado o bloqueio dos flits do pacote at� que o
	--       pacote possa ser chaveado.
	-- S4, S5 e S6 -> Nestes estados � estabelecida a conex�o da porta de entrada com a de
	--       de sa�da atrav�s do preenchimento dos sinais mux_in e mux_out.
	-- S7 -> O estado S7 � necess�rio para que a porta selecionada para roteamento baixe o sinal
	--       h.
	--
	process(ES,ask,h,lx,ly,tx,ty,auxfree,dirx,diry)
	begin
		case ES is
			when S0 => PES <= S1;
			when S1 => if ask='1' then PES <= S2; else PES <= S1; end if;
			when S2 => PES <= S3;
			when S3 => 

				if lx=tx and ly=ty then -- send local
					if auxfree(LOCAL)='1' then
						PES <= S4;
					else
						PES <= S1;
					end if;

				elsif tx=lx then
					PES <= VERT_ALIGN;
				elsif tx>lx then
					PES <= EAST_BOUND;
				else
					PES <= WEST_BOUND;
				end if;
			
			when VERT_ALIGN => PES <= CHOOSE_PORT;
			when EAST_BOUND => PES <= CHOOSE_PORT;
			when WEST_BOUND => PES <= CHOOSE_PORT;

			when CHOOSE_PORT =>
			
				if available_dir='1' then
					PES <= ROUTE;
				else
					PES <= S1;
				end if;

			when ROUTE => PES <= S7;

			when S4 => PES<=S7;
			when S7 => PES<=S1;
		end case;
	end process;

	------------------------------------------------------------------------------------------------------
	-- executa as a��es correspondente ao estado atual da m�quina de estados
	------------------------------------------------------------------------------------------------------
	process (clock)
	begin
		if clock'event and clock='1' then
			case ES is
				-- Zera vari�veis
				when S0 =>
					sel <= 0;
					ack_h <= (others => '0');
					auxfree <= (others=> '1');
					sender_ant <= (others=> '0');
					mux_out <= (others=>(others=>'0'));
					source <= (others=>(others=>'0'));
					directions <= (others => '0');
				-- Chegou um header
				when S1=>
					ack_h <= (others => '0');
					directions <= (others => '0');
				-- Seleciona quem tera direito a requisitar roteamento
				when S2=>
					sel <= prox;
				-- Estabelece a conex�o com a porta LOCAL
				when S4 =>
					source(CONV_INTEGER(incoming)) <= CONV_VECTOR(LOCAL);
					mux_out(LOCAL) <= incoming;
					auxfree(LOCAL) <= '0';
					ack_h(sel)<='1';
				
				when VERT_ALIGN =>
					if e1>0 then
						directions(NORTH) <= '1';
					else
						directions(SOUTH) <= '1';
					end if;
				
				when EAST_BOUND =>
					if e1=0 then
						directions(EAST) <= '1';
					else
						if current_column_odd='1' or lx=sx then
							if e1>0 then
								directions(NORTH) <= '1';
							else
								directions(SOUTH) <= '1';
							end if;
						end if;
						if target_column_odd='1' or e0/=1 then
							directions(EAST) <= '1';
						end if;
					end if;

				when WEST_BOUND =>
					directions(WEST) <= '1';
					if current_column_odd='0' then
						if e1>0 then
							directions(NORTH) <= '1';
						else
							directions(SOUTH) <= '1';
						end if;
					end if;
				
				when ROUTE =>
					source(CONV_INTEGER(incoming)) <= CONV_VECTOR(forward_dir);
					mux_out(forward_dir) <= incoming;
					auxfree(forward_dir) <= '0';
					ack_h(sel)<='1';

				when others => ack_h(sel)<='0';
			end case;

			sender_ant(LOCAL) <= sender(LOCAL);
			sender_ant(EAST)  <= sender(EAST);
			sender_ant(WEST)  <= sender(WEST);
			sender_ant(NORTH) <= sender(NORTH);
			sender_ant(SOUTH) <= sender(SOUTH);

			if sender(LOCAL)='0' and  sender_ant(LOCAL)='1' then auxfree(CONV_INTEGER(source(LOCAL))) <='1'; end if;
			if sender(EAST) ='0' and  sender_ant(EAST)='1'  then auxfree(CONV_INTEGER(source(EAST)))  <='1'; end if;
			if sender(WEST) ='0' and  sender_ant(WEST)='1'  then auxfree(CONV_INTEGER(source(WEST)))  <='1'; end if;
			if sender(NORTH)='0' and  sender_ant(NORTH)='1' then auxfree(CONV_INTEGER(source(NORTH))) <='1'; end if;
			if sender(SOUTH)='0' and  sender_ant(SOUTH)='1' then auxfree(CONV_INTEGER(source(SOUTH))) <='1'; end if;

		end if;
	end process;

	SelectOutputDirection: process(directions, auxfree)
	begin
		if directions(EAST)='1' and auxfree(EAST)='1' then
			forward_dir <= EAST;
			available_dir <= '1';

		elsif directions(WEST)='1' and auxfree(WEST)='1' then
			forward_dir <= WEST;
			available_dir <= '1';

		elsif directions(NORTH)='1' and auxfree(NORTH)='1' then
			forward_dir <= NORTH;
			available_dir <= '1';

		elsif directions(SOUTH)='1' and auxfree(SOUTH)='1' then
			forward_dir <= SOUTH;
			available_dir <= '1';

		else
			forward_dir <= 0;
			available_dir <= '0';
		end if;
	end process;

	mux_in <= source;
	free <= auxfree;

end AlgorithmXY;
 