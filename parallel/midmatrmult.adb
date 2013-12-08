with ADA.Numerics.Elementary_Functions;
use ADA.Numerics.Elementary_Functions;
with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Float_Text_IO;
use Ada.Float_Text_IO;
with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;

with Ada.Numerics.Discrete_Random;

procedure midmatrmult is
	flag : boolean := true;
	dim : constant integer := 10;
	eps : constant float := 0.001;
	type vector is array (1..dim) of float;
	type matrix is array (1..dim) of vector;
		
	A : matrix;
	B : matrix;
		
	ANS1 : matrix;
	ANS2 : matrix;
	tmp_1, tmp_2 : vector;
	oper : integer;
	delt : float;
		
	task type calc is
		entry set_id(id: in integer);
		entry start_calc;
		entry end_calc;
	end calc;
	
	proc: array (1..dim) of calc;
		
	task body calc is
		j: integer;
	begin
		accept set_id(id: in integer) do
			j := id;
		end set_id;
		loop
			select
				accept start_calc;
				case oper is
					when 1 => tmp_2(j) := tmp_1(j) + tmp_2(j);
					when 2 => tmp_2(j) := tmp_1(j) * tmp_2(j);
						when 3 => tmp_2(j) := tmp_1(1);
						when others => null;
					end case;
				or
					accept end_calc;
				or
					terminate;
			end select;
		end loop;
	end calc;
		
	procedure step is
	begin
		for id in 1..dim loop
			proc(id).start_calc;
		end loop;
		for id in 1..dim loop
			proc(id).end_calc;
		end loop;
	end step;

	procedure init is
	begin
		for id in 1..dim loop
			proc(id).set_id(id);
		end loop;
	end init;
	
	function "+"(a, b: in vector) return vector is
	begin
		tmp_1 := a;
		tmp_2 := b;
		oper :=1;
		step;
		return tmp_2;
	end "+";

	function "*"(a, b: in vector) return vector is
	begin
		tmp_1 := a;
		tmp_2 := b;
		oper := 2; 
		step;
		return tmp_2;
	end "*";
	
	function expn(S : in float) return vector is
	begin
		tmp_1(1) := S; 
		oper := 3;
		step;
		return tmp_2;
	end expn;

	procedure matr_init is
		subtype value is Positive range 1..100;
		package Rand is
			new Ada.Numerics.Discrete_Random(value);
		seed : Rand.Generator;
	begin
		Rand.Reset(seed);
		for row in 1..dim loop
			for col in 1..dim loop
				A(row)(col) := Float(Rand.Random(seed))/1000.0;
				B(row)(col) := A(row)(col);
			end loop;
		end loop;
	end matr_init;

begin
	init;
	matr_init;
	
	ANS1 := (others => (others => 0.0));
	ANS2 := (others => (others => 0.0));
	
	for j in 1..dim loop
		for k in 1..dim loop
			ANS1(j) := ANS1(j) + A(k) * expn(B(j)(k));
		end loop;
	end loop;
	
	for i in 1..dim loop
		for j in 1..dim loop
			for k in 1..dim loop
				ANS2(i)(j) := ANS2(i)(j) + A(i)(k) * B(k)(j);
			end loop;
		end loop;
	end loop;
	
	for j in 1..dim loop
		for k in 1..dim loop
			delt := abs(ANS2(j)(k)) - abs(ANS1(j)(k));
			if ( abs(delt) > eps)
			then
				flag := false;
			end if;
		end loop;
	end loop;
	
	if ( flag = false )
	then
		put("Some problems with accuracy :");
		put(eps);
	else
		put("OK");
	end if;
end midmatrmult;

--Минаков Александр
--K5-224

--Вывод программы

--OK 
--или
--Some problems with accuracy : eps
--где eps заданная точность
