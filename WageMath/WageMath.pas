Program WageMath;
uses crt, dos;//dos biblioteca de data e hora.
{----Identificao de topicos----}
Label
	start, menuadmin, login,
	menufunc, menu, opcoes,
	apa, rel, relat, relato;
{----Constante de repeticao da hora----}
Const
	Max = 1000000000;//nao e necessario...
{----Constante da data e hora----}
Const
	diadasemana: Array [0..6] of String = ('Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab');//Dias de semana de forma abreviada 
	mesdoano: Array [1..12] of String = ('Janeiro', 'Fevereiro', 'Marco', 'Abril', 'Maio', 'Junho',
	'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro');
{----Arquivos de registro de dados----}
Type
	utilizador = Record
		username, password: String[15];
		nome, sexo: string;
		nasc: string[10];
		bi: String[13];
		id: Integer;
	end;
	arquivo1 = file of utilizador;
	funcionario = Record
		nome, sexo, email, cargo: string;
		nasc: string[10];
		bi: string[13];
		cel: Array[1..2] of string;
		salario, aumento, desconto, paumento,
		pdesconto, salariototal, antigo: real;
		id, Ahext, Dhext: Integer;
	end;
	arquivo2 = file of funcionario;
{----Variaveis auxiliares e principais----}
Var
	arq1: arquivo1;
	admin: utilizador;
	arq2: arquivo2;
	func: funcionario;
	salario, aumento,
	deconto, paumento,
	pdesconto, salariototal: real;
	i, option, n, up, Ahext,Dhext,
	ibusca, idF, idA,size: Integer;
	day, dia, mes,ano, hora,
	minuto, segundo,msegundo,
	weekday: Word;
	nomefunc, nomeadmin,
	tel, mail: String;
	user, pass, passadmin: string[15];
	tecla: char;
	encontrei: Boolean;
{----Subprogramas----}
Function Existe_Util(var fich: arquivo1):Boolean;
	Begin
		{$I-}
		Reset(fich);
			if IOResult = 0 then
				Begin
					Existe_Util := true;
				end
			else
				Existe_Util := false;
		{$I+}
	end;
//----------------------------------------
Procedure Registro_Util(var fich: arquivo1);
	Begin
		Assign(arq1, 'Utilizador.dat');
		ReWrite(arq1);
		ClrScr;
		textcolor(blue);
		textbackground(lightcyan);
	  gotoxy(30,2);Writeln('_REGISTRO DO ADMINISTRADOR_');
	  textcolor(white);
		textbackground(blue);
		Randomize;
		admin.id := 1101+Random(1000);
		gotoxy(20,8);Writeln('ID: ',admin.id);
		gotoxy(20,9);Write('Nome completo: ');
	  textcolor(yellow);Readln(admin.nome);
	  For up := 1 To Length(admin.nome) Do
	    admin.nome[up] := Upcase(admin.nome[up]);
		textcolor(white);gotoxy(20,10);write('Data de nascimento(dd/mm/aaaa): ');
		textcolor(yellow);readln(admin.nasc);textcolor(white);
		gotoxy(20,11);textcolor(white);write('Bilhete de identidade: ');
		textcolor(yellow);readln(admin.bi);
		for up := 1 to Length(admin.bi) do
			admin.bi[up] := upcase(admin.bi[up]);
		gotoxy(20,12);textcolor(white);write('Sexo: ');
		textcolor(yellow);readln(admin.sexo);
		for up := 1 to Length(admin.sexo) do
			admin.sexo[up] := upcase(admin.sexo[up]);
		gotoxy(20,13);textcolor(white);writeln('------------------------------------');
		gotoxy(20,14);write('Username: ');
		textcolor(yellow);readln(admin.username);
		for up := 1 to Length(admin.username)do
			admin.username[up] := upcase(admin.username[up]);
	  textcolor(white);gotoxy(20,15);Write('Password: ');
	  textcolor(yellow);Readln(admin.password);
	  For up := 1 To Length(admin.password) Do
	  admin.password[up] := Upcase(admin.password[up]);
		write(arq1, admin);
		close(arq1);
	end;
//------------------------------------------
Procedure Adicionar_Util(var fich: arquivo1);
	Begin
		Assign(arq1, 'Utilizador.dat');
		Reset(arq1);
		Seek(arq1, FileSize(arq1));
		ClrScr;
		textcolor(blue);
		textbackground(lightcyan);
	  gotoxy(30,2);Writeln('_REGISTRO DO ADMINISTRADOR_');
	  textcolor(white);
		textbackground(blue);
		Randomize;
		admin.id := 1101+Random(1000);
		gotoxy(20,8);Writeln('ID: ',admin.id);
		gotoxy(20,9);Write('Nome completo: ');
	  textcolor(yellow);Readln(admin.nome);
	  For up := 1 To Length(admin.nome) Do
	    admin.nome[up] := Upcase(admin.nome[up]);
		textcolor(white);gotoxy(20,10);write('Data de nascimento(dd/mm/aaaa): ');
		textcolor(yellow);readln(admin.nasc);textcolor(white);
		gotoxy(20,11);textcolor(white);write('Bilhete de identidade: ');
		textcolor(yellow);readln(admin.bi);
		for up := 1 to Length(admin.bi) do
			admin.bi[up] := upcase(admin.bi[up]);
		gotoxy(20,12);textcolor(white);write('Sexo: ');
		textcolor(yellow);readln(admin.sexo);
		for up := 1 to Length(admin.sexo) do
			admin.sexo[up] := upcase(admin.sexo[up]);
		gotoxy(20,13);textcolor(white);writeln('------------------------------------');
		gotoxy(20,14);write('Username: ');
		textcolor(yellow);readln(admin.username);
		for up := 1 to Length(admin.username)do
			admin.username[up] := upcase(admin.username[up]);
	  textcolor(white);gotoxy(20,15);Write('Password: ');
	  textcolor(yellow);Readln(admin.password);
	  For up := 1 To Length(admin.password) Do
	  admin.password[up] := Upcase(admin.password[up]);
		write(arq1, admin);
		close(arq1);
	end;
//-------------------------------------------------------------------
Function Verifica_Util(var fich: arquivo1; usr, pwd: string): Boolean;
	Begin
		Assign(arq1, 'Utilizador.dat');
		Reset(arq1);
		for i := 0 to FileSize(arq1)-1 Do   
			Begin
				seek(arq1, i);
				Read(arq1, admin);
				if(admin.username = usr) and (admin.password = pwd)then
					Begin
						Verifica_Util := true;
					end                     //uso da varivavel Boolean para verificar a autenticidade
				Else
					Verifica_Util := False;
			end;
		Close(arq1);
	end;
//---------------------------------------------
Function Existe_Func(var fich:arquivo2):Boolean;
	Begin
		{$I-}
		Reset(arq2);
			if IOResult = 0 Then
				Begin
					Existe_Func:= true;
				End
			Else
				Existe_Func:= false;
		{$I+}
	End;
//----------------------------------------
Procedure Registro_Func(var fich:arquivo2);
	Begin
		Assign(arq2, 'Funcionario.dat');
		ReWrite(arq2);
		ClrScr;
		TEXTCOLOR(BLUE);
		TEXTBACKGROUND(LIGHTCYAN);
		gotoxy(35,2);writeln('_REGISTRO DO FUNCIONARIO_');
		TEXTCOLOR(WHITE);
		TEXTBACKGROUND(BLUE);
		gotoxy(15,6);writeln('Quantos funcionarios deseja registrar?');
		gotoxy(15,7);write('>>> ');
		readln(n);
		func.id:=LongInt(00001);
		for i := 1 to n do
			Begin
				ClrScr;
				TEXTCOLOR(BLUE);
				TEXTBACKGROUND(LIGHTCYAN);
				gotoxy(30,2);writeln('_REGISTRO DO FUNCIONARIO_');
				TEXTCOLOR(WHITE);
				TEXTBACKGROUND(BLUE);
				gotoxy(15,8);Writeln('ID FUNCIONARIO: ',func.id);
				gotoxy(15,9);Write('Nome completo: ');
			  textcolor(yellow);Readln(func.nome);
			  For up := 1 To Length(func.nome) Do
			    func.nome[up] := Upcase(func.nome[up]);
				textcolor(white);gotoxy(15,10);write('Data de nascimento(dd/mm/aaaa): ');
				textcolor(yellow);readln(func.nasc);
				textcolor(white);gotoxy(15,11);write('Bilhete de identidade: ');
				textcolor(yellow);readln(func.bi);
				for up := 1 to Length(func.bi) do
					func.bi[up] := upcase(func.bi[up]);
				if(func.bi = ' ')Then
					func.bi:='XXXXXXXXXXXXX';
				textcolor(white);gotoxy(15,12);write('Sexo: ');
				textcolor(yellow);readln(func.sexo);
				for up := 1 to Length(func.sexo) do
					func.sexo[up] := upcase(func.sexo[up]);
				textcolor(white);gotoxy(15,13);write('Celular: ');
				textcolor(yellow);readln(func.cel[1]);
				textcolor(white);gotoxy(15,14);write('Celular alternativo: ');
				textcolor(yellow);readln(func.cel[2]);
				gotoxy(15,15);textcolor(white);Write('Email: ');
			  textcolor(yellow);Readln(func.email);
				ClrScr;
				textcolor(white);
				gotoxy(15,5);writeln('[1] Gerente');
				gotoxy(15,6);writeln('[2] Engenheiro');
				gotoxy(15,7);writeln('[3] Tecnico');
				gotoxy(15,8);writeln('[4] Outros');
				gotoxy(15,9);writeln('--------------');
				gotoxy(15,10);write('>>> ');
				readln(option);
				case(option)of
					1: Begin
								func.salario := 60000;
								func.cargo := 'Gerente';
						 end;
					2: Begin
								func.salario := 50000;
								func.cargo := 'Engenheiro';
						 end;
					3: Begin
								func.salario := 40000;
								func.cargo := 'Tecnico';
						 end;
					4: Begin
								func.salario := 30000;
								func.cargo := 'Outros';
						 End
					Else RunError;
				end;
				write(arq2, func);
				func.id:=func.id+1;
			end;
			Close(arq2);
	End;
//-----------------------------------------
Procedure Adicionar_Func(var fich: arquivo2);
	Begin
		Assign(arq2, 'Funcionario.dat');
		Reset(arq2);
		Seek(arq2, FileSize(arq2));
		func.id:= func.id+1;
		ClrScr;
		TEXTCOLOR(BLUE);
		TEXTBACKGROUND(LIGHTCYAN);
		gotoxy(35,2);writeln('_REGISTRO DO FUNCIONARIO_');
		TEXTCOLOR(WHITE);
		TEXTBACKGROUND(BLUE);
		gotoxy(15,6);writeln('Quantos funcionarios deseja registrar?');
		gotoxy(15,7);write('>>> ');
		readln(n);
		for i := 1 to n do
			Begin
					ClrScr;
					TEXTCOLOR(BLUE);
					TEXTBACKGROUND(LIGHTCYAN);
					gotoxy(30,2);writeln('_REGISTRO DO FUNCIONARIO_');
					TEXTCOLOR(WHITE);
					TEXTBACKGROUND(BLUE);
					gotoxy(15,8);Writeln('ID FUNCIONARIO: ',func.id);
					gotoxy(15,9);Write('Nome completo: ');
				  textcolor(yellow);Readln(func.nome);
				  For up := 1 To Length(func.nome) Do
				    func.nome[up] := Upcase(func.nome[up]);
					textcolor(white);gotoxy(15,10);write('Data de nascimento(dd/mm/aaaa): ');
					textcolor(yellow);readln(func.nasc);
					textcolor(white);gotoxy(15,11);write('Bilhete de identidade: ');
					textcolor(yellow);readln(func.bi);
					if(func.bi = ' ')Then
						func.bi:='XXXXXXXXXXXXX';
					for up := 1 to Length(func.bi) do
						func.bi[up] := upcase(func.bi[up]);
					textcolor(white);gotoxy(15,12);write('Sexo: ');
					textcolor(yellow);readln(func.sexo);
					for up := 1 to Length(func.sexo) do
						func.sexo[up] := upcase(func.sexo[up]);
					textcolor(white);gotoxy(15,13);write('Celular: ');
					textcolor(yellow);readln(func.cel[1]);
					textcolor(white);gotoxy(15,14);write('Celular alternativo: ');
					textcolor(yellow);readln(func.cel[2]);
					gotoxy(15,15);textcolor(white);Write('Email: ');
				  textcolor(yellow);Readln(func.email);
					ClrScr;
					textcolor(white);
					gotoxy(15,5);writeln('[1] Gerente');
					gotoxy(15,6);writeln('[2] Engenheiro');
					gotoxy(15,7);writeln('[3] Tecnico');
					gotoxy(15,8);writeln('[4] Outros');
					gotoxy(15,9);writeln('--------------');
					gotoxy(15,10);write('>>> ');
					readln(option);
					case(option)of
						1: Begin
									func.salario := 60000;
									func.cargo := 'Gerente';
							 end;
						2: Begin
									func.salario := 50000;
									func.cargo := 'Engenheiro';
							 end;
						3: Begin
									func.salario := 40000;
									func.cargo := 'Tecnico';
							 end;
						4: Begin
									func.salario := 30000;
									func.cargo := 'Outros';
							 End
						Else RunError;
					end;
					salario := func.salario;
					write(arq2, func);
					func.id:= func.id+1;
			end;
			Close(arq2);
	End;
//---------------------------------------
Procedure listar_Func(var fich: arquivo2);
	Begin
		Assign(fich, 'Funcionario.dat');
		Reset(fich);
		While not Eof(fich)do
			Begin
				read(fich, func);
				writeln('ID: ',func.id);
				writeln('NOME: ',func.nome);
				writeln('DATA DE NASCIMENTO: ', func.nasc);
				writeln('BILHETE DE IDENTIDADE: ',func.bi);
				writeln('SEXO: ', func.sexo);
				writeln('CARGO: ',func.cargo);
				writeln('SALARIO: ',func.salario:2:2,'MZN');
				writeln('CELULAR: ', func.cel[1]);
				writeln('CELULAR ALTERNATIVO: ', func.cel[2]);
				writeln('Email: ', func.email);
				writeln('---------------------------------');
			end;
		Close(fich);
	end;
//---------------------------------------------------------
Procedure PesquisaID_Func(var fich: arquivo2; idF: Integer);
	Begin
		ClrScr;
	  TEXTCOLOR(BLUE);
	  TEXTBACKGROUND(LIGHTCYAN);
	  gotoxy(30,2);writeln('_PESQUISA DE FUNCIONARIO POR ID_');
	  TEXTCOLOR(white);
	  TEXTBACKGROUND(blue);
	  textcolor(yellow);gotoxy(10,6);write('ID do funcionario: ');
	  readln(idF);textcolor(white);
		Assign(arq2, 'Funcionario.dat');
		Reset(arq2);
		for i := 0 to FileSize(arq2)-1 do
			Begin
				Seek(arq2, i);
				read(arq2, func);
				if(func.id = idF)then
					Begin
						with func do
							Begin
								ClrScr;
								writeln('ID: ', id);
								writeln('NOME: ', nome);
								writeln('DATA DE NASCIMENTO: ', nasc);
								writeln('BILHETE DE IDENTIDADE: ', bi);
								writeln('SEXO: ', sexo);
								writeln('CARGO: ', cargo);
								writeln('SALARIO: ', salario:2:2,'MZN');
								writeln('CELULAR: ', cel[1]);
								writeln('CELULAR ALTERNATIVO: ', cel[2]);
								writeln('Email: ', email);
								writeln('---------------------------------');
								encontrei := true;
								writeln('Clique enter para voltar');
								readln;
								break;
							end;
					end;  encontrei := False;
			end;
			Close(arq2);
			if(encontrei = false)then
			Begin
				ClrScr;
				gotoxy(15,6);textcolor(lightred);writeln('ID nao registrado.');
				gotoxy(15,7);textcolor(white);writeln('Pressione enter para voltar');
				readln;
			end;
	end;
//---------------------------------------------------------------
Procedure PesquisaNome_Func(var fich: arquivo2; nomefunc: string);
	Begin
		ClrScr;
	 TEXTCOLOR(BLUE);
	 TEXTBACKGROUND(LIGHTCYAN);
	 gotoxy(30,2);writeln('_PESQUISA DE FUNCIONARIO PELO NOME_');
	 TEXTCOLOR(WHITE);
	 TEXTBACKGROUND(BLUE);
	 textcolor(yellow);gotoxy(10,5);write('Nome do funcionario: ');
	 readln(nomefunc);Textcolor(white);
	 for up := 1 to Length(nomefunc)do
	 	nomefunc[up] := upcase(nomefunc[up]);
		Assign(arq2, 'Funcionario.dat');
		Reset(arq2);
		for i := 0 to FileSize(arq2)-1 do
			Begin
				Seek(arq2, i);
				read(arq2, func);
				if (func.nome = nomefunc) then
					Begin
						with func do
							Begin
								ClrScr;
								writeln('ID: ', id);
								writeln('NOME: ', nome);
								writeln('DATA DE NASCIMENTO: ', nasc);
								writeln('BILHETE DE IDENTIDADE: ', bi);
								writeln('SEXO: ', sexo);
								writeln('CARGO: ', cargo);
								writeln('SALARIO: ', salario:2:2,'MZN');
								writeln('CELULAR: ', cel[1]);
								writeln('CELULAR ALTERNATIVO: ', cel[2]);
								writeln('Email: ', email);
								writeln('---------------------------------');
								encontrei := true;
								writeln('Clique enter para voltar');
								readln;
								break;
							End;
					end;  encontrei := False;
			end;
			Close(arq2);
			if encontrei = False Then
				Begin
					ClrScr;
					gotoxy(15,6);textcolor(lightred);writeln('Funcionario nao registrado.');
					gotoxy(15,7);textcolor(white);writeln('Pressione enter para voltar');
					readln;
				end;
	End;
//-----------------------------------------------------------------------------
Procedure AlterarPerfil_Func(var fich: arquivo2; idF: Integer; nomefunc:String);
	Begin
		ClrScr;
		textcolor(blue);
		textbackground(lightcyan);
		gotoxy(28,3);writeln('_EDITAR PERFIL DO FUNCIONARIO_');
		textcolor(white);
		textbackground(blue);
		gotoxy(10,8);write('ID do funcionario: ');
		textcolor(yellow);readln(idF);textcolor(white);
		gotoxy(10,9);write('Nome do funcionario: ');
		textcolor(yellow);readln(nomefunc);TExtcolor(white);
		for up := 1 to Length(nomefunc)do
			nomefunc[up] := upcase(nomefunc[up]);
		Assign(arq2, 'Funcionario.dat');
		Reset(arq2);
		for i := 0 to FileSize(arq2)-1 do
			Begin
				if(func.id = idF) and (func.nome = nomefunc)then
					Begin
						ClrScr;
						textcolor(blue);
						textbackground(lightcyan);
						gotoxy(30,3);writeln('_EDITAR PERFIL DO FUNCIONARIO_');
						textcolor(white);
						textbackground(blue);
						gotoxy(9,5);writeln('Introduza os dados a serem alterados.');
						gotoxy(10,8);Writeln('ID FUNCIONARIO: ',func.id);
						gotoxy(10,9);Write('Nome completo: ');
					  textcolor(yellow);Readln(func.nome);
					  For up := 1 To Length(func.nome) Do
					    func.nome[up] := Upcase(func.nome[up]);
						textcolor(white);gotoxy(10,10);write('Data de nascimento(dd/mm/aaaa): ');
						textcolor(yellow);readln(func.nasc);
						gotoxy(10,11);textcolor(white);write('Bilhete de identidade: ');
						textcolor(yellow);readln(func.bi);
						for up := 1 to Length(func.bi) do
							func.bi[up] := upcase(func.bi[up]);
						textcolor(white);gotoxy(10,12);write('Sexo: ');
						textcolor(yellow);readln(func.sexo);
						for up := 1 to Length(func.sexo) do
							func.sexo[up] := upcase(func.sexo[up]);
						gotoxy(10,13);textcolor(white);write('Celular: ');
						textcolor(yellow);readln(func.cel[1]);
						textcolor(white);gotoxy(10,14);write('Celular alternativo: ');
						textcolor(yellow);readln(func.cel[2]);
						textcolor(white);gotoxy(10,15);Write('Email: ');
					  textcolor(yellow);Readln(func.email);
						ClrScr;
						textcolor(white);
						gotoxy(20,6);writeln('[1] Gerente');
						gotoxy(20,7);writeln('[2] Engenheiro');
						gotoxy(20,8);writeln('[3] Tecnico');
						gotoxy(20,9);writeln('[4] Outros');
						gotoxy(20,10);writeln('--------------');
						gotoxy(20,11);write('>>> ');
						readln(option);
						case(option)of
							1: Begin
										func.salario := 60000;
										func.cargo := 'Gerente';
								 end;
							2: Begin
										func.salario := 50000;
										func.cargo := 'Engenheiro';
								 end;
							3: Begin
										func.salario := 40000;
										func.cargo := 'Tecnico';
								 end;
							4: Begin
										func.salario := 30000;
										func.cargo := 'Outros';
								 End;
						End;
						Assign(arq2, 'Funcionario.dat');
						Reset(arq2);
						write(arq2, func);
						Close(arq2);
						ClrScr;
						encontrei:= true;
						gotoxy(5,15);textcolor(lightgreen);writeln('Os seu perfil foi actualizado com sucesso.');
						textcolor(white);gotoxy(5,16);writeln('Clique enter para voltar ao menu');
						readln;
					end
				Else encontrei := False;
			end;
			if encontrei = False Then
				Begin
					ClrScr;
					textcolor(lightred);gotoxy(5,15);writeln('Os dados introduzidos nao foram encontrados em nossos registros.');
					textcolor(white);gotoxy(5,16);writeln('Clique enter para voltar ao menu');
					readln;
				end;
	end;
//------------------------------------------------------------------------
Procedure Eliminar_Func(var fich: arquivo2; idF: Integer; nomefunc:String);
	Begin
		ClrScr;
		Textcolor(blue);
		Textbackground(lightcyan);
		GotoXY(33,3);writeln('_REMOVER PERFIL DO FUNCIONARIO_');
		Textcolor(white);
		Textbackground(blue);
		gotoxy(10,8);write('ID do funcinonario: ');
		textcolor(yellow);readln(idF);textcolor(white);
		gotoxy(10,9);write('Nome do funcionario: ');
		textcolor(yellow);readln(nomefunc);textcolor(white);
		for up := 1 to Length(nomefunc)Do
			nomefunc[up] := upcase(nomefunc[up]);
		Assign(arq2, 'Funcionario.dat');
		Reset(arq2);
		for i := 0 to FileSize(arq2)-1 Do
			Begin
				Seek(arq2, i);
				Read(arq2, func);
				if(func.id = idF) and (func.nome = nomefunc)then
					begin
						Close(arq2);
						gotoxy(10,10);textcolor(white);writeln('Tem certeza de que deseja eliminar fucionario[S/N]?');
						tecla := readkey;
						tecla := upcase(tecla);
						if(tecla = 'S')then
							Begin
								Reset(arq2);
								Seek(arq2, i+1);
								while not Eof(arq2)Do
									Begin
										read(arq2, func);
										seek(arq2, FilePos(arq2)-2);
										write(arq2, func);
										Seek(arq2, FilePos(arq2)+1);
									end;
								Seek(arq2, FilePos(arq2)-1);
								Truncate(arq2);
								Close(arq2);
								encontrei := true;
								ClrScr;
								gotoxy(5,15);textcolor(lightgreen);Writeln('Usuario removido.');
                gotoxy(5,16);textcolor(white);Writeln('Click enter para voltar.');
                Readln;
							end
						else
							Begin
								if(tecla = 'N')then
									Begin
											ClrScr;
											encontrei := True;
											gotoxy(10,5);writeln('Operacao cancelada.');
											gotoxy(10,6);Writeln('Click enter para voltar.');
		                  Readln;
									end
								else RunError;
							end;
					end
				Else
					Begin
						ClrScr;
						gotoxy(8,5);textcolor(lightred);writeln('Funcionario nao registrado.');
						textcolor(white);gotoxy(8,6);writeln('Click enter para voltar.');
						readln;
					end;
			end;
	end;
//--------------------------------------
Procedure Wage_Func(var fich: arquivo2);
	Label
		behind, back, previous;
	var
		aumento, desconto, paumento, pdesconto,
		salario, salariototal, antigo: Real;
		nomefunc: String;
		Ahext, Dhext: Integer;

	Begin
		ClrScr;
		TEXTCOLOR(BLUE);
		TEXTBACKGROUND(LIGHTCYAN);
		gotoxy(35,2);writeln('_FOLHA DE AJUSTE SALARIAL_');
		TEXTCOLOR(WHITE);
		TEXTBACKGROUND(BLUE);
		GOTOXY(25,8);write('Nome do funcionario: ');
		textcolor(yellow);readln(nomefunc);textcolor(white);
		for up := 1 to Length(nomefunc)do
			 nomefunc[up] := Upcase(nomefunc[up]);
		Assign(arq2, 'Funcionario.dat');
		reset(arq2);
		for i := 0 to FileSize(arq2)-1 do
			Begin
				Seek(arq2, i);
				Read(arq2, func);
				if(func.nome = nomefunc)then
					Begin
						behind:
						ClrScr;
						writeln('ID: ', func.id);
						writeln('NOME: ', func.nome);
						writeln('DATA DE NASCIMENTO: ', func.nasc);
						writeln('BILHETE DE IDENTIDADE: ', func.bi);
						writeln('SEXO: ', func.sexo);
						writeln('CARGO: ', func.cargo);
						writeln('SALARIO: ', func.salario:2:2,'MZN');
						writeln('CELULAR: ', func.cel[1]);
						writeln('CELULAR ALTERNATIVO: ', func.cel[2]);
						writeln('Email: ', func.email);
						writeln('---------------------------------');
						writeln('[1] Aumento salarial.');
						writeln('[2] Desconto salarial.');
						writeln('[3] Voltar');
						write('>>> ');
						readln(option);
						case(option)of
							1: Begin
										back:
										ClrScr;
										Assign(arq2, 'Funcionario.dat');
										reset(arq2);
										ReWrite(arq2);
										gotoxy(25,8);writeln('[1] Por horas extras de trabalho.');
										gotoxy(25,9);writeln('[2] Por percentagem.');
										gotoxy(25,10);writeln('[3] Voltar');
										gotoxy(25,12);write('>>> ');
										readln(option);
										case(option)of
											1: Begin
														ClrScr;
														gotoxy(25,8);writeln('[1] 1 Hora.');
														gotoxy(25,9);writeln('[2] 2 Horas.');
														gotoxy(25,10);writeln('[3] 3 Horas.');
														gotoxy(25,11);writeln('[4] Outras Horas.');
														gotoxy(25,12);writeln('[5] Voltar');
														gotoxy(25,13);write('>>> ');
														readln(option);
														case(option)Of
															1: Begin
																		ClrScr;
																		func.Ahext := 1;
																		func.salariototal := (func.salario * (1 + 6.5/100)) + 250 * func.Ahext;
																		func.aumento  := func.salariototal - func.salario;
																		func.salario := func.salariototal;
																		func.antigo := func.salario - func.aumento;
																		gotoxy(10,5);writeln('---------------------------------');
																		gotoxy(10,6);Writeln('Antigo Salario: ',func.antigo:2:2,' MZN');
											              gotoxy(10,7);Writeln('Aumento Salarial: ',func.aumento:2:2,' MZN');
											              gotoxy(10,8);Writeln('Novo Salario: ',func.salariototal:2:2,' MZN');
																		gotoxy(10,9);writeln('---------------------------------');
																		gotoxy(10,10);writeln('Clique enter para voltar ao menu.');
																		readln;
															   end;
															2: Begin
																		ClrScr;
																		func.Ahext := 2;
																		func.salariototal := (func.salario * (1 + 13/100)) + 250 * func.Ahext;
																		func.aumento  := func.salariototal - func.salario;
																		func.salario := func.salariototal;
																		func.antigo := func.salario - func.aumento;
																		gotoxy(10,5);writeln('---------------------------------');
																		gotoxy(10,6);Writeln('Antigo Salario: ',func.antigo:2:2,' MZN');
											              gotoxy(10,7);Writeln('Aumento Salarial: ',func.aumento:2:2,' MZN');
											              gotoxy(10,8);Writeln('Novo Salario: ',func.salariototal:2:2,' MZN');
																		gotoxy(10,9);writeln('---------------------------------');
																		gotoxy(10,10);writeln('Clique enter para voltar ao menu.');
																		readln;
																 end;
															3: Begin
																		ClrScr;
																		func.Ahext := 3;
																		func.salariototal := (func.salario * (1 + 19.5/100)) + 250 * func.Ahext;
																		func.aumento  := func.salariototal - func.salario;
																		func.salario := func.salariototal;
																		func.antigo := func.salario - func.aumento;
																		gotoxy(10,5);writeln('---------------------------------');
																		gotoxy(10,6);Writeln('Antigo Salario: ',func.antigo:2:2,' MZN');
											              gotoxy(10,7);Writeln('Aumento Salarial: ',func.aumento:2:2,' MZN');
											              gotoxy(10,8);Writeln('Novo Salario: ',func.salariototal:2:2,' MZN');
																		gotoxy(10,9);writeln('---------------------------------');
																		gotoxy(10,10);writeln('Clique enter para voltar ao menu.');
																		readln;
																 end;
															4: Begin
																		ClrScr;
																		gotoxy(10,8);writeln('Quantas horas extras de trabalho?');
																		gotoxy(10,9);write('>>> ');
																		readln(func.Ahext);
																		func.salariototal := (func.salario * (1 + 19.5/100)) + 250 * func.Ahext;
																		func.aumento  := func.salariototal - func.salario;
																		func.salario := func.salariototal;
																		func.antigo := func.salario - func.aumento;
																		ClrScr;
																		gotoxy(10,5);writeln('---------------------------------');
																		gotoxy(10,6);Writeln('Antigo Salario: ',func.antigo:2:2,' MZN');
											              gotoxy(10,7);Writeln('Aumento Salarial: ',func.aumento:2:2,' MZN');
											              gotoxy(10,8);Writeln('Novo Salario: ',func.salariototal:2:2,' MZN');
																		gotoxy(10,9);writeln('---------------------------------');
																		gotoxy(10,10);writeln('Clique enter para voltar ao menu.');
																		readln;
																 end;
															5: goto back;
														end;
												 end;
											2: Begin
														ClrScr;
														gotoxy(25,8);writeln('[1] 10 %.');
														gotoxy(25,9);writeln('[2] 20 %.');
														gotoxy(25,10);writeln('[3] 30 %.');
														gotoxy(25,11);writeln('[4] Outras %.');
														gotoxy(25,12);writeln('[5] Voltar');
														gotoxy(25,13);write('>>> ');
														readln(option);
														case(option)Of
															1: Begin
																		ClrScr;
																		func.salariototal := func.salario * 1.1;
																		func.paumento := 10;
																		func.aumento  := func.salariototal - func.salario;
																		func.salario := func.salariototal;
																		func.antigo := func.salario - func.aumento;
																		gotoxy(10,5);writeln('---------------------------------');
																		gotoxy(10,6);Writeln('Antigo Salario: ',func.antigo:2:2,' MZN');
											              gotoxy(10,7);Writeln('Aumento Salarial: ',func.aumento:2:2,' MZN');
											              gotoxy(10,8);Writeln('Novo Salario: ',func.salariototal:2:2,' MZN');
																		gotoxy(10,9);writeln('---------------------------------');
																		gotoxy(10,10);writeln('Clique enter para voltar ao menu.');
																		readln;
																 end;
															2: Begin
																		ClrScr;
																		func.salariototal := func.salario * 1.2;
																		func.paumento := 20;
																		func.aumento  := func.salariototal - func.salario;
																		func.salario := func.salariototal;
																		func.antigo := func.salario - func.aumento;
																		gotoxy(10,5);writeln('---------------------------------');
																		gotoxy(10,6);Writeln('Antigo Salario: ',func.antigo:2:2,' MZN');
											              gotoxy(10,7);Writeln('Aumento Salarial: ',func.aumento:2:2,' MZN');
											              gotoxy(10,8);Writeln('Novo Salario: ',func.salariototal:2:2,' MZN');
																		gotoxy(10,9);writeln('---------------------------------');
																		gotoxy(10,10);writeln('Clique enter para voltar ao menu.');
																		readln;
																 end;
															3: Begin
																		ClrScr;
																		func.salariototal := func.salario * 1.3;
																		func.paumento := 30;
																		func.aumento  := func.salariototal - func.salario;
																		func.salario := func.salariototal;
																		func.antigo := func.salario - func.aumento;
																		gotoxy(10,5);writeln('---------------------------------');
																		gotoxy(10,6);Writeln('Antigo Salario: ',func.antigo:2:2,' MZN');
											              gotoxy(10,7);Writeln('Aumento Salarial: ',func.aumento:2:2,' MZN');
											              gotoxy(10,8);Writeln('Novo Salario: ',func.salariototal:2:2,' MZN');
																		gotoxy(10,9);writeln('---------------------------------');
																		gotoxy(10,10);writeln('Clique enter para voltar ao menu.');
																		readln;
																 end;
															4: Begin
																		ClrScr;
																		gotoxy(10,8);writeln('Quanto sera o aumento percentual?');
																		gotoxy(10,9);write('>>> ');
																		readln(func.paumento);
																		func.salariototal := func.salario * (1 +(func.paumento)/100);
																		func.aumento  := func.salariototal - func.salario;
																		func.salario := func.salariototal;
																		func.antigo := func.salario - func.aumento;
																		ClrScr;
																		gotoxy(10,5);writeln('---------------------------------');
																		gotoxy(10,6);Writeln('Antigo Salario: ',func.antigo:2:2,' MZN');
											              gotoxy(10,7);Writeln('Aumento Salarial: ',func.aumento:2:2,' MZN');
											              gotoxy(10,8);Writeln('Novo Salario: ',func.salariototal:2:2,' MZN');
																		gotoxy(10,9);writeln('---------------------------------');
																		gotoxy(10,10);writeln('Clique enter para voltar ao menu.');
																		readln;
																 End;
															5: goto back;
														end;
												 end;
											3: goto behind
											Else goto back;
										end;
								 end;
							2: Begin
										previous:
										ClrScr;
										Assign(arq2, 'Funcionario.dat');
										reset(arq2);
										ReWrite(arq2);
										gotoxy(25,8);writeln('[1] Por horas extras de trabalho.');
										gotoxy(25,9);writeln('[2] Por percentagem.');
										gotoxy(25,10);writeln('[3] Voltar');
										gotoxy(25,11);write('>>> ');
										readln(option);
										case(option)of
											1: Begin
														ClrScr;
														gotoxy(25,8);writeln('[1] 1 Hora');
														gotoxy(25,9);writeln('[2] 2 Horas');
														gotoxy(25,10);writeln('[3] 3 Horas');
														gotoxy(25,11);writeln('[4] Outras Horas');
														gotoxy(25,12);writeln('[5] Voltar');
														gotoxy(25,13);write('>>> ');
														readln(option);
														case(option)Of
															1: Begin
																		ClrScr;
																		func.Dhext := 1;
																		func.salariototal := (func.salario * (1 + 6.5/100)) - 250 * func.Dhext;
																		func.desconto  := func.salariototal - func.salario;
																		func.salario := func.salariototal;
																		func.antigo := func.salario + func.desconto;
																		gotoxy(10,5);writeln('---------------------------------');
																		gotoxy(10,6);Writeln('Antigo Salario: ',func.antigo:2:2,' MZN');
											              gotoxy(10,7);Writeln('Desconto Salarial: ',func.desconto:2:2,' MZN');
											              gotoxy(10,8);Writeln('Novo Salario: ',func.salariototal:2:2,' MZN');
																		gotoxy(10,9);writeln('---------------------------------');
																		gotoxy(10,10);writeln('Clique enter para voltar ao menu.');
																		readln;
																 end;
															2: Begin
																		ClrScr;
																		func.Dhext := 2;
																		func.salariototal := (func.salario * (1 + 13/100)) - 250 * func.Dhext;
																		func.desconto  := func.salariototal - func.salario;
																		func.salario := func.salariototal;
																		func.antigo := func.salariototal + func.desconto;
																		gotoxy(10,5);writeln('---------------------------------');
																		gotoxy(10,6);Writeln('Antigo Salario: ',func.antigo:2:2,' MZN');
											              gotoxy(10,7);Writeln('Desconto Salarial: ',func.desconto:2:2,' MZN');
											              gotoxy(10,8);Writeln('Novo Salario: ',func.salariototal:2:2,' MZN');
																		gotoxy(10,9);writeln('---------------------------------');
																		gotoxy(10,10);writeln('Clique enter para voltar ao menu.');
																		readln;
																 end;
															3: Begin
																		ClrScr;
																		func.Dhext := 3;
																		func.salariototal := (func.salario * (1 + 19.5/100)) - 250 * func.Dhext;
																		func.desconto  := func.salariototal - func.salario;
																		func.salario := func.salariototal;
																		func.antigo := func.salariototal + func.desconto;
																		gotoxy(10,5);writeln('---------------------------------');
																		gotoxy(10,6);Writeln('Antigo Salario: ',func.antigo:2:2,' MZN');
											              gotoxy(10,7);Writeln('Desconto Salarial: ',func.desconto:2:2,' MZN');
											              gotoxy(10,8);Writeln('Novo Salario: ',func.salariototal:2:2,' MZN');
																		gotoxy(10,9);writeln('---------------------------------');
																		gotoxy(10,10);writeln('Clique enter para voltar ao menu.');
																		readln;
																 end;
															4: Begin
																		ClrScr;
																		gotoxy(10,5);writeln('Quantas horas extras de trabalho?');
																		gotoxy(10,6);write('>>> ');
																		readln(func.Dhext);
																		func.salariototal := (func.salario * (1 + 6.5/100)) - 250 * func.Dhext;
																		func.desconto  := func.salariototal - func.salario;
																		func.salario := func.salariototal;
																		func.antigo := func.salario + func.desconto;
																		ClrScr;
																		gotoxy(10,5);writeln('---------------------------------');
																		gotoxy(10,6);Writeln('Antigo Salario: ',func.antigo:2:2,' MZN');
											              gotoxy(10,7);Writeln('Desconto Salarial: ',func.desconto:2:2,' MZN');
											              gotoxy(10,8);Writeln('Novo Salario: ',func.salariototal:2:2,' MZN');
																		gotoxy(10,9);writeln('---------------------------------');
																		gotoxy(10,10);writeln('Clique enter para voltar ao menu.');
																		readln;
																 end;
															5: goto previous;
														end;
												 end;
											2: Begin
														ClrScr;
														gotoxy(25,8);writeln('[1] 10 %.');
														gotoxy(25,9);writeln('[2] 20 %.');
														gotoxy(25,10);writeln('[3] 30 %.');
														gotoxy(25,11);writeln('[4] Outras %.');
														gotoxy(25,12);writeln('[5] Voltar');
														gotoxy(25,13);write('>>> ');
														readln(option);
														case(option)Of
															1: Begin
																		ClrScr;
																		func.salariototal := func.salario * 0.9;
																		func.pdesconto := 10;
																		func.desconto  := func.salariototal - func.salario;
																		func.salario := func.salariototal;
																		func.antigo := func.salariototal - func.desconto;
																		gotoxy(10,5);writeln('---------------------------------');
																		gotoxy(10,6);Writeln('Antigo Salario: ',func.antigo:2:2,' MZN');
											              gotoxy(10,7);Writeln('Desconto Salarial: ',func.desconto:2:2,' MZN');
											              gotoxy(10,8);Writeln('Novo Salario: ',func.salariototal:2:2,' MZN');
																		gotoxy(10,9);writeln('---------------------------------');
																		gotoxy(10,10);writeln('Clique enter para voltar ao menu.');
																		readln;
																 end;
															2: Begin
																		ClrScr;
																		func.salariototal := func.salario * 0.8;
																		func.pdesconto := 20;
																		func.desconto  := func.salariototal - func.salario;
																		func.salario := func.salariototal;
																		func.antigo := func.salariototal - func.desconto;
																		gotoxy(10,5);writeln('---------------------------------');
																		gotoxy(10,6);Writeln('Antigo Salario: ',func.antigo:2:2,' MZN');
											              gotoxy(10,7);Writeln('Desconto Salarial: ',func.desconto:2:2,' MZN');
											              gotoxy(10,8);Writeln('Novo Salario: ',func.salariototal:2:2,' MZN');
																		gotoxy(10,9);writeln('---------------------------------');
																		gotoxy(10,10);writeln('Clique enter para voltar ao menu.');
																		readln;
																 end;
															3: Begin
																		ClrScr;
																		func.salariototal := func.salario * 0.7;
																		func.pdesconto := 30;
																		func.desconto  := func.salariototal - func.salario;
																		func.salario := func.salariototal;
																		func.antigo := func.salariototal - func.desconto;
																		gotoxy(10,5);writeln('---------------------------------');
																		gotoxy(10,6);Writeln('Antigo Salario: ',func.antigo:2:2,' MZN');
											              gotoxy(10,7);Writeln('Desconto Salarial: ',func.desconto:2:2,' MZN');
											              gotoxy(10,8);Writeln('Novo Salario: ',func.salariototal:2:2,' MZN');
																		gotoxy(10,9);writeln('---------------------------------');
																		gotoxy(10,10);writeln('Clique enter para voltar ao menu.');
																		readln;
																 end;
															4: Begin
																		ClrScr;
																		gotoxy(10,5);writeln('Quanto sera o desconto percentual?');
																		gotoxy(10,6);write('>>> ');
																		readln(func.pdesconto);
																		func.salariototal := func.salario * (1 -(func.pdesconto)/100);
																		func.desconto  := func.salariototal - func.salario;
																		func.salario := func.salariototal;
																		func.antigo := func.salario - func.desconto;
																		ClrScr;
																		gotoxy(10,5);writeln('---------------------------------');
																		gotoxy(10,6);Writeln('Antigo Salario: ',func.antigo:2:2,' MZN');
											              gotoxy(10,7);Writeln('Desconto Salarial: ',func.desconto:2:2,' MZN');
											              gotoxy(10,8);Writeln('Novo Salario: ',func.salariototal:2:2,' MZN');
																		gotoxy(10,9);writeln('---------------------------------');
																		gotoxy(10,10);writeln('Clique enter para voltar ao menu.');
																		readln;
																 End;
															5: goto previous;
														end;
												 end;
											3: goto behind
											else goto previous;
										end;
										antigo := func.antigo;
										aumento := func.aumento;
										desconto := func.desconto;
										paumento := func.paumento;
										pdesconto := func.pdesconto;
										Ahext := func.Ahext;
										Dhext := func.Dhext;
										salario:= func.salario;
										salariototal := func.salariototal;
								 end;
							3: read
							Else goto behind;
						end;
						Seek(arq2, i);
						write(arq2, func);
					end
				Else
					Begin
						ClrScr;
						textcolor(lightred);gotoxy(5,10);writeln('Funcionario nao registrado.');
						gotoxy(5,11);textcolor(white);writeln('Clique enter para voltar.');
						readln;
					end;
			end;
			Close(arq2);
	end;
//------------------------------------
Procedure Relatorio(var fich:arquivo2);
	Label
		back, previous, behind;
	Begin
		ClrScr;
		Assign(arq2, 'Funcionario.dat');
		Reset(arq2);
		while not Eof(arq2)do
			Begin
				read(arq2, func);
				back:
				ClrScr;
				textcolor(blue);
				textbackground(lightcyan);
				GOTOXY(30,3);writeln('_RELATORIO DO AJUSTE SALARIAL_');
				TEXTCOLOR(WHITE);
				TEXTBACKGROUND(BLUE);
				GOTOXY(20,9);writeln('[1] Aumento salarial');
				GOTOXY(20,10);writeln('[2] Desconto salarial');
				gotoxy(20,11);writeln('[3] Voltar');
				GOTOXY(20,12);writeln('----------------------');
				GOTOXY(20,13);write('>>> ');
				readln(option);
				case(option)of
					1: Begin
								behind:
								ClrScr;
								textcolor(blue);
								textbackground(lightcyan);
								GOTOXY(30,3);writeln('_RELATORIO DO AJUSTE SALARIAL_');
								TEXTCOLOR(WHITE);
								TEXTBACKGROUND(BLUE);
								GOTOXY(20,9);writeln('[1] Por hora extra de trabalho');
								GOTOXY(20,10);writeln('[2] Por percentagem');
								gotoxy(20,11);writeln('[3] Voltar');
								GOTOXY(20,12);writeln('----------------------');
								GOTOXY(20,13);write('>>> ');
								readln(option);
								Case(option)Of
									1: Begin
												ClrScr;
												textcolor(blue);
												textbackground(lightcyan);
												GOTOXY(30,3);writeln('_RELATORIO DO AUMENTO POR HORA EXTRA_');
												TEXTCOLOR(WHITE);
												TEXTBACKGROUND(BLUE);
												if(func.Ahext = 0)then
													Begin
														textcolor(lightred);gotoxy(15,10);writeln('Sem relatorio a ser apresentado.');
														gotoxy(10,11);textcolor(white);writeln('Clique enter para voltar ao menu.');
														readln;
													end
												Else
													Begin
														gotoxy(2,8);writeln('ID: ',func.id);
														gotoxy(2,9);writeln('NOME: ',func.nome);
														gotoxy(2,10);writeln('DATA DE NASCIMENTO: ', func.nasc);
														gotoxy(2,11);writeln('BILHETE DE IDENTIDADE: ',func.bi);
														gotoxy(2,12);writeln('SEXO: ', func.sexo);
														gotoxy(2,13);writeln('CARGO: ',func.cargo);
														gotoxy(2,14);writeln('CELULAR: ', func.cel[1]);
														gotoxy(2,15);writeln('CELULAR ALTERNATIVO: ', func.cel[2]);
														gotoxy(2,16);writeln('Email: ', func.email);
														gotoxy(2,17);writeln('---------------------------------');
														gotoxy(2,18);Writeln('Antigo Salario: ',func.antigo:2:2,' MZN');
														GOTOXY(2,19);writeln('Hora(as) extras de trabalho: ',func.Ahext:2, ' hora(as)');
							              gotoxy(2,20);Writeln('Aumento Salarial: ',func.aumento:2:2,' MZN');
							              gotoxy(2,21);Writeln('Novo Salario: ',func.salariototal:2:2,' MZN');
														gotoxy(2,22);writeln('---------------------------------');
														gotoxy(2,23);writeln('Clique enter para fechar o relatorio.');
														readln;
													end;
										 end;
									2: Begin
												ClrScr;
												textcolor(blue);
												textbackground(lightcyan);
												GOTOXY(30,3);writeln('_RELATORIO DO AUMENTO POR PERCENTAGEM_');
												TEXTCOLOR(WHITE);
												TEXTBACKGROUND(BLUE);
												if(func.paumento = 0)Then
													Begin
														textcolor(lightred);gotoxy(15,10);writeln('Sem relatorio a ser apresentado.');
														gotoxy(10,11);textcolor(white);writeln('Clique enter para voltar ao menu.');
														readln;
													End
												Else
													Begin
														gotoxy(2,8);writeln('ID: ',func.id);
														gotoxy(2,9);writeln('NOME: ',func.nome);
														gotoxy(2,10);writeln('DATA DE NASCIMENTO: ', func.nasc);
														gotoxy(2,11);writeln('BILHETE DE IDENTIDADE: ',func.bi);
														gotoxy(2,12);writeln('SEXO: ', func.sexo);
														gotoxy(2,13);writeln('CARGO: ',func.cargo);
														gotoxy(2,14);writeln('CELULAR: ', func.cel[1]);
														gotoxy(2,15);writeln('CELULAR ALTERNATIVO: ', func.cel[2]);
														gotoxy(2,16);writeln('Email: ', func.email);
														gotoxy(2,17);writeln('---------------------------------');
														gotoxy(2,18);Writeln('Antigo Salario: ',func.antigo:2:2,' MZN');
														GOTOXY(2,19);writeln('Percentual aumento: ',func.paumento:2:2, ' %');
							              gotoxy(2,20);Writeln('Aumento Salarial: ',func.aumento:2:2,' MZN');
							              gotoxy(2,21);Writeln('Novo Salario: ',func.salariototal:2:2,' MZN');
														gotoxy(2,22);writeln('---------------------------------');
														gotoxy(2,23);writeln('Clique enter para fechar o relatorio');
														readln;
													end;
										 end;
									3: goto back;
									else goto behind;
								end;
						 end;
					2: Begin
								previous:
								ClrScr;
								textcolor(blue);
								textbackground(lightcyan);
								GOTOXY(30,3);writeln('_RELATORIO DO AJUSTE SALARIAL_');
								TEXTCOLOR(WHITE);
								TEXTBACKGROUND(BLUE);
								GOTOXY(20,9);writeln('[1] Por hora extra de trabalho.');
								GOTOXY(20,10);writeln('[2] Por percentagem.');
								gotoxy(20,11);writeln('[3] Voltar');
								GOTOXY(20,12);writeln('----------------------');
								GOTOXY(20,13);write('>>> ');
								readln(option);
								Case(option)Of
									1: Begin
												ClrScr;
												textcolor(blue);
												textbackground(lightcyan);
												GOTOXY(30,3);writeln('_RELATORIO DO DESCONTO POR HORAS A MENOS_');
												TEXTCOLOR(WHITE);
												TEXTBACKGROUND(BLUE);
												if(func.Dhext = 0)then
													Begin
														textcolor(lightred);gotoxy(15,10);writeln('Sem relatorio a ser apresentado.');
														gotoxy(10,11);textcolor(white);writeln('Clique enter para voltar ao menu.');
														readln;
													end
												Else
													Begin
														gotoxy(2,8);writeln('ID: ',func.id);
														gotoxy(2,9);writeln('NOME: ',func.nome);
														gotoxy(2,10);writeln('DATA DE NASCIMENTO: ', func.nasc);
														gotoxy(2,11);writeln('BILHETE DE IDENTIDADE: ',func.bi);
														gotoxy(2,12);writeln('SEXO: ', func.sexo);
														gotoxy(2,13);writeln('CARGO: ',func.cargo);
														gotoxy(2,14);writeln('CELULAR: ', func.cel[1]);
														gotoxy(2,15);writeln('CELULAR ALTERNATIVO: ', func.cel[2]);
														gotoxy(2,16);writeln('Email: ', func.email);
														gotoxy(2,17);writeln('---------------------------------');
														gotoxy(2,18);Writeln('Antigo Salario: ',func.antigo:2:2,' MZN');
														GOTOXY(2,19);writeln('Hora(as) a menos de trabalho: ',func.Dhext:2, ' hora(as)');
							              gotoxy(2,20);Writeln('Desconto Salarial: ',func.desconto:2:2,' MZN');
							              gotoxy(2,21);Writeln('Novo Salario: ',func.salariototal:2:2,' MZN');
														gotoxy(2,22);writeln('---------------------------------');
														gotoxy(2,23);writeln('Clique enter para fechar o relatorio.');
														readln;
													end;
										 END;
									2: Begin
												ClrScr;
												textcolor(blue);
												textbackground(lightcyan);
												GOTOXY(30,3);writeln('_RELATORIO DO DESCONTO POR PERCENTAGEM_');
												TEXTCOLOR(WHITE);
												TEXTBACKGROUND(BLUE);
												if(func.pdesconto = 0)Then
													Begin
														textcolor(lightred);gotoxy(15,10);writeln('Sem relatorio a ser apresentado.');
														gotoxy(10,11);textcolor(white);writeln('Clique enter para voltar ao menu.');
														readln;
													end
												Else
													Begin
														gotoxy(2,8);writeln('ID: ',func.id);
														gotoxy(2,9);writeln('NOME: ',func.nome);
														gotoxy(2,10);writeln('DATA DE NASCIMENTO: ', func.nasc);
														gotoxy(2,11);writeln('BILHETE DE IDENTIDADE: ',func.bi);
														gotoxy(2,12);writeln('SEXO: ', func.sexo);
														gotoxy(2,13);writeln('CARGO: ',func.cargo);
														gotoxy(2,14);writeln('CELULAR: ', func.cel[1]);
														gotoxy(2,15);writeln('CELULAR ALTERNATIVO: ', func.cel[2]);
														gotoxy(2,16);writeln('Email: ', func.email);
														gotoxy(2,17);writeln('---------------------------------');
														gotoxy(2,18);Writeln('Antigo Salario: ',func.antigo:2:2,' MZN');
														GOTOXY(2,19);writeln('Percentual desconto: ',func.pdesconto:2:2, ' %');
							              gotoxy(2,20);Writeln('Desconto Salarial: ',func.desconto:2:2,' MZN');
							              gotoxy(2,21);Writeln('Novo Salario: ',func.salariototal:2:2,' MZN');
														gotoxy(2,22);writeln('---------------------------------');
														gotoxy(2,23);writeln('Clique enter para fechar o relatorio');
														readln;
													end;
										 END;
									3: goto back;
									else goto previous;
								end;
						 end;
					3: read;
					else RunError;
				end;
			end;
			Close(arq2);
	end;
//-----------------
Procedure Date_Time;//usar o delay(1) para repeticao
	Begin
		getdate(dia, mes, ano, weekday);
		gettime(hora, minuto, segundo, msegundo);
		Writeln('Data e Hora: ');
		Writeln(diadasemana[weekday],',',ano,'/', mesdoano[mes],'/',dia);
		Writeln(hora,':',minuto,':',segundo); //usar estrutura de repeticao (while i < Max do...)
	end;
//----------------------------------------------------------------------------
Function Verifica_Func(var fich: arquivo2; idF: Integer; nom:String): Boolean;
	Begin
		Assign(arq2, 'Funcionario.dat');
		Verifica_Func:= false;
		reset(arq2);
		while not Eof(arq2)do
			Begin
				read(arq2, func);
				with func do
				Begin
					if(func.id = idF) and (func.nome = nom)Then
						Begin
							Verifica_Func:= true;
						end;
				end;
			end;
			close(arq2);
	end;
{----Capa----}
procedure Design;
var i,j:integer;
begin
	J:=0;
	//textcolor(lightred);
	Textbackground(blue);
	ClrScr;
	textcolor(yellow);gotoxy(25,30);
	highvideo;Writeln('Developer: Carlos Macaneta');
	textcolor(white);
{----Letra W----}
  For i:=4 To 16 Do
	  Begin;
	    Gotoxy(4,i);
	    Write(#232);
	  End;
  For i:=4 To 6 Do
	  Begin;
	    Gotoxy(i,16);
	    Write(#232);
	  End;
  For i:=8 To 16 Do
	  Begin;
	    Gotoxy(6,i);
	    Write(#232);
	  End;
  For i:= 6 To 8 Do
	  Begin;
	    Gotoxy(i,7);
	    Write(#232);
	  End;
	For i:=8 To 16 Do
	  Begin;
	    Gotoxy(8,i);
	    Write(#232);
	  End;
	For i:=9 To 10 Do
	  Begin;
	    Gotoxy(i,16);
	    Write(#232);
	  End;
	For i:=4 To 16 Do
	  Begin;
	    Gotoxy(10,i);
	    Write(#232);
	  End;
{----Letra G----}
	For i:=12 To 17 Do
	  Begin;
	    Gotoxy(14,i);
	    Write(#232);
	  End;
	For i:= 14 To 22 Do
	  Begin;
	    Gotoxy(i,12);
	    Write(#232);
	  End;
	For i:=14 To 22 Do
	  Begin;
	    Gotoxy(i,18);
	    Write(#232);
	  End;
	For i:=12 To 26 Do
	  Begin;
	    Gotoxy(22,i);
	    Write(#232);
	  End;
	For i:=14 To 22 Do
	  Begin;
	    Gotoxy(i,27);
	    Write(#232);
	  End;
	For i:= 26 To 27 Do
	  Begin;
	    Gotoxy(14,i);
	    Write(#232);
	  End;
{----Letra M----}
	For i:=4 To 16 Do
	  Begin;
	    Gotoxy(25,i);
	    Write(#232);
	  End;
	For i:= 26 To 26 Do
	  Begin;
	    Gotoxy(i,4);
	    Write(#232);
	  End;
	For i:= 4 To 13 Do
	  Begin;
	    Gotoxy(27,i);
	    Write(#232);
	  End;
	For i:= 28 To 28 Do
	  Begin;
	    Gotoxy(i,13);
	    Write(#232);
	  End;
	For i:= 4 To 13 Do
	  Begin;
	    Gotoxy(29,i);
	    Write(#232);
	  End;
	For i:= 30 To 30 Do
	  Begin;
	    Gotoxy(i,4);
	    Write(#232);
	  End;
	For i:=4 To 16 Do
	  Begin;
	    Gotoxy(31,i);
	    Write(#232);
	  End;
end;
//----------------
Procedure Progress;
Var
  i: Integer;
Begin
  Gotoxy(37,12);
  textcolor(yellow);
  Writeln('WageMath');
  For i:=17 To 25 Do
    Begin
      Gotoxy(37,13);
      textcolor(lightgray);
      writeln('Corporation');
      Gotoxy(i+20,15);
      textcolor(lightgreen);
    	Write(#249);
      delay(130);
    End;
	textcolor(white);
	Design;
  For i:=25 Downto 17 Do
    Begin
      Gotoxy(37,12);
      textcolor(yellow);
      Writeln('WageMath');
      Gotoxy(37,13);
      textcolor(lightgreen);
      Writeln('Loading');
      Gotoxy(i+20,15);
      textcolor(yellow);
      Write(#249);
      delay(110);
    End;
  textcolor(white);
	Design;
  For i:=17 To 25 Do
    Begin
      Gotoxy(37,12);
      textcolor(yellow);
      Writeln('WageMath');
      Gotoxy(37,13);
      textcolor(lightgreen);
      Writeln('Welcome to WageMath');
      Gotoxy(i+20,15);
      textcolor(lightred);
      Write(#249);
      delay(100);
    End;
End;
//-------------------
Procedure Progress_Bar;
var
	i, j: Integer;
Begin
j:=0;
ClrScr;
textcolor(white);
gotoxy(32,12);writeln('Aguarde Por favor...');
Textbackground(lightblue);
	for i := 30 to 54 do
		Begin
	    j:=j+4;
	    Gotoxy(41,14);
	    textcolor(white);
	    Writeln(j,'%');
	    Gotoxy(i,13);
	    textcolor(Black);
	    Write(#175);
	    delay(30);
		end;
		textcolor(white);
End;
{----Programa principal----}
Begin
	highvideo;
	Design;
	Progress;
	start:
	Textcolor(white);
  Textbackground(blue);
	ClrScr;
  Textcolor(blue);
  Textbackground(lightcyan);
  gotoxy(26,3);Writeln('_BEM VINDO AO MENU INICIAL_');
  Textcolor(white);
  Textbackground(blue);
	textcolor(yellow);gotoxy(2,30);
	lowvideo;writeln('Developer: Carlos Macaneta');
	normvideo;window(1,1, 255, 255);textbackground(blue);
	textcolor(white);
	gotoxy(25,10);writeln('  [1] Iniciar sessao              ');
	gotoxy(25,11);writeln('  [2] Criar usuario               ');
	gotoxy(25,12);writeln('  [3] Opcoes                      ');
	gotoxy(25,13);writeln('  [4] Sair                        ');
	gotoxy(25,14);writeln('==================================');
	gotoxy(25,15);write('>>> ');
	readln(option);
	case(option)of
		1: Begin
					Assign(arq1, 'Utilizador.dat');
					Existe_Util(arq1);
					if(Existe_Util(arq1) = true)then
						Begin
							 login:
							 ClrScr;
					     Textcolor(blue);
			         Textbackground(lightcyan);
			         gotoxy(33,3);Writeln('_LOGIN DO ADMIN_');
			         Textcolor(white);
			         Textbackground(blue);
							 gotoxy(25,12);write('Username: ');
							 textcolor(lightgreen);readln(user);textcolor(white);
							 for up := 1 to Length(user)do
							 	user[up] := upcase(user[up]);
							gotoxy(25,13);write('Password: ');
							textcolor(lightgreen);readln(pass);
							for up := 1 to Length(pass)do
								pass[up] := upcase(pass[up]);
							Assign(arq1, 'Utilizador.dat');
							Reset(arq1);
							for i:= 0 to FileSize(arq1)-1 do
								Begin
									Seek(arq1, i);
									Read(arq1, admin);
									if(admin.username = user)and(admin.password = pass)then
										Begin
												Progress_Bar;
												menu:
												Clrscr;
												Textcolor(blue);
		       							Textbackground(lightcyan);
											  Gotoxy(33,3);Writeln ('_MENU PRINCIPAL_');
												Textcolor(white);
		       							Textbackground(blue);
												getdate(dia, mes, ano, weekday);
												gettime(hora, minuto, segundo, msegundo);
												gotoxy(5,5);writeln('My ID: ', admin.id);
												gotoxy(38,5);Writeln(hora,':',minuto);
												gotoxy(61,5);Writeln(diadasemana[weekday],',',ano,'/', mesdoano[mes],'/',dia);
					              Gotoxy(25,12);Writeln('[1] GERENCIAR FUNCIONARIOS');
					              Gotoxy(25,13);Writeln('[2] FOLHA DE AJUSTE SALARIAL');
												Gotoxy(25,14);writeln('[3] RELATORIO');
					              Gotoxy(25,15);Writeln('[4] VOLTAR AO MENU INICIAL');
					              Gotoxy(25,16);writeln('---------------------------');
												gotoxy(25,17);write('>>> ');
												readln(option);
												case(option)of
													1: Begin
																menufunc:
																Clrscr;
																Textcolor(blue);
					         							Textbackground(lightcyan);
															  Gotoxy(32,2);
															  Writeln ('_MENU FUNCIONARIO_');
																Textcolor(white);
					         							Textbackground(blue);
																Gotoxy(25,10);Writeln('[1] REGISTRAR FUNCIONARIO');
																Gotoxy(25,11);Writeln('[2] EDITAR PERFIL DO FUNCIONARIO');
																Gotoxy(25,12);Writeln('[3] REMOVER PERFIL DO FUNCIONARIO');
																Gotoxy(25,13);Writeln('[4] PESQUISAR FUNCIONARIO POR ID');
																Gotoxy(25,14);Writeln('[5] PESQUISAR FUNCIONARIO POR NOME');
																Gotoxy(25,15);Writeln('[6] VER PERFIL DE TODOS FUNCIONARIOS');
																Gotoxy(25,16);Writeln('[7] VOLTAR');
																gotoxy(25,17);WriteLn('---------------------------------------');
																gotoxy(25,18);write('>>> ');
																readln(option);
																case(option)Of
																	1: Begin
																				Assign(arq2, 'Funcionario.dat');
																				Existe_Func(arq2);
																				if(Existe_Func(arq2) = true)then
																					Begin
																						ClrScr;
																						Assign(arq2, 'Funcionario.dat');
																						Adicionar_Func(arq2);
																						Progress_Bar;
																						ClrScr;
																						textcolor(lightgreen);gotoxy(20,15);writeln('Funcionario registrado com sucesso.');
																						textcolor(white);gotoxy(20,16);writeln('Clique enter para voltar ao menu');
																						readln; goto menufunc;
																					End
																				Else
																					Begin
																						ClrScr;
																						Assign(arq2, 'Funcionario.dat');
																						Registro_Func(arq2);
																						ClrScr;
																						textcolor(lightgreen);gotoxy(20,15);writeln('Funcionario registrado com sucesso.');
																						textcolor(white);gotoxy(20,16);writeln('Clique enter para voltar ao menu');
																						readln; goto menufunc;
																					end;
																		 end;
																	2: Begin
																				Assign(arq2, 'Funcionario.dat');
																				Existe_Func(arq2);
																				if(Existe_Func(arq2) = true) then
																					Begin
																						ClrScr;
																						Assign(arq2, 'Funcionario.dat');
																						AlterarPerfil_Func(arq2, idF, nomefunc);
																						goto menufunc;
																					end
																				Else
																					Begin
																						Progress_Bar;
																						ClrScr;
																						textcolor(lightred);gotoxy(5,15);writeln('Sem registro de funcionarios em nosso sistema.');
																						textcolor(white);gotoxy(5,16);writeln('Clique enter para voltar ao menu');
																						readln; goto menufunc;
																					end;
																		 end;
																	3: Begin
																				Assign(arq2, 'Funcionario.dat');
																				Existe_Func(arq2);
																				if(Existe_Func(arq2) = true)then
																					Begin
																						ClrScr;
																						Assign(arq2, 'Funcionario.dat');
																						Eliminar_Func(arq2, idF, nomefunc);
																						goto menufunc;
																					End
																				else
																					Begin
																						Progress_Bar;
																						ClrScr;
																						textcolor(lightred);gotoxy(20,15);writeln('Sem registro de funcionarios em nosso sistema.');
																						textcolor(white);gotoxy(20,16);writeln('Clique enter para voltar ao menu');
																						readln; goto menufunc;
																					end;
																		 end;
																	4: Begin
																				Assign(arq2, 'Funcionario.dat');
																				Existe_Func(arq2);
																				if(Existe_Func(arq2) = true)then
																					Begin
																						ClrScr;
																						Assign(arq2, 'Funcionario.dat');
																						PesquisaID_Func(arq2, idF);
																						goto menufunc;
																					End
																				Else
																					Begin
																						Progress_Bar;
																						ClrScr;
																						textcolor(lightred);gotoxy(20,15);writeln('Sem registro de funcionarios em nosso sistema.');
																						textcolor(white);gotoxy(20,16);writeln('Clique enter para voltar ao menu');
																						readln; goto menufunc;
																					end;
																		 end;
																	5: Begin
																				Assign(arq2, 'Funcionario.dat');
																				Existe_Func(arq2);
																				if(Existe_Func(arq2) = true)then
																					Begin
																					   ClrScr;
																						 Assign(arq2, 'Funcionario.dat');
																						 PesquisaNome_Func(arq2, nomefunc);
																						 goto menufunc;
																					End
																				Else
																					Begin
																						Progress_Bar;
																						ClrScr;
																						textcolor(lightred);gotoxy(5,15);writeln('Sem registro de funcionarios em nosso sistema.');
																						textcolor(white);gotoxy(5,16);writeln('Clique enter para voltar ao menu');
																						readln; goto menufunc;
																					end;
																		 end;
																	6: Begin
																				Assign(arq2, 'Funcionario.dat');
																				Existe_Func(arq2);
																				if(Existe_Func(arq2) = true)then
																					Begin
																						ClrScr;
																						Assign(arq2, 'Funcionario.dat');
																						listar_Func(arq2);
																						writeln('Clique enter para voltar ao menu.');
																						readln; goto menufunc;
																					End
																				Else
																					Begin
																						Progress_Bar;
																						ClrScr;
																						textcolor(lightred);gotoxy(5,15);writeln('Sem registro de funcionarios em nosso sistema.');
																						textcolor(white);gotoxy(5,16);writeln('Clique enter para voltar ao menu');
																						readln; goto menufunc;
																					end;
																		 end;
																	7: goto menu;
																	else goto menufunc;
																end;
														 End;
													2: Begin
																ClrScr;
																Assign(arq2, 'Funcionario.dat');
																Existe_Func(arq2);
																if(Existe_Func(arq2) = true)then
																	Begin
																		ClrScr;
																		Assign(arq2, 'Funcionario.dat');
																		wage_Func(arq2);
																		goto menu;
																	end
																Else
																	Begin
																		Progress_Bar;
																		ClrScr;
																		textcolor(lightred);gotoxy(5,15);writeln('Sem registro de funcionarios em nosso sistema.');
																		textcolor(white);gotoxy(5,16);writeln('Clique enter para voltar ao menu');
																		readln; goto menu;
																	end;
														 end;
													3: Begin
																ClrScr;
																Assign(arq2, 'Funcionario.dat');
																Existe_Func(arq2);
																if(Existe_Func(arq2) = true)then
																	Begin
																		ClrScr;
																		Assign(arq2, 'Funcionario.dat');
																		Relatorio(arq2);
																		goto menu;
																	end
																Else
																	Begin
																		Progress_Bar;
																		ClrScr;
																		textcolor(lightred);gotoxy(5,15);writeln('Sem registro de funcionarios em nosso sistema.');
																		textcolor(white);gotoxy(5,16);writeln('Clique enter para voltar ao menu');
																		readln; goto menu;
																	end;
														 end;
													4: GOTO start
													else goto menu;
												end;
											encontrei:= true;
										End;encontrei:= False;
								end;
							Close(arq1);
							if(encontrei = false)then
								Begin
									gotoxy(25,12);textcolor(lightred);writeln('Username ou password incorrecto.');
									gotoxy(25,13);textcolor(white);writeln('Tentar novamente?[S/N]');
									tecla := readkey;
									tecla := upcase(tecla);
									if(tecla = 'S') then goto login
									else
										Begin
											If(tecla = 'N')then goto start
											else RunError;
										end;
								end;
						end
					else
						Begin
							Progress_Bar;
							ClrScr;
							gotoxy(5,12);textcolor(lightred);writeln('Sem administradores registrados');
							textcolor(white);gotoxy(5,13);writeln('Click Enter para voltar ao menu inicial.');
							readln;
							Goto start;
						end;
			 end;
		2: Begin
					Assign(arq1, 'Utilizador.dat');
					Existe_Util(arq1);
					if(Existe_Util(arq1) = true)then
						Begin
							ClrScr;
							Assign(arq1, 'Utilizador.dat');
							Adicionar_Util(arq1);
							Progress_Bar;
							ClrScr;
							gotoxy(25,12);textcolor(lightgreen);writeln('Administrador registrado com sucesso.');
							gotoxy(25,13);textcolor(white);writeln('Clique enter para voltar.');
							readln; goto start;
						End
					Else
						Begin
							ClrScr;
							Assign(arq1, 'Utilizador.dat');
							Registro_Util(arq1);
							Progress_Bar;
							ClrScr;
							gotoxy(25,12);textcolor(lightgreen);writeln('Administrador registrado com sucesso.');
							gotoxy(25,13);textcolor(white);writeln('Clique enter para voltar.');
							readln; goto start;
						end;
			 end;
		3: Begin
					opcoes:
					Assign(arq1, 'Utilizador.dat');
					Existe_Util(arq1);
					if(Existe_Util(arq1) = True)Then
						Begin
							ClrScr;
							TEXTCOLOR(BLUE);
							TEXTBACKGROUND(LIGHTCYAN);
							gotoxy(22,2);writeln('_OPCOES PARA  O ADMINITRADOR DO SISTEMA_');
							TEXTCOLOR(WHITE);
							TEXTBACKGROUND(BLUE);
							gotoxy(15,10);writeln('  [1] Consultar perfil do administrador  ');
							gotoxy(15,11);WriteLn('  [2] Remover perfil do administrador    ');
							gotoxy(15,12);writeln('  [3] Alterar perfi do administrador     ');
							gotoxy(15,13);writeln('  [4] Voltar ao menu incicial            ');
							gotoxy(15,14);writeln('=========================================');
							gotoxy(15,15);write('>>> ');
							readln(option);
							case(option)of
								1: Begin
											ClrScr;
											textcolor(blue);
											textbackground(lightcyan);
											gotoxy(30,2);writeln('_CONSULTAR PERFIL DO ADMINISTRADOR_');
											textcolor(white);
											textbackground(blue);
											GOTOXY(10,7);write('ID do administrador: ');
											textcolor(yellow);readln(idA);textcolor(white);
											gotoxy(10,8);write('Nome do administrador: ');
											textcolor(yellow);readln(nomeadmin);textcolor(white);
											for up := 1 to Length(nomeadmin) do
												nomeadmin[up] := upcase(nomeadmin[up]);
											gotoxy(10,9);write('Password: ');textcolor(yellow);
											readln(passadmin);textcolor(white);
											for up := 1 to Length(passadmin)do
												passadmin[up] := upcase(passadmin[up]);
											Assign(arq1, 'Utilizador.dat');
											reset(arq1);
											for i := 0 to FileSize(arq1)-1 do
												Begin
													Seek(arq1, i);
													Read(arq1, admin);
													if(admin.id = idA) and (admin.nome = nomeadmin) and (admin.password = passadmin)then
														Begin
															with admin do
																Begin
																	Progress_Bar;
																	ClrScr;
																	textcolor(blue);
																	textbackground(lightcyan);
																	gotoxy(34,3);writeln('_DADOS PESSOAIS_');
																	textcolor(white);
																	textbackground(blue);
																	gotoxy(10,7);writeln('ID: ', id);
																	gotoxy(10,8);writeln('NOME: ', nome);
																	gotoxy(10,9);writeln('DATA DE NASCIMENTO: ', nasc);
																	gotoxy(10,10);writeln('BILHETE DE IDENTIDADE: ', bi);
																	gotoxy(10,11);writeln('SEXO: ', sexo);
																	textcolor(blue);
																	textbackground(lightcyan);
																	gotoxy(29,13);writeln('_DADOS DE ACESSO AO SISTEMA_');
																	TEXTCOLOR(white);
																	textbackground(blue);
																	gotoxy(10,16);writeln('Username: ', username);
																	gotoxy(10,17);writeln('Password: ', password);
																	encontrei:= True;
																	gotoxy(10,18);writeln('-------------------------------');
																	gotoxy(10,19);writeln('Clique enter para voltar ');
																	readln; goto opcoes;
																	break;
																end;
														end; encontrei:= false;
												end;
											Close(arq1);
											if(encontrei = false)Then
												Begin
													Progress_Bar;
													ClrScr;
													textcolor(lightred);gotoxy(5,12);writeln('Os dados introduzidos nao foram encontrados em nosso sistema.');
													textcolor(white);gotoxy(5,13);writeln('Clique enter para voltar');
													readln; goto opcoes;
												end;
									 end;
								2: Begin
											ClrScr;
											textcolor(blue);
											textbackground(lightcyan);
											gotoxy(30,2);writeln('_REMOVER PERFIL DO ADMINISTRADOR_');
											textcolor(white);
											textbackground(blue);
											GOTOXY(15,8);write('ID do administrador: ');
											textcolor(yellow);readln(idA);textcolor(white);
											gotoxy(15,9);write('Nome do administrador: ');
											textcolor(yellow);readln(nomeadmin);textcolor(white);
											for up := 1 to Length(nomeadmin) do
												nomeadmin[up] := upcase(nomeadmin[up]);
											gotoxy(15,10);write('Password: ');textcolor(yellow);
											readln(passadmin);textcolor(white);
											for up := 1 to Length(passadmin)do
												passadmin[up] := upcase(passadmin[up]);
											Assign(arq1, 'Utilizador.dat');
											reset(arq1);
											FOR i := 0 to FileSize(arq1)-1 do
												Begin
													Seek(arq1, i);
													Read(arq1, admin);
													if(admin.id = idA) and (admin.nome = nomeadmin) and (admin.password = passadmin)then
														Begin
															close(arq1);
															textcolor(yellow);gotoxy(10,10);writeln('Tem certeza de que deseja remover administrador[S/N]?');
															tecla := readkey;
															tecla := Upcase(tecla);
															if(tecla = 'S')then
																Begin
																	Reset(arq1);
																	Seek(arq1, i+1);
																	while not Eof(arq1)do
																		Begin
																			Read(arq1, admin);
																			Seek(arq1, FilePos(arq1)-2);
																			write(arq1, admin);
																			Seek(arq1, FilePos(arq1)+1);
																		end;
																	Seek(arq1, FilePos(arq1)-1);
																	Truncate(arq1);
																	Close(arq1);
																	encontrei:= True;
																	Progress_Bar;
																	ClrScr;
																	gotoxy(5,10);textcolor(lightgreen);writeln('Administrador foi removido com sucesso.');
																	gotoxy(5,11);textcolor(white);writeln('Clique enter para voltar.');
																	readln; goto opcoes;
																	break;
																end
															Else
																Begin
																	if(tecla = 'N')then
																		Begin
																			Progress_Bar;
																			ClrScr;
																			encontrei:=true;
																			gotoxy(5,10);writeln('Operacao cancelada.');
																			gotoxy(5,11);Writeln('Click enter para voltar.');
                          						Readln;goto opcoes;
																			break;
																		end
																	else RunError;
																end;
														end
													else encontrei:= False;
												end;
												if(encontrei = false)then
													Begin
														Progress_Bar;
														ClrScr;
														textcolor(lightred);gotoxy(2,5);writeln('Os dados introduzidos nao foram encontrados em nosso sistema.');
														textcolor(white);gotoxy(2,6);writeln('Clique enter para voltar');
														readln; goto opcoes;
													end;
									 end;
								3: Begin
											apa:
											ClrScr;
											textcolor(blue);
											textbackground(lightcyan);
											gotoxy(30,2);writeln('_ALTERAR PERFIL DO ADMINISTRADOR_');
											textcolor(white);
											textbackground(blue);
											GOTOXY(15,8);writeln('[1] Alterar dados pessoais');
											gotoxy(15,9);writeln('[2] Alterar dados de acesso ao sistema');
											gotoxy(15,10);writeln('[3] Voltar');
											gotoxy(15,11);writeln('---------------------------------------');
											gotoxy(15,12);write('>>> ');
											readln(option);
											case(option)of
												1: Begin
															ClrScr;
															textcolor(blue);
															textbackground(lightcyan);
															gotoxy(30,2);writeln('_ALTERAR PERFIL DO ADMINISTRADOR_');
															textcolor(white);
															textbackground(blue);
															gotoxy(1,6);textcolor(yellow);writeln('NOTA: A data de nascimento, sexo e o n° de B.I sao dados que nao podem ser alterados');
															gotoxy(10,10);textcolor(white);write('Nome do administrador: ');textcolor(yellow);
															readln(nomeadmin);textcolor(white);
															for up := 1 to Length(nomeadmin)do
																nomeadmin[up] := Upcase(nomeadmin[up]);
															gotoxy(10,11);write('Password: ');textcolor(yellow);
															readln(passadmin);textcolor(white);
															for up := 1 to Length(passadmin)do
																passadmin[up] := upcase(passadmin[up]);
															Assign(arq1, 'Utilizador.dat');
															Reset(arq1);
															for i:= 0 to FileSize(arq1)-1 do
																Begin
																	if(admin.nome = nomeadmin) and (admin.password = passadmin)then
																		Begin
																			ClrScr;
																			textcolor(blue);
																			textbackground(lightcyan);
																			gotoxy(30,2);writeln('_ALTERAR PERFIL DO ADMINISTRADOR_');
																			textcolor(white);
																			textbackground(blue);
																			gotoxy(10,8);write('Nome completo: ');
																			textcolor(yellow);readln(admin.nome);textcolor(white);
																			for up := 1 to Length(admin.nome)do
																			admin.nome[up] := Upcase(admin.nome[up]);
																			Assign(arq1, 'Utilizador.dat');
																			Reset(arq1);
																			write(arq1, admin);
																			close(arq1);
																			Progress_Bar;
																			ClrScr;
																			gotoxy(10,8);textcolor(lightgreen);writeln('Dados alterados com sucesso.');
																			gotoxy(10,9);textcolor(white);writeln('Click enter para voltar.');
																			readln;
																			goto apa;
																		end
																	Else
																		Begin
																			Progress_Bar;
																			ClrScr;
																			gotoxy(5,15);textcolor(lightred);writeln('Os dados introduzudos nao foram encontrados em nosso sistema.');
																			gotoxy(5,16);textcolor(white);writeln('Clique enter para voltar.');
																			readln; goto apa;
																		end;
																end;
													 end;
												2: Begin
															ClrScr;
															textcolor(blue);
															textbackground(lightcyan);
															gotoxy(33,3);writeln('_ALTERAR DADOS DE ACESSO AO SISTEMA_');
															textcolor(white);
															textbackground(blue);
															GOTOXY(10,7);write('Nome: ');textcolor(yellow);
															readln(nomeadmin);textcolor(white);
															for up := 1 to Length(nomeadmin)do
																nomeadmin[up] := Upcase(nomeadmin[up]);
															gotoxy(10,7);write('Password: ');textcolor(yellow);
															readln(passadmin);textcolor(white);
															for up := 1 to Length(passadmin) do
																nomeadmin[up] := Upcase(nomeadmin[up]);
															Assign(arq1, 'Utilizador.dat');
															Reset(arq1);
															for i:=0 to FileSize(arq1)-1 do
																Begin
																	if(admin.nome = nomeadmin) and (admin.password = passadmin) Then
																		Begin
																			textcolor(blue);
																			textbackground(lightcyan);
																			gotoxy(33,3);writeln('_ALTERAR DADOS DE ACESSO AO SISTEMA_');
																			textcolor(white);
																			textbackground(blue);
																			gotoxy(5,6);textcolor(yellow);writeln('Introduza novos dados.');
																			gotoxy(10,8);write('Username: ');textcolor(yellow);
																			readln(admin.username);textcolor(white);
																			for up := 1 to Length(admin.username)do
																				admin.nome[up] := Upcase(admin.nome[up]);
																			gotoxy(10,9);write('Password: ');textcolor(yellow);
																			readln(admin.password);textcolor(white);
																			Assign(arq1, 'Utilizador.dat');
																			Reset(arq1);
																			write(arq1, admin);
																			Close(arq1);
																			Progress_Bar;
																			ClrScr;
																			textcolor(lightgreen);gotoxy(10,8);writeln('Dados alterados com sucesso.');
																			gotoxy(10,9);textcolor(white);writeln('Click enter para voltar.');
																			readln;goto apa;
																		End
																	Else
																		Begin
																			Progress_Bar;
																			ClrScr;
																			gotoxy(5,15);textcolor(lightred);writeln('Os dados introduzudos nao foram encontrados em nosso sistema.');
																			gotoxy(5,16);textcolor(white);writeln('Clique enter para voltar.');
																			readln; goto apa;
																		end;
																end;
													 end;
												3: goto opcoes
												else goto apa;
											end;
									 end;
								4: goto start
								else goto opcoes;
							end;
						End
					Else
						Begin
							Progress_Bar;
							ClrScr;
							textcolor(lightred);gotoxy(5,15);writeln('Sem administrador(es) registrado(s).');
							textcolor(white);gotoxy(5,16);writeln('Clique enter para voltar.');
							readln; goto start;
						end;
			 end;
		4: exit;
		else goto start;
	end;
end.