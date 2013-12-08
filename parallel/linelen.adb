with ADA.Numerics.Elementary_Functions;
use ADA.Numerics.Elementary_Functions;
with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Float_Text_IO;
use Ada.Float_Text_IO;
with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;

procedure LineLen is
	n_proc : integer := 110;
	num : float := 20.0;
	symb : integer := 10;
	spaces : integer := 0;
	
	function Calc(l, r, acc: in float) return float is
		cur: float := 0.0;
		prev: float := 1000.0;
		proc_ar: array (1..n_proc) of float;
		
		function f(x: in float) return float is
		begin
			return sqrt(4.0 - x * x);
		end f;
		pragma inline(f);

		task type calc is
			entry set_id(i:integer);
			entry start_calc;
			entry end_calc;
		end calc;
		
		proc: array (1..n_proc) of calc;
		
		task body calc is
		x, val, proc_l, proc_r, step: float;
		ii: integer;
		begin
			accept set_id (i:integer) do
				ii:= i; 
			end set_id;
			proc_l := l + (r - l) / float(n_proc) * float(ii - 1);
			proc_r := l + (r - l) / float(n_proc) * float(ii);
			loop
				select
					accept start_calc;
						step := (proc_r - proc_l) / num;
						x := proc_l;
						proc_ar(ii) := 0.0;
						for i in 1..integer(num) loop
							val := sqrt( ( f(x) - f(x + step) ) ** 2 + step ** 2);
							proc_ar(ii) := proc_ar(ii) + val;
							x := x + step;
						end loop;
				or
					accept end_calc;
				or
					terminate;
				end select;
			end loop;
		end calc;

		procedure step is
		begin
			proc_ar := (others => 0.0);
			for id in 1..n_proc loop
				proc(id).start_calc;
			end loop;
			for id in 1..n_proc loop
				proc(id).end_calc;
			end loop;
		end step;
		
		procedure init is
		begin
			for id in 1..n_proc loop
				proc(id).set_id(id);
			end loop;
		end init;

	begin
		init;
		while abs(prev - cur) > acc loop
			prev := cur;
			step;
			cur := proc_ar(1);
			for id in 2..n_proc loop
				cur := cur + proc_ar(id);
			end loop;
		end loop;
		return cur;
	end Calc;

begin
	put ( Calc (-2.0, 2.0, 0.1e-3), spaces, symb);
end LineLen;

--6.2821893692E+00


------------------
--(program exited with code: 0)
--Press return to continue




