Program Gestao_Salarial;
uses crt, dos, Objects, classes;

Label
	inicio, login, menu_princ, menu_func;

Const
	SEMANAS: Array [0..6] of String = ('Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex'0, 'Sab');
	MESES: Array [1..12] of String = ('Janeiro', 'Fevereiro', 'Marco', 'Abril', 'Maio', 'Junho',
	'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro');
	MAX = 1000;

Type
	Administrador = Record
		username, password: String[15];
		nome, endereco, genero, perfil: String;
		nascimento: string[10];
		bi: String[13];
		id: Integer;
	End;
	arquivo1 = File Of Administrador;
	Funcionario = Record
		nome, endereco, genero, perfil,
		cargo, departamento: String;
		nascimento: String[10];
		bi: String[13];
		cel: Array [1..2] of String;
		salario, aumento_, desconto_,
		salario_hora, antigo_s: Real;
		id,hora_extra, hora_menos, cont_func, cont_: Integer;
	End;
	arquivo2 = File Of Funcionario;

var
	arq1: arquivo1;
	arq2: arquivo2;
	admin: Administrador;
	func: Funcionario;
	i, n, j, opcao, indice, cont_todos, id_func, horas_extras, horas_menos, cont_, _cont, size, count_func, count: Integer;
	dia, semana, mes, ano, hora, minuto, segundo, msegundo: Word;
	aumento, desconto : Real;
	nome_admin, nome_func, user, senha, cel: String;
	encontrei, autentica_user, remover, atualizar_func: Boolean;
	tecla, caracter: Char;

{-----Subprogramas dos administradores-----}
Procedure Uppercase(var palavra: String);
	Begin
		for j:=1 to Length(palavra)Do
			palavra[j] := Upcase(palavra[j]);
	End;

Function Existe_Administrador(var fich:arquivo1): Boolean;
	Begin
		Assign(fich,'Administrador.dat');
		{$I-}
			Reset(fich);
			if IOResult = 0 Then
				Existe_Administrador := True
			Else
				Existe_Administrador := False
		{$I+}
	End;

Procedure Mensagem_Admin;
	Begin
		ClrScr;
		textcolor(lightred);gotoxy(5,8);writeln('Sem registo de administrador(es) em nosso sistema.');
		textcolor(white);gotoxy(5,9);writeln('Clique enter para voltar ao menu');
		readln;
	End;

Procedure Mensagem_Error_Admin;
	Begin
		ClrScr;
		textcolor(lightred);gotoxy(5,8);writeln('Administrador nao registado.');
		textcolor(white);gotoxy(5,9);writeln('Clique enter para voltar ao menu');
		readln;
	End;

Procedure Username_Password;
	Begin
		gotoxy(25,8);write('Username: ');
		Readln(user);
		Uppercase(user);
		gotoxy(25,9);write('Password: ');
		Repeat
			caracter := ReadKey;
			if(caracter = #8)Then
				Begin
				  if(count > 0)Then
						senha := senha + caracter;
						write(#8);write(#32);write(#8);
						Delete(senha, count, 1);
						Dec(count);
					if count <= 0 Then
						senha := '';
				End
			Else
				Begin
					if(caracter in [#32..#126])Then
						Begin
							write(#42);
							senha := senha + caracter;
							inc(count);
						End;
				End;
		Until(caracter = #13);
		Uppercase(senha);
	End;

Procedure Registo_Administrador(var fich: arquivo1);
	Begin
		admin.perfil := 'ADMINISTRADOR';
		textcolor(blue);
		textbackground(black);
	  gotoxy(30,2);Writeln('_REGISTO DO ADMINISTRADOR_');
	  textcolor(white);
		textbackground(blue);
		GotoXY(18,8);writeln('Perfil: ', admin.perfil);
		gotoxy(18,9);write('Nome completo: ');
		Readln(admin.nome); Uppercase(admin.nome);
		gotoxy(18,10);write('Data de nascimento: ');
		Readln(admin.nascimento);Uppercase(admin.nascimento);
		gotoxy(18,11);write('Bilhete de identidade: ');
		Readln(admin.bi); Uppercase(admin.bi);
		GotoXY(18,12);write('Genero: ');
		Readln(admin.genero); Uppercase(admin.genero);
		GotoXY(18,13);write('Endereco: ');
		Readln(admin.endereco); Uppercase(admin.endereco);
		gotoxy(18,14);write('=================================');
		gotoxy(18,15);write('Username: ');
		Readln(admin.username); Uppercase(admin.username);
		GotoXY(18,16);write('Password: ');
		Readln(admin.password); Uppercase(admin.password);
		if Existe_Administrador(fich) = True Then
			Begin
				Assign(arq1,'Administrador.accdb');
				Reset(arq1);
				Seek(arq1, FileSize(arq1));
				size:= FileSize(arq1);
				Seek(arq1, FileSize(arq1));
				admin.id := size+1;
				gotoxy(18,7);writeln('ID: ', admin.id);delay(MAX);
				write(fich, admin);
				Close(fich);
			End
		Else
			Begin
				admin.id := 1;
				gotoxy(18,7);writeln('ID: ', admin.id);delay(MAX);
				Assign(fich,'Administrador.accdb');
				ReWrite(fich);
				write(fich, admin);
				Close(fich);
			End;
	End;

Procedure Visualizar_Administrador(var fich: arquivo1);
	Begin
		Textcolor(blue);
		Textbackground(black);
		gotoxy(30,3);writeln('INSIRA OS DADOS');
		Textcolor(white);
		Textbackground(blue);
		Username_Password;
		Assign(fich,'Administrador.dat');
		Reset(fich);
		for i:=0 to FileSize(fich)-1 do
			Begin
				Seek(fich, i);
				Read(fich, admin);
				if (admin.username = user) And (admin.password = senha) Then
					Begin
						with admin Do
							Begin
								ClrScr;
								textcolor(blue);
								textbackground(black);
								gotoxy(34,3);writeln('_DADOS PESSOAIS_');
								textcolor(white);
								textbackground(blue);
								gotoxy(10,7);writeln('ID: ', id);
								gotoxy(10,8);writeln('PERFIL: ', perfil);
								gotoxy(10,9);writeln('NOME: ', nome);
								gotoxy(10,10);writeln('DATA DE NASCIMENTO: ', nascimento);
								gotoxy(10,11);writeln('BILHETE DE IDENTIDADE: ', bi);
								gotoxy(10,12);writeln('GENERO: ', genero);
								textcolor(blue);
								textbackground(black);
								gotoxy(29,14);writeln('_DADOS DE ACESSO AO SISTEMA_');
								TEXTCOLOR(white);
								textbackground(blue);
								gotoxy(10,17);writeln('Username: ', username);
								gotoxy(10,18);writeln('Password: ', password);
								encontrei:= True;
								gotoxy(10,19);writeln('-------------------------------');
								gotoxy(10,20);writeln('Clique enter para voltar ');
								readln;
							End;
					End
			End;
			Close(fich);
			if not encontrei then Mensagem_Error_Admin;
	End;

Procedure Actualizar_Dados_Admin(var fich: arquivo1);
	Begin
		Textcolor(blue);
		Textbackground(black);
		gotoxy(30,3);writeln('INSIRA OS DADOS');
		Textcolor(white);
		Textbackground(blue);
		Username_Password;
		Assign(fich,'Administrador.dat');
		Reset(fich);
		for i:=0 to FileSize(fich)-1 Do
			Begin
				Seek(fich, i);
				Read(fich, admin);
				if (admin.username = user) And (admin.password = senha) Then
					Begin
						ClrScr;
						Textcolor(blue);
						Textbackground(black);
						gotoxy(30,3);writeln('INSIRA NOVOS DADOS');
						Textcolor(white);
						Textbackground(blue);
						gotoxy(18,7);writeln('ID: ', admin.id);
						GotoXY(18,8);writeln('Perfil: ', admin.perfil);
						gotoxy(18,9);write('Nome completo: ');
						Readln(admin.nome); Uppercase(admin.nome);
						gotoxy(18,10);write('Data de nascimento: ');
						Readln(admin.nascimento); Uppercase(admin.nascimento);
						gotoxy(18,11);write('Bilhete de identidade: ');
						Readln(admin.bi); Uppercase(admin.bi);
						GotoXY(18,12);write('Genero: ');
						Readln(admin.genero); Uppercase(admin.genero);
						GotoXY(18,13);write('Endereco: ');
						Readln(admin.endereco); Uppercase(admin.endereco);
						gotoxy(18,14);write('=================================');
						gotoxy(18,15);write('Username: ');
						Readln(admin.username); Uppercase(admin.username);
						GotoXY(18,16);write('Password: ');
						Readln(admin.password); Uppercase(admin.password);
						Seek(fich, FilePos(fich)-1);
						write(fich, admin);
						encontrei := True;
					End;
			End;
			Close(fich);
			if not encontrei then Mensagem_Error_Admin;
	End;

Procedure Remover_Administrador(var fich: arquivo1);
	Begin
		ClrScr;
		textcolor(blue);
		textbackground(black);
		gotoxy(26,2);writeln('_REMOVER DADOS DO ADMINISTRADOR_');
		textcolor(white);
		textbackground(blue);
		Username_Password;
		Assign(fich,'Administrador.dat');
		Reset(fich);
		for i:=0 to FileSize(fich)-1 Do
			Begin
				Seek(fich, i);
				Read(fich, admin);
				if (admin.username = user) and (admin.password = senha) Then
					Begin
						gotoxy(14,10);WriteLn('Tem certeza que deseja eliminar administrador(a) [S/N]?');
						tecla := ReadKey;
						tecla := Upcase(tecla);
						if tecla = 'S' Then
							Begin
								Reset(fich);
			          Seek(fich, i + 1);
			          While Not Eof(fich) Do
			            Begin
			              read(fich, admin);
			              Seek(fich, Filepos(fich) - 2);
			              Write(fich, admin);
			              Seek(fich, Filepos(fich) + 1);
			            End;
			          Seek(fich, Filesize(fich) - 1);
			          Truncate(fich);
								Close(fich);
								remover := True;
								ClrScr;
								WriteLn('Administrador(a) removido com sucesso');
								writeln('Clique enter para voltar');
								Readln;
							End
						Else
							Begin
								if tecla = 'N' Then
									Begin
										ClrScr;
										WriteLn('Operacao cancelada');
										writeln('Clique enter para voltar');
										Readln;
									End
								Else RunError;
							End;
					End;
			End;
		if not remover Then Mensagem_Error_Admin;
	End;

Procedure Menu_Administrador(Var fich: arquivo1);
	Label
		menu_admin;
	Begin
		menu_admin:
		ClrScr;
		TEXTCOLOR(BLUE);
		TEXTBACKGROUND(black);
		gotoxy(30,2);writeln('_MENU DO ADMINISTRADOR_');
		TEXTCOLOR(WHITE);
		TEXTBACKGROUND(BLUE);
		gotoxy(20,10);writeln('  [1] Consultar dados do administrador   ');
		gotoxy(20,11);WriteLn('  [2] Remover dados do administrador     ');
		gotoxy(20,12);writeln('  [3] Alterar dados de acesso ao sistema ');
		gotoxy(20,13);writeln('  [4] Voltar ao menu incial              ');
		gotoxy(20,14);writeln('=========================================');
		gotoxy(20,15);write('>>> ');
		readln(opcao);
		Case(opcao)Of
			1: Begin
						ClrScr;
						Visualizar_Administrador(arq1);
						goto menu_admin;
				 End;
			2: Begin
						ClrScr;
						Remover_Administrador(arq1);
						goto menu_admin;
				 End;
			3: Begin
						ClrScr;
						Actualizar_Dados_Admin(arq1);
						goto menu_admin;
				 End;
			4: Read;
		End;
	End;
{-----Subprogramas dos funcionarios-----}
Function Existe_Funcionario(var fich: arquivo2): Boolean;
	Begin
		Assign(fich,'Funcionario.dat');
		{$I-}
		Reset(fich);
		if IOResult = 0 Then
			Existe_Funcionario := True
		Else
			Existe_funcionario := False;
		{$I+}
	End;

Procedure Mensagem_Func;
	Begin
		ClrScr;
		textcolor(lightred);gotoxy(5,8);writeln('Sem registro de funcionarios em nosso sistema.');
		textcolor(white);gotoxy(5,9);writeln('Clique enter para voltar ao menu');
	End;

Procedure Mensagem_Error;
	Begin
		ClrScr;
		textcolor(lightred);gotoxy(5,8);writeln('Funcionario nao registado.');
		textcolor(white);gotoxy(5,9);writeln('Clique enter para voltar ao menu');
	End;

Procedure Cargos;
	Begin
		textcolor(blue);
		textbackground(black);
		gotoxy(30,3);writeln('CARGOS');
		textcolor(white);
		textbackground(blue);
		gotoxy(20,8);writeln('[1] DIRECTOR');
		gotoxy(20,9);writeln('[2] PROFESSOR');
		gotoxy(20,10);writeln('[3] SECRETARIO');
		GotoXY(20,11);WriteLn('[4] INFORMATICO');
		GotoXY(20,12);WriteLn('[5] OUTROS');
	End;

Procedure Detalhes;
	Begin
		writeln('ID: ', func.id);
		writeln('NOME: ', func.nome);
		writeln('DATA DE NASCIMENTO: ', func.nascimento);
		writeln('BILHETE DE IDENTIDADE: ', func.bi);
		writeln('GENERO: ', func.genero);
		writeln('DEPARTAMENTO: ', func.departamento);
		writeln('CARGO: ', func.cargo);
		writeln('SALARIO: ', func.salario:0:2,' MZN');
		writeln('CELULAR: ', func.cel[1]);
		writeln('CELULAR ALTERNATIVO: ', func.cel[2]);
		writeln('---------------------------------');
	End;

Procedure Registo_Funcionario(var fich: arquivo2);
	Begin
		write('Numero de funcionarios que pretende regitar: ');
		Readln(n);
		for i:= 1 to n Do
			Begin
				ClrScr;
				func.cont_func := func.cont_func+1;
				func.perfil := 'FUNCIONARIO';
				textcolor(blue);
				textbackground(black);
			  gotoxy(30,2);Writeln('_REGISTO DO FUNCIONARIO_');
			  textcolor(white);
				textbackground(blue);
				GotoXY(18,8);writeln('Perfil: ', func.perfil);
				gotoxy(18,9);write('Nome completo: ');
				Readln(func.nome); Uppercase(func.nome);
				gotoxy(18,10);write('Data de nascimento: ');
				Readln(func.nascimento); Uppercase(func.nascimento);
				gotoxy(18,11);write('Bilhete de identidade: ');
				Readln(func.bi); Uppercase(func.bi);
				GotoXY(18,12);write('Genero: ');
				Readln(func.genero); Uppercase(func.genero);
				GotoXY(18,13);write('Endereco: ');
				Readln(func.endereco); Uppercase(func.endereco);
				GotoXY(18,14);write('Celular: ');
				Readln(func.cel[1]);
				gotoxy(18,15);write('Celular alternativo: ');
				Readln(func.cel[2]);
				func.hora_extra := 0;
				func.hora_menos := 0;
				ClrScr;
				textcolor(blue);
				textbackground(black);
				GotoXY(30,3);WriteLn('DEPARTAMENTO');
				textcolor(white);
				textbackground(blue);
				gotoxy(20,8);writeln('[1] AUDITORIA');
				gotoxy(20,9);writeln('[2] LOGISTICA');
				gotoxy(20,10);writeln('[3] CONTABILIDADE');
				readln(opcao);
				Case(opcao)Of
					1:	func.departamento := 'AUDITORIA';
					2:	func.departamento := 'LOGISTICA';
					3:	func.departamento := 'CONTABILIDADE';
				End;
				ClrScr;
				Cargos;
				readln(opcao);
				Case(opcao)Of
					1: Begin
								func.cargo := 'DIRECTOR';
								func.salario := 45000;
						 End;
					2: Begin
								func.cargo := 'PROFESSOR';
								func.salario := 25000;
						 End;
					3: Begin
								func.cargo := 'SECRETARIO';
								func.salario := 15000;
						 End;
					4: Begin
								func.cargo := 'INFORMATICO';
								func.salario := 18000;
						 End;
					5: Begin
								func.cargo := 'OUTROS';
								func.salario := 10000;
						 End;
				End;
				if Existe_Funcionario(arq2) = True Then
					Begin
						Assign(fich,'Funcionario.dat');
						Reset(fich);
						Seek(fich, FileSize(fich));
						size:= FileSize(fich);
						Seek(fich, FileSize(fich));
						func.id := size+1;
						gotoxy(18,7);writeln('ID: ', func.id);delay(MAX);
						write(fich, func);
						Close(fich);
					End
				Else
					Begin
						func.id := 1;
						gotoxy(18,7);writeln('ID: ', func.id);delay(MAX);
						Assign(fich,'Funcionario.dat');
						ReWrite(fich);
						write(fich, func);
						Close(fich);
					End;
			End;
	End;

Procedure Listar_funcionarios(var fich: arquivo2);
	Var size: Integer;
	Begin
		Assign(fich,'Funcionario.dat');
		Reset(fich);
		While not Eof(fich)Do
			Begin
				Read(fich, func);
				size := FileSize(fich);
				if size = 0 Then
					Mensagem_Func
				Else
					cont_todos:=cont_todos+1;
					Detalhes;
			End;
		Close(fich);
		writeln('Nº total de funcionarios: ',cont_todos);
		writeln('................................');
		writeln('Clique enter para voltar ao menu');
	End;

Procedure Pesquisa_Nome_Func(var fich: arquivo2);
	Begin
		textcolor(blue);
		textbackground(black);
	  gotoxy(30,3);WriteLn('PESQUISA DO FUNCIONARIO');
	  textcolor(white);
		textbackground(blue);
		GotoXY(20,8);write('Nome completo: ');
		Readln(nome_func); Uppercase(nome_func);
		Assign(fich,'Funcionario.dat');
		Reset(fich);
		for i:=0 to FileSize(fich)-1 Do
			Begin
				Seek(fich, i);
				Read(fich, func);
				if func.nome = nome_func Then
					Begin
						ClrScr;
						Detalhes;
						WriteLn('Clique enter para voltar');
						encontrei := True;
					End;
			End;
		Close(fich);
		if not encontrei then Mensagem_Error;
	End;

Procedure Pesquisa_ID_Func(var fich: arquivo2);
	Begin
		textcolor(blue);
		textbackground(black);
	  gotoxy(30,3);WriteLn('PESQUISA DO FUNCIONARIO');
	  textcolor(white);
		textbackground(blue);
		GotoXY(20,8);write('ID: ');
		Readln(id_func);
		for i:=0 to FileSize(fich)-1 Do
			Begin
				Seek(fich, i);
				Read(fich, func);
				if func.id = id_func Then
					Begin
						ClrScr;
						textcolor(blue);
						textbackground(black);
						gotoxy(30,3);WriteLn('INFORMACOES DO FUNCIONARIO');
						textcolor(white);
						textbackground(blue);
						Detalhes;
						encontrei := True;
					End;
			End;
		Close(fich);
		if not encontrei then Mensagem_Error;
	End;

Procedure Actualizar_Funcionario(var fich: arquivo2);
	Begin
		textcolor(blue);
		textbackground(black);
		gotoxy(30,2);Writeln('_ACTUALIZAR DADOS DO FUNCIONARIO_');
		textcolor(white);
		textbackground(blue);
		GotoXY(18,7);write('ID: ');
		Readln(id_func);
		Assign(fich,'Funcionario.dat');
		reset(fich);
		for i:=0 to FileSize(fich)-1 Do
			Begin
				Seek(fich, i);
				Read(fich, func);
				if(func.id = id_func)then
					Begin
						atualizar_func := True;
						GotoXY(18,8);writeln('Perfil: ', func.perfil);
						gotoxy(18,9);write('Nome completo: ');
						Readln(func.nome); Uppercase(func.nome);
						gotoxy(18,10);write('Data de nascimento: ');
						Readln(func.nascimento); Uppercase(func.nascimento);
						gotoxy(18,11);write('Bilhete de identidade: ');
						Readln(func.bi); Uppercase(func.bi);
						GotoXY(18,12);write('Genero: ');
						Readln(func.genero); Uppercase(func.genero);
						GotoXY(18,13);write('Endereco: ');
						Readln(func.endereco); Uppercase(func.endereco);
						GotoXY(18,14);write('Celular: ');
						Readln(func.cel[1]);
						gotoxy(18,15);write('Celular alternativo: ');
						Readln(func.cel[2]);
						ClrScr;
						textcolor(blue);
						textbackground(black);
						GotoXY(30,3);WriteLn('DEPARTAMENTO');
						textcolor(white);
						textbackground(blue);
						gotoxy(20,8);writeln('[1] AUDITORIA');
						gotoxy(20,9);writeln('[2] LOGISTICA');
						gotoxy(20,10);writeln('[3] CONTABILIDADE');
						readln(opcao);
						Case(opcao)Of
							1:	func.departamento := 'AUDITORIA';
							2:	func.departamento := 'LOGISTICA';
							3:	func.departamento := 'CONTABILIDADE';
						End;
						ClrScr;
						Cargos;
						readln(opcao);
						Case(opcao)Of
							1: Begin
										func.cargo := 'DIRECTOR';
										func.salario := 45000;
								 End;
							2: Begin
										func.cargo := 'PROFESSOR';
										func.salario := 25000;
								 End;
							3: Begin
										func.cargo := 'SECRETARIO';
										func.salario := 15000;
								 End;
							4: Begin
										func.cargo := 'INFORMATICO';
										func.salario := 18000;
								 End;
							5: Begin
										func.cargo := 'OUTROS';
										func.salario := 10000;
								 End;
						End;
						Seek(fich, FilePos(fich)-1);
						write(fich, func);
					End;
			end;
			Close(fich);
			if not atualizar_func then Mensagem_Error;
	End;

Procedure Remover_Funcionario(var fich: arquivo2);
	Begin
		textcolor(blue);
		textbackground(black);
		gotoxy(26,2);writeln('_REMOVER DADOS DO FUNCIONARIO_');
		textcolor(white);
		textbackground(blue);
		GotoXY(20,8);write('ID: ');
		Readln(id_func);
		Assign(arq2,'Funcionario.dat');
		Reset(arq2);
		for i:=0 to FileSize(fich)-1 Do
			Begin
				Seek(fich, i);
				Read(fich, func);
			 	if func.id = id_func Then
					Begin
						gotoxy(20,9);WRiteln('Nome do funcionario: ', func.nome);
						close(fich);
						gotoxy(20,10);WriteLn('Tem certeza que deseja eliminar funcionario(a) [S/N]?');
						tecla := ReadKey;
						tecla := Upcase(tecla);
						if tecla = 'S' Then
							Begin
								Reset(fich);
			          Seek(fich, i + 1);
								func.cont_func := func.cont_func-1;
			          While Not Eof(fich) Do
			            Begin
			              read(fich, func);
			              Seek(fich, Filepos(fich) - 2);
			              Write(fich, func);
			              Seek(fich, Filepos(fich) + 1);
			            End;
			          Seek(fich, Filesize(fich) - 1);
			          Truncate(fich);
								Close(fich);
								remover := True;
								ClrScr;
								WriteLn('Funcionario(a) removido(a) com sucesso.');
								writeln('Clique enter para voltar');
								Readln;
							End
						Else
							Begin
								ClrScr;
								WriteLn('Operacao cancelada.');
								writeln('Clique enter para voltar');
								Readln;
							End;
					End;
			end;
		if not remover Then Mensagem_Error;
	End;

Procedure Operacoes_aumento;
	Begin
		func.salario := func.salario + func.aumento_;
		func.antigo_s := func.salario - func.aumento_;
		func.salario_hora := func.salario / (240+func.hora_extra);
	End;

Procedure Mensagem_Aumento_Salario;
	Begin
		Writeln('Antigo Salario: ',func.antigo_s:0:2,' MZN');
		Writeln('Aumento Salarial: ',func.aumento_:0:2,' MZN');
		WriteLn('Salario por hora: ', func.salario_hora:0:2,' MZN');
		Writeln('Novo Salario: ',func.salario:0:2,' MZN');
		writeln('Hora(s) extra(s): ', func.hora_extra, ' hora(s)');
		writeln('---------------------------------');
	End;

Procedure Operacoes_desconto;
	Begin
		func.salario := func.salario - func.desconto_;
		func.antigo_s := func.salario + func.desconto_;
		func.salario_hora := func.salario / (240-func.hora_menos);
	End;

Procedure Mensagem_Desconto_Salario;
	Begin
		Writeln('Antigo Salario: ',func.antigo_s:0:2,' MZN');
		Writeln('Desconto Salarial: ',func.desconto_:0:2,' MZN');
		writeln('Salario por hora: ',func.salario_hora:0:2,' MZN');
		Writeln('Novo Salario: ',func.salario:0:2,' MZN');
		writeln('Hora(s) a meno(s): ', func.hora_menos, ' hora(s)');
		writeln('---------------------------------');
	End;

Procedure Calculo_Salarial(var fich: arquivo2);
	Label C_S;
	Begin
		Textcolor(blue);
		Textbackground(black);
		gotoxy(30,3);WriteLn('FOLHA DE SALARIO');
		Textcolor(white);
		Textbackground(blue);
		GotoXY(20,8);write('Id do funcionario: ');
		Readln(id_func);
		for i:=0 to FileSize(fich)-1 Do
			Begin
				Seek(fich, i);
				Read(fich, func);
				if func.id = id_func Then
					Begin
						C_S:
						ClrScr;
						encontrei := True;
						Textcolor(blue);
						Textbackground(black);
						gotoxy(30,3);WriteLn('FOLHA DE SALARIO');
						Textcolor(white);
						Textbackground(blue);
						Detalhes;
						WriteLn('[1] Aumento salarial');
						writeln('[2] Desconto salarial');
						writeln('[3] Voltar');
						Readln(opcao);
						Case(opcao)Of
							1: Begin
										writeln('Quantas horas de trabalho extra?');
										write('>>> ');
										Readln(func.hora_extra);
										ClrScr;
										Cargos;
										gotoxy(20,13);writeln('[6] Voltar');
										readln(opcao);
										Case(opcao)Of
											1:	func.aumento_ := 45000*((6.5*func.hora_extra)/100);
											2:	func.aumento_ := 25000*((4*func.hora_extra)/100);
											3:	func.aumento_ := 15000*((3.5*func.hora_extra)/100);
											4:	func.aumento_ := 18000*((1.5*func.hora_extra)/100);
											5:	func.aumento_ := 10000*((0.5*func.hora_extra)/100);
											6:	goto C_S;
										End;
										Operacoes_aumento; ClrScr;
										Mensagem_Aumento_Salario;
										writeln('Clique enter para voltar ao menu.');
								 End;
							2: Begin
										writeln('Quantas horas a menos de trabalho?');
										write('>>> ');
										Readln(func.hora_menos);
										ClrScr;
										Cargos;
										gotoxy(20,13);writeln('[6] Voltar');
										readln(opcao);
										Case(opcao)Of
											1: 	func.desconto_ := 45000*((6.5*func.hora_menos)/100);
											2:	func.desconto_ := 25000*((4*func.hora_menos)/100);
											3:	func.desconto_ := 15000*((3.5*func.hora_menos)/100);
											4:	func.desconto_ := 18000*((1.5*func.hora_menos)/100);
											5:	func.desconto_ := 10000*((0.5*func.hora_menos)/100);
											6:	goto C_S;
										End;
										Operacoes_desconto; ClrScr;
										Mensagem_Desconto_Salario;
										writeln('Clique enter para voltar ao menu.');
								 End;
							3: Read;
						End;
						Seek(fich, FilePos(fich)-1);
						write(fich, func);
					End;
			End;
			Close(fich);
			if not encontrei then Mensagem_Error;
	End;

Procedure Relatorio(var fich: arquivo2);
	Label relatorio_;
	Var nr_func: Integer;
	Begin
		ClrScr;
		Assign(fich,'Funcionario.dat');
		Reset(fich);
		While Not Eof(fich) Do
			Begin
				Read(fich, func);
				relatorio_:
				ClrScr;
				cont_:=0;
				textcolor(blue);
				textbackground(black);
				GOTOXY(30,3);writeln('_RELATORIO DO AJUSTE SALARIAL_');
				TEXTCOLOR(WHITE);
				TEXTBACKGROUND(BLUE);
				GOTOXY(26,9);writeln('[1] Aumento salarial');
				GOTOXY(26,10);writeln('[2] Desconto salarial');
				gotoxy(26,11);writeln('[3] Voltar');
				GOTOXY(26,12);writeln('----------------------');
				GOTOXY(26,13);write('>>> ');
				readln(opcao);
				Case(opcao)Of
					1: Begin
								ClrScr;
								if func.hora_extra > 0 Then
									Begin
										cont_:= cont_+1;
										Detalhes;
										Mensagem_Aumento_Salario;
										writeln('Nº total de funcionarios da instituicao: ',count_func);
										writeln('=> ',cont_,' funcionario(s) recebeu(ram) aumento salarial.');
										writeln('=> ',count_func-cont_, ' funcionario(s) nao recebeu(ram) aumento salarial.');
										writeln('Clique enter para voltar ao menu.');
										readln; goto relatorio_;
									End
								Else
									Begin
										textcolor(lightred);gotoxy(15,10);writeln('Sem relatorio a ser apresentado.');
										gotoxy(10,11);textcolor(white);writeln('Clique enter para voltar ao menu.');
										readln; goto relatorio_;
									End;
						 End;
					2: Begin
								ClrScr;
								if func.hora_menos > 0 Then
									Begin
										_cont:= _cont+1;
										Detalhes;
										Mensagem_Desconto_Salario;
										writeln('Nº total de funcionarios da instituicao: ',count_func);
										writeln('=> ',_cont,' funcionario(s) recebeu(ram) um desconto salarial.');
										writeln('=> ',count_func-_cont, ' funcionario(s) nao recebeu(ram) desconto salarial.');
										writeln('Clique enter para voltar ao menu.');
										Readln; goto relatorio_;
									End
								Else
									Begin
										textcolor(lightred);gotoxy(15,10);writeln('Sem relatorio a ser apresentado.');
										gotoxy(10,11);textcolor(white);writeln('Clique enter para voltar ao menu.');
										readln; goto relatorio_;
									End;
						 End;
					3: break;
				End;
			End;
		close(fich);
	End;

{-----Programa Principal----}
Begin
	inicio:
	Textbackground(blue);
	ClrScr;
  Textcolor(blue);
  Textbackground(black);
  gotoxy(28,4);Writeln('_BEM VINDO AO MENU INICIAL_');
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
	readln(opcao);
	case(opcao)of
		1: Begin
					if Existe_Administrador(arq1) = True Then
						Begin
							login:
							ClrScr;
							Textcolor(blue);
							Textbackground(black);
							gotoxy(33,3);Writeln('_LOGIN DO ADMIN_');
							Textcolor(white);
							Textbackground(blue);
							Username_Password;
							Assign(arq1,'Administrador.dat');
							Reset(arq1);
							for i:=0 to FileSize(arq1)-1 Do
								Begin
									Seek(arq1, i);
									Read(arq1, admin);
									if (admin.username = user) and (admin.password = senha) Then
										Begin
											Assign(arq2,'Funcionario.dat');
											Reset(arq2);
											While Not Eof(arq2) Do
												Begin
													Read(arq2, func);
													count_func := count_func + 1;
												End;
											Close(arq2);
											menu_princ:
											ClrScr;
											Textcolor(blue);
				 							Textbackground(black);
										  Gotoxy(33,2);Writeln ('_MENU PRINCIPAL_');
											Textcolor(white);
				 							Textbackground(blue);
											getdate(ano, mes, dia, semana);
											gettime(hora, minuto, segundo, msegundo);
											gotoxy(3,5);writeln('ID: ',admin.id);
											gotoxy(3,6);writeln('PERFIL: ',admin.perfil);
											gotoxy(38,5);Writeln(hora,':',minuto);
											gotoxy(60,5);Writeln(SEMANAS[semana],',',dia,'/',MESES[mes],'/',ano);
											Gotoxy(25,12);Writeln('[1] GERENCIAR FUNCIONARIOS');
				              Gotoxy(25,13);Writeln('[2] FOLHA DE AJUSTE SALARIAL');
											Gotoxy(25,14);writeln('[3] RELATORIO');
				              Gotoxy(25,15);Writeln('[4] VOLTAR AO MENU INICIAL');
				              Gotoxy(25,16);writeln('---------------------------');
											gotoxy(25,17);write('>>> ');
											readln(opcao);
											Case(opcao)Of
												1: Begin
															menu_func:
															Clrscr;
															cont_todos:=0;
															Textcolor(blue);
				         							Textbackground(black);
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
															readln(opcao);
															Case(opcao)Of
																1: Begin
																			ClrScr;
																			Registo_Funcionario(arq2);
																			ClrScr;
																			textcolor(lightgreen);gotoxy(20,15);writeln('Funcionario(s) registrado(s) com sucesso.');
																			textcolor(white);gotoxy(20,16);writeln('Clique enter para voltar ao menu');
																			readln; goto menu_func;
																	 End;
																2: Begin
																			if Existe_Funcionario(arq2) = True Then
																				Begin
																					ClrScr;
																					Actualizar_Funcionario(arq2);
																					ClrScr;
																					textcolor(lightgreen);gotoxy(20,15);writeln('Os seus dados foram actualizados com sucesso.');
																					textcolor(white);gotoxy(20,16);writeln('Clique enter para voltar ao menu');
																					readln; goto menu_func;
																				End
																			Else
																				Begin
																					Mensagem_Func;
																					goto menu_func;
																				End;
																	 End;
																3: Begin
																			if Existe_Funcionario(arq2) = True Then
																				Begin
																					ClrScr;
																					Remover_Funcionario(arq2);
																					goto menu_func;
																				End
																			Else
																				Begin
																					Mensagem_Func;
																					goto menu_func;
																				End;
																	 End;
																4: Begin
																			if Existe_Funcionario(arq2) = True Then
																				Begin
																					ClrScr;
																					Pesquisa_ID_Func(arq2);
																					writeln('Clique enter para voltar');
																					Readln; goto menu_func;
																				End
																			Else
																				Begin
																					Mensagem_Func;
																					goto menu_func;
																				End;
																	 End;
																5: Begin
																			if Existe_Funcionario(arq2) = True Then
																				Begin
																					ClrScr;
																					Pesquisa_Nome_Func(arq2);
																					Readln; goto menu_func;
																				End
																			Else
																				Begin
																					Mensagem_Func;
																					goto menu_func;
																				End;
																	 End;
																6: Begin
																			if Existe_Funcionario(arq2) = True Then
																				Begin
																					ClrScr;
																					Listar_funcionarios(arq2);
																					Readln; goto menu_func;
																				End
																			Else
																				Begin
																					Mensagem_Func;
																					goto menu_func;
																				End;
																	 End;
																7: goto menu_princ;
															End;
													 End;
												2: Begin
															if Existe_Funcionario(arq2) = True Then
																Begin
																	ClrScr;
																	Calculo_Salarial(arq2);
																	Readln; goto menu_princ;
																End
															Else
																Begin
																	Mensagem_Func;
																	goto menu_princ;
																End;
													 End;
												3: Begin
															ClrScr;
															Relatorio(arq2);
															goto menu_princ;
													 End;
												4: goto inicio
												Else goto menu_princ;
											End;
										End;
								end;
							Close(arq1);
							if not autentica_user then
								Begin
									gotoxy(25,12);textcolor(red);writeln('Username ou password incorrecto.');
									gotoxy(25,13);textcolor(white);writeln('Tentar novamente?[S/N]');
									tecla := readkey;
									tecla := upcase(tecla);
									if(tecla = 'S') then goto login
									else
										Begin
											If(tecla = 'N')then goto inicio
											else RunError;
										end;
								End;
						end
					Else
						Begin
							Mensagem_Admin;
							goto inicio;
						End;
			 End;
		2: Begin
					ClrScr;
					Registo_Administrador(arq1);
					ClrScr;
					gotoxy(22,8);textcolor(lightgreen);writeln('Administrador(a) registado(a) com sucesso.');
					gotoxy(22,9);textcolor(white);writeln('Clique enter para voltar ao menu incial');
					readln; goto inicio;
			 End;
		3: Begin
					if Existe_Administrador(arq1) = True Then
						Begin
							ClrScr;
							Menu_Administrador(arq1);
							goto inicio;
						End
					Else
						Begin
							Mensagem_Admin;
							goto inicio;
						End;
			 End;
		4: Exit
		Else goto inicio;
	End;
End.