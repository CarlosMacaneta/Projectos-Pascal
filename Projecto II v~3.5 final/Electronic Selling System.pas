Program Computer_Shop;
uses crt, dos, Design, sysutils, shellapi;

Label
	inicio, login, menu, menu_2, menu_op, deseja_continuar;

Const
	SEMANAS: Array [0..6] of String = ('Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab');
	MESES: Array [1..12] of String = ('Janeiro', 'Fevereiro', 'Marco', 'Abril', 'Maio', 'Junho',
	'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro');
	IVA = 0.17;

Type
	Gestor = Record
		username, password: String[15];
		nome, genero, perfil, endereco,
		email: String;
		nascimento: String[10];
		celular: Array [1..2] of String;
		bi: String[13];
		id, id_op: Integer;
	End;
	arquivo1 = file of Gestor;
	Produto = Record
		nome_prod, nome_prod_vend, categoria,
		tipo, id_prod, categoria_vend,
		tipo_vend, id_prod_vend, nome_prod_en,
		id_prod_en,categoria_en,tipo_en: String;
		preco_prod, valor_pagar, preco_prod_en: Real;
		quant_prod, quant_prod_vend, quant_prod_en, nr_sale: Integer;
		day, weekday, year, second, hour, msecond,
		minute, mounth, day_sell, weekday_sell, year_sell,
		second_sell, hour_sell, msecond_sell, minute_sell, mounth_sell: Word;
	End;
	arquivo2 = file of Produto;
	Recibo_temp = Record
		marca, categ, tipo, id_reci: String;
		quant_reci: Integer;
		cash, preco_uni: Real;
	End;
	arquivo3 = file Of Recibo_temp;
Var
	arq1: arquivo1;
	gest: Gestor;
	func: Gestor;
	arq2: arquivo2;
	prod: Produto;
	arq3: arquivo3;
	reci: Recibo_temp;
	rel_: Text;
	dia, semana, mes, ano, hora, minuto, segundo, msegundo: Word;
	user, senha, nome_gest, _nome_prod,_id_prod, operador, code, user_account: String;
	i, j, n, nr_prod, id_gest, opcao, size, quant_total_disp, _quant_prod, quant_total_vend,
	codigo, count: Integer;
	encontrei, autentica_user, remover_user, acesso_permitido, stock_found: Boolean;
	capital_total, capital_total_vend: Real;
	tecla, ch: Char;

Function Existe_Gestor(Var fich: arquivo1): Boolean;
	Begin
		Assign(fich,'Gestor.dat');
		{$I-}
		Reset(fich);
		If IOResult = 0 Then
			Existe_Gestor := True
		Else
			Existe_Gestor := False;
		{$I+}
	End;

Procedure Progress_Bar;
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
		    Write(#62);
		    delay(35);
			end;
			textcolor(white);
	End;

Procedure Registo_Gestor(Var fich: arquivo1; reg: Gestor);
	Begin
		Assign(fich,'Gestor.dat');
		ReWrite(fich);
		write(fich, reg);
		Close(fich);
	End;

Procedure Add_Registo_Gestor(Var fich: arquivo1; reg: Gestor);
	Begin
		Assign(fich,'Gestor.dat');
		Reset(fich);
		Seek(fich, FileSize(fich));
		size := FileSize(fich);
		Seek(fich, FileSize(fich));
		gest.id :=  Size+1;
		gotoxy(18,7);writeln('ID: ', gest.id);delay(1000);
		write(fich, gest);
		close(fich);
	End;

Procedure Formulario_Gestor(var fich: arquivo1);
	Begin
		ClrScr;
		gest.perfil := 'GESTOR';
		textcolor(blue);
		textbackground(black);
	  gotoxy(30,2);Writeln('_REGISTO DO GESTOR_');
	  textcolor(white);
		textbackground(blue);
		GotoXY(18,8);writeln('Perfil: ', gest.perfil);
		gotoxy(18,9);write('Nome completo: ');
		readln(gest.nome);
		for j := 1 to Length(gest.nome)Do
			gest.nome[j]:= Upcase(gest.nome[j]);
		gotoxy(18,10);write('Data de nascimento(dd/mm/aaaa): ');
		readln(gest.nascimento);
		while((copy(gest.nascimento,3,1) <> '/')and(copy(gest.nascimento,6,1) <> '/')or(Length(gest.nascimento) < 10)) do
			Begin
				Delete(gest.nascimento,1,Length(gest.nascimento));
				GotoXY(18,10); delline;
				gotoxy(18,11);textcolor(lightred);WriteLn('formato incorrecto');
				textcolor(white); readkey; gotoxy(18,11);  ClrEOL;
				gotoxy(18,10);write('Data de nascimento(dd/mm/aaaa): ');
				readln(gest.nascimento);
			end;
		gotoxy(18,11);write('Bilhete de identidade: ');
		readln(gest.bi);
		for j := 1 to Length(gest.bi)Do
			gest.bi[j]:= Upcase(gest.bi[j]);
		gotoxy(18,12);write('Género: ');
		readln(gest.genero);
		for j := 1 to Length(gest.genero)do
			gest.genero[j]:= Upcase(gest.genero[j]);
		GotoXY(18,13);write('Endereco: ');
		Readln(gest.endereco);
		for j := 1 to Length(gest.endereco)do
			gest.endereco[j] := Upcase(gest.endereco[j]);
		GotoXY(18,14);Write('Celular: ');
		Readln(gest.celular[1]);
		GotoXY(18,15);Write('Celular alternativo: ');
		Readln(gest.celular[2]);
		GotoXY(18,16);Write('Email: ');
		Readln(gest.email);
		gotoxy(18,17); textcolor(yellow);
		writeln('==================================================');
		textcolor(white);
		gotoxy(18,18);Write('Username: ');
		readln(gest.username);
		for j := 1 to Length(gest.username)Do
			gest.username[j]:= Upcase(gest.username[j]);
		gotoxy(18,19);write('Password: ');
		readln(gest.password);
		for j:= 1 to Length(gest.password)Do
			gest.password[j]:= Upcase(gest.password[j]);
		while(Length(gest.password) < 8) or (Length(gest.password) >= 15)do
			Begin
				gotoxy(18,19);delline;
				Delete(gest.password,1,Length(gest.password));
				gotoxy(18,19);write('Password: ');
				readln(gest.password);
				for j:= 1 to Length(gest.password)Do
					gest.password[j]:= upcase(gest.password[j]);
			End;
		if Existe_Gestor(fich) = True Then
			Begin
				Add_Registo_Gestor(fich, gest);
			End
		Else
			Begin
				gest.id :=  1;
				gotoxy(18,7);writeln('ID: ', gest.id);delay(1000);
				Registo_Gestor(fich, gest);
			End;
	End;

Procedure Dados_Gestor(Var fich: arquivo1);
	Begin
		ClrScr;
		textcolor(blue);
		textbackground(black);
		gotoxy(26,2);writeln('_CONSULTAR DADOS DO GESTOR_');
		textcolor(white);
		textbackground(blue);
		gotoxy(13,8);write('Nome completo: ');
		readln(nome_gest);
		for j:= 1 to Length(nome_gest)do
			nome_gest[j]:= Upcase(nome_gest[j]);
		gotoxy(13,9);write('Password: ');
		readln(senha);
		for j:= 1 to Length(senha)Do
			senha[j]:= Upcase(senha[j]);
		Assign(fich, 'Gestor.dat');
		Reset(fich);
		for i:= 0 to FileSize(fich)-1 Do
			Begin
				Seek(fich, i);
				Read(fich, gest);
				if(nome_gest = gest.nome)and(senha = gest.password)Then
					Begin
						with gest Do
							Begin
								ClrScr;
								Progress_Bar;
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
								gotoxy(10,13);writeln('CELULAR: ', celular[1]);
								gotoxy(10,14);writeln('CELULAR ALTERNATIVO: ', celular[2]);
								gotoxy(10,15);writeln('Email: ', email);
								textcolor(blue);
								textbackground(black);
								gotoxy(29,17);writeln('_DADOS DE ACESSO AO SISTEMA_');
								TEXTCOLOR(white);
								textbackground(blue);
								gotoxy(10,20);writeln('Username: ', username);
								gotoxy(10,21);writeln('Password: ', password);
								encontrei:= True;
								gotoxy(10,22);writeln('-------------------------------');
								gotoxy(10,23);writeln('Clique enter para voltar ');
								readln;
								break;
							End;
					End
				Else encontrei := False;
			End;
		Close(fich);
		if (encontrei = False) Then
			Begin
				ClrScr;
				textcolor(lightred);gotoxy(22,8);writeln('Gestor(a) nao registado(a).');
				textcolor(white);gotoxy(22,9);writeln('Clique enter para voltar ao menu.');
				Readln;
			End;
	End;

Procedure Remover_Gestor(Var fich: arquivo1);
	Begin
		ClrScr;
		textcolor(blue);
		textbackground(black);
		gotoxy(26,2);writeln('_REMOVER DADOS DO GESTOR_');
		textcolor(white);
		textbackground(blue);
		gotoxy(13,8);write('Nome completo: ');
		readln(nome_gest);
		for j:= 1 to Length(nome_gest)do
			nome_gest[j]:= Upcase(nome_gest[j]);
		gotoxy(13,9);write('Password: ');
		readln(senha);
		for j:= 1 to Length(senha)Do
			senha[j]:= Upcase(senha[j]);
		Assign(fich, 'Gestor.dat');
		Reset(fich);
		for i:=0 to FileSize(fich)-1 Do
			Begin
				Seek(fich, i);
				Read(fich, gest);
				if(nome_gest = gest.nome)and(senha = gest.password)Then
					Begin
						Close(fich);
						gotoxy(13,11);writeln('Tem certeza de que deseja remover gestor?[S/N]');
						tecla:= ReadKey;
						tecla:= Upcase(tecla);
						if (tecla = 'S')Then
							Begin
								Reset(fich);
								Seek(fich, i+1);
								While not Eof(fich) Do
									Begin
										Read(fich, gest);
										Seek(fich, FilePos(fich)-2);
										Write(fich, gest);
										Seek(fich, FilePos(fich)+1);
									End;
								Seek(fich, FilePos(fich)-1);
								Truncate(fich);
								Close(fich);
								remover_user := True;
								ClrScr;
								Progress_Bar;
								ClrScr;
								gotoxy(22,8);textcolor(lightgreen);writeln('Gestor(a) foi removido(a) com sucesso.');
								gotoxy(22,9);textcolor(white);writeln('Clique enter para voltar.');
								readln;
							End
						Else
							Begin
								if (tecla = 'N')Then
									Begin
										ClrScr;
										remover_user := true;
									End
								Else RunError;
							End;
						ClrScr;
					End
				Else remover_user := False;
			End;
		if (remover_user = False) Then
			Begin
				ClrScr;
				Progress_Bar;
				ClrScr;
				textcolor(lightred);gotoxy(22,8);writeln('Gestor(a) nao registado(a).');
				textcolor(white);gotoxy(22,9);writeln('Clique enter para voltar ao menu do gestor.');
				readln;
			End;
	End;

Procedure Alterar_Dados_AS(var fich: arquivo1);
	Begin
		ClrScr;
		textcolor(blue);
		textbackground(black);
		gotoxy(30,2);writeln('_ALTERAR DADOS DE ACESSO AO SISTEMA_');
		textcolor(white);
		textbackground(blue);
		GotoXY(18,8);Write('Username: ');
		Readln(user);
		for j:= 1 to Length(senha)Do
			user[j]:=Upcase(user[j]);
		GotoXY(18,9);write('Password: ');
		Readln(senha);
		for j:= 1 to Length(senha)Do
			senha[j]:= Upcase(senha[j]);
		Assign(fich, 'Gestor.dat');
		Reset(fich);
		for i := 0 to FileSize(fich)-1 Do
			Begin
				Seek(fich, i);
				Read(fich, gest);
				if(user = gest.username)and(senha = gest.password)Then
					Begin
						ClrScr;
						textcolor(blue);
						textbackground(black);
						gotoxy(30,2);writeln('_INFORME NOVOS DADOS DE ACESSO AO SISTEMA_');
						textcolor(white);
						textbackground(blue);
						gotoxy(18,10);Write('Username: ');
						readln(gest.username);
						for j:= 1 to Length(gest.username)Do
							gest.username[j]:= Upcase(gest.username[j]);
						gotoxy(18,11);write('Password: ');
						readln(gest.password);
						for j:= 1 to Length(gest.password)do
							gest.password[j]:= Upcase(gest.password[j]);
						Seek(fich, FilePos(fich)-1);
						write(fich, gest);
						encontrei := True;
						Close(fich);
						ClrScr;
						Progress_Bar;
						ClrScr;
						gotoxy(22,8);textcolor(lightgreen);writeln('Dados alterados com sucesso.');
						gotoxy(22,9);textcolor(white);writeln('Clique enter para voltar ao menu anterior.');
						readln;
					End
				Else encontrei := False;
			End;
		if (encontrei = False)Then
			Begin
				ClrScr;
				Progress_Bar;
				ClrScr;
				textcolor(lightred);gotoxy(22,8);writeln('Gestor(a) nao registado(a).');
				textcolor(white);gotoxy(22,9);writeln('Clique enter para voltar ao menu anterior.');
				readln;
			End;
	End;

Procedure Menu_Gestor(Var fich: arquivo1);
	Label
		menu_gest;
	Begin
		menu_gest:
		ClrScr;
		TEXTCOLOR(BLUE);
		TEXTBACKGROUND(black);
		gotoxy(30,2);writeln('_MENU DO GESTOR_');
		TEXTCOLOR(WHITE);
		TEXTBACKGROUND(BLUE);
		gotoxy(20,10);writeln('  [1] Consultar dados do gestor          ');
		gotoxy(20,11);WriteLn('  [2] Remover dados do gestor            ');
		gotoxy(20,12);writeln('  [3] Alterar dados de acesso ao sistema ');
		gotoxy(20,13);writeln('  [4] Voltar ao menu incial              ');
		gotoxy(20,14);writeln('=========================================');
		gotoxy(20,15);write('>>> ');
		readln(opcao);
		Case(opcao)Of
			1: Begin
						ClrScr;
						Assign(arq1, 'Gestor.dat');
						Dados_Gestor(arq1);
						goto menu_gest;
				 End;
			2: Begin
						ClrScr;
						Assign(arq1, 'Gestor.dat');
						Remover_Gestor(arq1);
						goto menu_gest;
				 End;
			3: Begin
						ClrScr;
						Assign(arq1, 'Gestor.dat');
						Alterar_Dados_As(arq1);
						goto menu_gest;
				 End;
			4: Read;
		End;
	End;

{-----Subprogramas do operador-----}

Function Existe_Operador(var fich: arquivo1): Boolean;
	Begin
		Assign(fich, 'Operador.dat');
		{$I-}
		Reset(fich);
		If IOResult = 0 Then
			Existe_Operador := True
		Else
			Existe_Operador := False;
		{$I+}
	End;

	Procedure Registo_Operador(var fich: arquivo1);
	Begin
		Assign(fich, 'Operador.dat');
		ReWrite(fich);
		func.id :=  1;
		gotoxy(18,7);writeln('ID: ', func.id);delay(1000);
		write(fich, func);
		Close(fich);
	End;

Procedure Add_Registo_Operador(Var fich: arquivo1);
	Begin
		ClrScr;
		Assign(fich, 'Operador.dat');
		Reset(fich);
		Seek(fich, FileSize(fich));
		size := FileSize(fich);
		func.id_op := size + 1;
		gotoxy(18,7);writeln('ID: ', func.id);delay(1000);
		write(fich, func);
		close(fich);
	End;

Procedure Formulario_Operador(var fich: arquivo1);
	Begin
		ClrScr;
		func.perfil := 'OPERADOR CAIXA';
		textcolor(blue);
		textbackground(black);
	  gotoxy(30,2);Writeln('_REGISTO DO OPERADOR_');
	  textcolor(white);
		textbackground(blue);
		GotoXY(18,8);writeln('Perfil: ', func.perfil);
		gotoxy(18,9);write('Nome completo: ');
		readln(func.nome);
		for j := 1 to Length(func.nome)Do
			func.nome[j]:= Upcase(func.nome[j]);
		gotoxy(18,10);write('Data de nascimento(dd/mm/aaaa): ');
		readln(func.nascimento);
		while((copy(func.nascimento,3,1) <> '/')and(copy(func.nascimento,6,1) <> '/')or(Length(func.nascimento) < 10)) do
			Begin
				Delete(func.nascimento,1,Length(func.nascimento));
				GotoXY(18,10); delline;
				gotoxy(18,11);textcolor(lightred);WriteLn('formato incorrecto');
				textcolor(white); readkey; gotoxy(18,11);  ClrEOL;
				gotoxy(18,10);write('Data de nascimento(dd/mm/aaaa): ');
				readln(func.nascimento);
			end;
		gotoxy(18,11);write('Bilhete de identidade: ');
		readln(func.bi);
		for j := 1 to Length(func.bi)Do
			func.bi[j]:= Upcase(func.bi[j]);
		gotoxy(18,12);write('Género: ');
		readln(func.genero);
		for j := 1 to Length(func.genero)do
			func.genero[j]:= Upcase(func.genero[j]);
		gotoxy(18,13);writeln('==================================================');
		gotoxy(18,14);Write('Username: ');
		readln(func.username);
		for j := 1 to Length(func.username)Do
			func.username[j]:= Upcase(func.username[j]);
		gotoxy(18,15);write('Password: ');
		readln(func.password);
		for j:= 1 to Length(func.password)Do
			func.password[j]:= Upcase(func.password[j]);
		while(Length(func.password) < 8) or (Length(func.password) >= 15)do
			Begin
				gotoxy(18,15);delline;
				gotoxy(18,16);textcolor(lightred);WriteLn('introduza 8 caracteres no minimo e 15 no maximo');
								textcolor(white); readkey; gotoxy(18,16);  ClrEOL;
				Delete(func.password,1,Length(func.password));
				gotoxy(18,15);write('Password: ');
				readln(func.password);
				for j:= 1 to Length(gest.password)Do
					func.password[j]:= upcase(func.password[j]);
			End;
		if Existe_Operador(fich) = True Then
			Begin
				Add_Registo_Operador(fich);
			End
		Else
			Begin
				Registo_Operador(fich);
			End;
	End;

Procedure Alterar_Operador(var fich: arquivo1);
	var id_ope: Integer;
			alterar: Boolean;
	Begin
		write('ID: ');
		Readln(id_ope);
		Assign(fich, 'Operario.dat');
		Reset(fich);
		for i:=0 to FileSize(fich)-1 Do
			Begin
				Seek(fich, i);
				Read(fich, func);
				if(id_ope = func.id_op)Then
					Begin
						ClrScr;
						gotoxy(20,3);WriteLn('INFORME NOVOS DADOS');
						gotoxy(18,14);Write('Username: ');
						readln(func.username);
						for j := 1 to Length(func.username)Do
							func.username[j]:= Upcase(func.username[j]);
						gotoxy(18,15);write('Password: ');
						readln(func.password);
						for j:= 1 to Length(func.password)Do
							func.password[j]:= Upcase(func.password[j]);
						while(Length(func.password) < 8) or (Length(func.password) >= 15)do
							Begin
								gotoxy(18,15);delline;
								gotoxy(18,16);textcolor(lightred);WriteLn('introduza 8 caracteres no minimo e 15 no maximo');
								textcolor(white); readkey; gotoxy(18,16);  ClrEOL;
								Delete(func.password,1,Length(func.password));
								gotoxy(18,15);write('Password: ');
								readln(func.password);
								for j:= 1 to Length(gest.password)Do
									func.password[j]:= upcase(func.password[j]);
							End;
						Seek(fich, FilePos(fich)-1);
						Write(fich, func);
						alterar := True;
						ClrScr;
						textcolor(lightgreen);gotoxy(22,8);writeln('Dados alterados com sucesso.');
						textcolor(white);gotoxy(22,9);writeln('Clique enter para voltar ao menu.');
					End;
			End;
		Close(fich);
		if not alterar Then
			Begin
				ClrScr;
				textcolor(lightred);gotoxy(22,8);writeln('Operador(a) nao registado(a).');
				textcolor(white);gotoxy(22,9);writeln('Clique enter para voltar ao menu.');
			End;
	End;

Procedure Remover_Operador(Var fich: arquivo1);
	var id_oper : Integer;
	Begin
		ClrScr;
		textcolor(blue);
		textbackground(black);
		gotoxy(26,2);writeln('_REMOVER DADOS DO OPERADOR_');
		textcolor(white);
		textbackground(blue);
		gotoxy(13,8);write('ID: ');
		readln(id_oper);
		Assign(fich, 'Operador.dat');
		Reset(fich);
		for i:=0 to FileSize(fich)-1 Do
			Begin
				Seek(fich, i);
				Read(fich, gest);
				if(id_oper = func.id_op)Then
					Begin
						Close(fich);
						gotoxy(13,11);writeln('Tem certeza de que deseja remover operador?[S/N]');
						tecla:= ReadKey;
						tecla:= Upcase(tecla);
						if (tecla = 'S')Then
							Begin
								Reset(fich);
								Seek(fich, i+1);
								While not Eof(fich) Do
									Begin
										Read(fich, gest);
										Seek(fich, FilePos(fich)-2);
										Write(fich, gest);
										Seek(fich, FilePos(fich)+1);
									End;
								Seek(fich, FilePos(fich)-1);
								Truncate(fich);
								Close(fich);
								remover_user := True;
								ClrScr;
								Progress_Bar;
								ClrScr;
								gotoxy(22,8);textcolor(lightgreen);writeln('Operador(a) foi removido(a) com sucesso.');
								gotoxy(22,9);textcolor(white);writeln('Clique enter para voltar.');
								readln;
							End
						Else
							Begin
								if (tecla = 'N')Then
									Begin
										ClrScr;
										remover_user := true;
										gotoxy(22,8);writeln('Operacao cancelada.');
										gotoxy(22,9);writeln('Clique enter para voltar ao menu do gestor.');
										readln;
									End
								Else RunError;
							End;
						ClrScr;
					End
				Else remover_user := False;
			End;
		if (remover_user = False) Then
			Begin
				ClrScr;
				Progress_Bar;
				ClrScr;
				textcolor(lightred);gotoxy(22,8);writeln('Operador(a) nao registado(a).');
				textcolor(white);gotoxy(22,9);writeln('Clique enter para voltar ao menu do gestor.');
				readln;
			End;
	End;

	Procedure Pesquisa_ID_Operador(var fich: arquivo1);
	var id_oper: Integer;
	Begin
		gotoxy(30,3);WriteLn('PESQUISA DO OPERADOR');
		GotoXY(20,8);write('ID: ');
		Readln(id_oper);
		Assign(fich, 'Operador.dat');
		Reset(fich);
		for i:=0 to FileSize(fich)-1 Do
			Begin
				Seek(fich, i);
				Read(fich, func);
				if func.id = id_oper Then
					Begin
						ClrScr;
						Textcolor(blue);
					  Textbackground(black);
					  gotoxy(30,3);WriteLn('_INFORMACOES DO FUNCIONARIO_');
					  Textcolor(white);
					  Textbackground(blue);
						gotoxy(2,6);WriteLn('Nome completo: ', func.nome);
						gotoxy(2,7);WriteLn('Data de nascimento: ', func.nascimento);
						gotoxy(2,8);WriteLn('B.I: ', func.bi);
						gotoxy(2,9);WriteLn('Genero: ', func.genero);
						gotoxy(2,10);WriteLn('-----------------------------------');
						gotoxy(2,11);WriteLn('Clique enter para voltar ao menu');
						Readln;
						encontrei := True;
					End;
			End;
		Close(fich);
		if not encontrei then
			Begin
			End;
	End;
{-----Subprogramas de Produtos-----}

Function Existe_Produto(var fich: arquivo2): Boolean;
	Begin
		Assign(fich, 'Produto.dat');
		{$I-}
		Reset(fich);
		If IOResult = 0 Then
			Existe_Produto := True
		Else
			Existe_Produto := False;
		{$I+}
	End;

Procedure Registo_Produto(var fich: arquivo2; reg: Produto);
	Begin
		Assign(fich,'Produto.dat');
		ReWrite(fich);
		write(fich, reg);
		Close(fich);
	End;

Procedure Add_Registo_Produto(Var fich: arquivo2; reg: Produto);
	Begin
		ClrScr;
		Assign(fich,'Produto.dat');
		Reset(fich);
		Seek(fich, FileSize(fich));
		write(fich, reg);
		close(fich);
	End;

Procedure Formulario_Produto(var fich: arquivo2);
	Begin
		ClrScr;
		gotoxy(10,8);write('Quantidade de produtos que deseja registar: ');
		Readln(nr_prod);
		for i:=1 to nr_prod Do
			Begin
				ClrScr;
				Randomize;
				codigo := Random(200);
				Str(codigo, code);
				textcolor(blue);
				textbackground(black);
			  gotoxy(30,2);Writeln('_REGISTO DE PRODUTOS_');
			  textcolor(white);
				textbackground(blue);
				getdate(ano, mes, dia, semana);
				gettime(hora, minuto, segundo, msegundo);
				prod.day := dia;
				prod.weekday := semana;
				prod.mounth := mes;
				prod.year := ano;
				gotoxy(20,8);write('Marca do ',i,'º produto: ');
				Readln(prod.nome_prod);
				for j:=1 to Length(prod.nome_prod)Do
					prod.nome_prod[j]:= Upcase(prod.nome_prod[j]);
				prod.id_prod := concat(copy(prod.nome_prod,1,2),code);
				GotoXY(20,7);WriteLn('ID: ',prod.id_prod);
				GotoXY(20,9);write('Categoria do ',i,'º produto: ');
				Readln(prod.categoria);
				for j:=1 to Length(prod.categoria)Do
					prod.categoria[j]:= Upcase(prod.categoria[j]);
				GotoXY(20,10);write('Tipo do ',i,'º produto: ');
				Readln(prod.tipo);
				for j:=1 to Length(prod.tipo)Do
					prod.tipo[j]:= Upcase(prod.tipo[j]);
				gotoxy(20,11);write('Quantidade do ',i,'º produto: ');
				Readln(prod.quant_prod);
				gotoxy(20,12);write('Preco do ',i,'º produto: ');
				Readln(prod.preco_prod);
				prod.nome_prod_en := prod.nome_prod;
				prod.id_prod_en := prod.id_prod;
				prod.categoria_en := prod.categoria;
				prod.tipo_en := prod.tipo;
				prod.quant_prod_en := prod.quant_prod;
				prod.preco_prod_en := prod.preco_prod;
				if Existe_Produto(fich) = True Then
					Add_Registo_Produto(fich, prod)
				Else
					Registo_Produto(fich, prod);
			End;
	End;

Procedure Alterar_Produto(var fich: arquivo2);
	Begin
		ClrScr;
		gotoxy(20,8);write('ID do produto: ');
		Readln(_id_prod);
		for j:=1 to Length(_id_prod)Do
			_id_prod[j]:= Upcase(_id_prod[j]);
		Assign(fich,'Produto.dat');
		Reset(fich);
		for i:=0 to FileSize(fich)-1 Do
			Begin
				Seek(fich, i);
				Read(fich, prod);
				if (_id_prod = prod.id_prod) Then
					Begin
						ClrScr;
						textcolor(blue);
						textbackground(black);
						gotoxy(28,3);writeln('INFORME NOVOS DADOS DO PRODUTO');
						textcolor(white);
						textbackground(blue);
						gotoxy(20,9);write('Quantidade: ');
						Readln(prod.quant_prod);
						gotoxy(20,10);write('Preco: ');
						Readln(prod.preco_prod);
						Seek(fich, FilePos(fich)-1);
						write(fich, prod);
						encontrei := True;
					End;
			End;
			Close(fich);
			if not encontrei Then
				Begin
					ClrScr;
					gotoxy(25,12);textcolor(lightred);writeln('Produto nao registado.');
					gotoxy(25,13);textcolor(white);writeln('Clique enter para voltar.');
					readln;
				End;
	End;

Procedure Remover_Produto(var fich: arquivo2);
	Begin
		ClrScr;
		gotoxy(20,8);write('ID do produto: ');
		Readln(_id_prod);
		for j:=1 to Length(_id_prod)Do
			_id_prod[j]:= Upcase(_id_prod[j]);
		Assign(fich,'Produto.dat');
		Reset(fich);
		for i:=0 to FileSize(fich)-1 Do
			Begin
				Seek(fich, i);
				Read(fich, prod);
				if _id_prod = prod.id_prod Then
					Begin
						Close(fich);
						writeln('Tem certeza de que deseja remover produto[S/N]?');
						tecla := ReadKey;
						tecla := Upcase(tecla);
						if tecla = 'S' Then
							Begin
								Reset(fich);
			          Seek(fich, i + 1);
			          While Not Eof(fich) Do
			            Begin
			              read(fich, prod);
			              Seek(fich, Filepos(fich) - 2);
			              Write(fich, prod);
			              Seek(fich, Filepos(fich) + 1);
			            End;
			          Seek(fich, Filesize(fich) - 1);
			          Truncate(fich);
								Close(fich);
								encontrei := True;
								ClrScr;
								Progress_Bar;
								ClrScr;
								gotoxy(22,8);textcolor(lightgreen);writeln('Produto foi removido com sucesso.');
								gotoxy(22,9);textcolor(white);writeln('Clique enter para voltar.');
								readln;
							End
						Else
							Begin
								if tecla = 'N' Then
									Begin
										encontrei := True;
										ClrScr;
										gotoxy(22,8);writeln('Operacao cancelada.');
										gotoxy(22,9);writeln('Clique enter para voltar.');
										readln;
									End
								Else RunError;
							End;
					End
				Else encontrei := False;
			End;
		if encontrei = False Then
			Begin
				ClrScr;
				gotoxy(25,12);textcolor(lightred);writeln('Produto nao registado.');
				gotoxy(25,13);textcolor(white);writeln('Clique enter para voltar.');
				readln;
			End;
	End;

Procedure Listar_Produtos_Disponiveis(var fich: arquivo2);
	Var
		x, n: Integer;
	Begin
		ClrScr;
		x:=5;
		n:=1;
		Gotoxy(26,1);Writeln(' LISTA DOS PRODUTOS DISPONÍVEIS ');
	  Gotoxy(2,3);Writeln('#|');
		gotoxy(4,3);WriteLn('ID');
	  Gotoxy(9,3);Writeln('|Marca do Produto');
	  Gotoxy(30,3);WriteLn('|Categoria');
		gotoxy(45,3);WriteLn('|Tipo');
		gotoxy(58,3);Writeln('|Quant.');
	  Gotoxy(66,3);Writeln('|Preco Unitario');
		gotoxy(2,4);WriteLn('-------------------------------------------------------------------------------');
		Assign(fich,'Produto.dat');
	  Reset(fich);
		While Not Eof(fich)Do
			Begin
				Read(fich, prod);
				if (prod.quant_prod > 0) Then
					Begin
						Gotoxy(2,x);Writeln(n,'|');
						gotoxy(4,x);WriteLn(prod.id_prod);
		        Gotoxy(9,x);Writeln('|',prod.nome_prod);
		        Gotoxy(30,x);WriteLn('|',prod.categoria);
						gotoxy(45,x);WriteLn('|',prod.tipo);
						gotoxy(58,x);Writeln('|',prod.quant_prod);
		        Gotoxy(66,x);Writeln('|',prod.preco_prod:0:2,' MZN');
					End;
				x := x+1;
      	n := n+1;
			End;
		writeln;
		Close(fich);
	End;

Procedure Listar_Stock_Produtos(var fich: arquivo2);
	Var
		x, n, y: Integer;
	Begin
		ClrScr;
		x:=5;
		n:=1;
		quant_total_disp := 0;
		capital_total := 0;
		Gotoxy(26,1);Writeln(' LISTA DOS PRODUTOS DISPONÍVEIS ');
	  Gotoxy(2,3);Writeln('#|');
		gotoxy(4,3);WriteLn('ID');
	  Gotoxy(9,3);Writeln('|Marca do Produto');
	  Gotoxy(30,3);WriteLn('|Categoria');
		gotoxy(45,3);WriteLn('|Tipo');
		gotoxy(58,3);Writeln('|Quant.');
	  Gotoxy(66,3);Writeln('|Preco Unitario');
		gotoxy(2,4);WriteLn('-------------------------------------------------------------------------------');
		Assign(fich,'Produto.dat');
	  Reset(fich);
		While Not Eof(fich)Do
			Begin
				Read(fich, prod);
				if (prod.quant_prod < 50)Then
					Begin
						Textcolor(white);
            Gotoxy(2,x);Writeln(n,'|');
						gotoxy(4,x);WriteLn(prod.id_prod);
		        Gotoxy(9,x);Writeln('|',prod.nome_prod);
		        Gotoxy(30,x);WriteLn('|',prod.categoria);
						gotoxy(45,x);WriteLn('|',prod.tipo);
						textcolor(lightred);
						gotoxy(58,x);Writeln('|',prod.quant_prod);
						textcolor(white);
		        Gotoxy(66,x);Writeln('|',prod.preco_prod:0:2,' MZN');
            Textcolor(white);
					End
				Else
					Begin
						if(prod.quant_prod >= 50)and(prod.quant_prod <= 100)Then
							Begin
								Textcolor(white);
		          	Gotoxy(2,x);Writeln(n,'|');
								gotoxy(4,x);WriteLn(prod.id_prod);
				        Gotoxy(9,x);Writeln('|',prod.nome_prod);
				        Gotoxy(30,x);WriteLn('|',prod.categoria);
								gotoxy(45,x);WriteLn('|',prod.tipo);
								textcolor(yellow);
								gotoxy(58,x);Writeln('|',prod.quant_prod);
								textcolor(white);
				        Gotoxy(66,x);Writeln('|',prod.preco_prod:0:2,' MZN');
		            Textcolor(white);
							End
						Else
							Begin
								if(prod.quant_prod > 100)Then
									Begin
										Textcolor(white);
				            Gotoxy(2,x);Writeln(n,'|');
										gotoxy(4,x);WriteLn(prod.id_prod);
						        Gotoxy(9,x);Writeln('|',prod.nome_prod);
						        Gotoxy(30,x);WriteLn('|',prod.categoria);
										gotoxy(45,x);WriteLn('|',prod.tipo);
										textcolor(lightgreen);
										gotoxy(58,x);Writeln('|',prod.quant_prod);
										textcolor(white);
						        Gotoxy(66,x);Writeln('|',prod.preco_prod:0:2,' MZN');
				            Textcolor(white);
									End;
							End; 
					End;
				y:=x+1;
				quant_total_disp := quant_total_disp + prod.quant_prod;
				capital_total := capital_total + prod.preco_prod;
				x := x+1;
      	n := n+1;
			End;
			Textcolor(white);
			gotoxy(2,y);WriteLn('...............................................................................');
			gotoxy(2,y+1);writeln('Total: ');
			gotoxy(58,y+1);Writeln('|',quant_total_disp);
			gotoxy(66, y+1);Writeln('|',capital_total:0:2,' MZN');
			Writeln;
			Textcolor(lightgreen); Write('Verde');
			Textcolor(WHITE); Writeln('- Quantidade estável');
			Textcolor(yellow); Write('Amarelo');
			Textcolor(WHITE); Writeln('- ALERTA  de quantidade razoável');
			Textcolor(lightred); Write('Vermelho');
			Textcolor(WHITE); Writeln('- ALERTA URGENTE a quantidade está abaixo de 50.');
			Close(fich);
	End;

Procedure Recibo(var fich:arquivo3);
	var valor: real;
			x, n, y : Integer;
	Begin
		ClrScr;
		Assign(fich,'Recibo.dat');
		Textcolor(blue);
	  Textbackground(black);
	  gotoxy(30,3);Writeln('_Computer Shop Lda_');
	  Textcolor(white);
	  Textbackground(blue);
		gotoxy(26,4);WriteLn('AV: 25 de Setembro, nº 2580');
		gotoxy(27,5);WriteLn('Telefone: +258 21 828 487');
		gotoxy(31,6);WriteLn('Maputo-Mocambique');
		gotoxy(31,7);WriteLn('NUIT: 130 504 420');
		getdate(ano, mes, dia, semana);
		gettime(hora, minuto, segundo, msegundo);
		gotoxy(2,10);Writeln('Hora: ',hora,':',minuto);
		gotoxy(2,11);Writeln('Data: ',SEMANAS[semana],',',dia,'/',MESES[mes],'/',ano);
		x:=15;
		n:=1;
	  Gotoxy(2,13);Writeln('#|');
		gotoxy(4,13);WriteLn('ID');
	  Gotoxy(9,13);Writeln('|Marca do Produto');
	  Gotoxy(30,13);WriteLn('|Tipo');
		gotoxy(43,13);WriteLn('|Quant.');
		gotoxy(54,13);Writeln('|P.Unitario');
	  Gotoxy(66,13);Writeln('|Valor total');
		gotoxy(2,14);WriteLn('-------------------------------------------------------------------------------');
	  Reset(fich);
		While Not Eof(fich)Do
			Begin
				Read(fich, reci);
				if reci.quant_reci > 0 Then
					Begin
						Gotoxy(2,x);Writeln(n,'|');
						gotoxy(4,x);WriteLn(reci.id_reci);
		        Gotoxy(9,x);Writeln('|',reci.marca);
		        Gotoxy(30,x);WriteLn('|',reci.tipo);
						gotoxy(43,x);WriteLn('|',reci.quant_reci);
						gotoxy(54,x);Writeln('|',reci.preco_uni:0:2);
		        Gotoxy(66,x);Writeln('|',reci.cash:0:2);
						y := x+1;
					End;
				valor := valor + reci.cash;
				x := x+1;
      	n := n+1;
			End;
		Close(fich);
		gotoxy(2,y);WriteLn('-------------------------------------------------------------------------------');
		gotoxy(2,y+1);WriteLn('Sub-total: ');
		gotoxy(58,y+1);WriteLn('|',(valor - (valor*IVA)):0:2, ' MZN');
		gotoxy(2,y+2);WriteLn('IVA(17%): ');
		gotoxy(58,y+2);WriteLn('|',(valor*IVA):0:2, ' MZN');
		gotoxy(2,y+3);writeln('Total: ');
		gotoxy(58,y+3);WriteLn('|',valor:0:2, ' MZN');
		gotoxy(2,y+4);WriteLn('-------------------------------------------------------------------------------');
		gotoxy(2,y+5);WriteLn('Processado por: ', operador);
		gotoxy(2,y+6);WriteLn('-------------------------------------------------------------------------------');
		gotoxy(25,y+7);writeln('Obrigado volte sempre!');
		ReadKey;
		ReWrite(fich);
		Close(fich);
		erase(fich);                                                     
		delay(200);
	End;

Function Existe_Recibo(var fich: arquivo3): Boolean;
	Begin
		Assign(fich,'Recibo.dat');
		{$I-}
		Reset(fich);
		if IOResult = 0 Then
			Existe_Recibo := True
		Else
			Existe_Recibo := False;
		{$I+}
	End;

Procedure Venda_Produto(var fich: arquivo2);
	label atendimento;
	var k: integer;
			id: String;
			tako, preco_uni_: Real;
	Begin
		atendimento:
		ClrScr;
		Textcolor(blue);
	  Textbackground(black);
	  gotoxy(27,3);Writeln('_CAIXA_');
	  Textcolor(white);
	  Textbackground(blue);
		GotoXY(25,8);WriteLn('[1] ATENDIMENTO');
		GotoXY(25,9);WriteLn('[2] Voltar');
		gotoxy(25,10);writeln('===============');
		gotoxy(25,11);write('>>> ');
		Readln(opcao);
		Case(opcao)Of
			1: Begin
						ClrScr;
						GotoXY(25,8);write('Quantidade de produtos desejada:   ');
						readln(nr_prod);
						For j:=1 to nr_prod do
							begin
								clrscr;
								gotoxy(25,7);write('ID: ');
								Readln(id);
								for k:=1 to Length(id) do
									id[k]:=upcase(id[k]);
								gotoxy(25,8);write('Marca do produto:  ');
								readln(_nome_prod);
								for k:=1 to Length(_nome_prod) do
									_nome_prod[k]:=upcase(_nome_prod[k]);
								Assign(fich, 'Produto.dat');
								reset(fich);
				     		for i:= 0 to filesize(fich)-1 do
									Begin
										Seek(fich, i);
										read(fich, prod);
										if(id = prod.id_prod) and (_nome_prod = prod.nome_prod) then
											begin
												getdate(ano, mes, dia, semana);
												gettime(hora, minuto, segundo, msegundo);
												prod.day_sell := dia;
												prod.weekday_sell := semana;
												prod.mounth_sell := mes;
												prod.year_sell := ano;
												prod.nome_prod_vend := prod.nome_prod;
												prod.categoria_vend := prod.categoria;
												prod.tipo_vend := prod.tipo;
												prod.id_prod_vend := prod.id_prod;
												preco_uni_ := prod.preco_prod;
												gotoxy(25,9);writeln('Quantidade existente: ', prod.quant_prod);
												Gotoxy(25,10);write('Quantidade desejada: ');
												readln(_quant_prod);
											 	if (_quant_prod > 0) and (_quant_prod <= prod.quant_prod) then
													begin
														if(prod.nome_prod_vend = prod.nome_prod)and(prod.tipo_vend = prod.tipo)Then
															Begin
																prod.quant_prod_vend := prod.quant_prod_vend + _quant_prod;
																prod.quant_prod := prod.quant_prod - _quant_prod;
																prod.valor_pagar := prod.valor_pagar + (_quant_prod*prod.preco_prod);
																tako := (_quant_prod*prod.preco_prod);
															End
														Else
															Begin
																prod.quant_prod_vend := _quant_prod;
																prod.quant_prod := prod.quant_prod - _quant_prod;
																prod.valor_pagar := _quant_prod*prod.preco_prod;
																tako := prod.valor_pagar;
															End;
														gotoxy(25,11);writeln('O valor a pagar: ', tako:0:2);
														delay(1000);
														reci.marca := prod.nome_prod_vend;
														reci.categ := prod.categoria_vend;
														reci.tipo := prod.tipo_vend;
														reci.id_reci := prod.id_prod_vend;
														reci.quant_reci := _quant_prod;
														reci.preco_uni := preco_uni_;
														reci.cash := tako;
														if Existe_Recibo(arq3) = True Then
															Begin
																Assign(arq3,'Recibo.dat');
																Reset(arq3);
																Seek(arq3, FileSize(arq3));
																write(arq3, reci);
															End
														Else
															Begin
																Assign(arq3,'Recibo.dat');
																ReWrite(arq3);
																write(arq3, reci);
															End;
														close(arq3);
													end
												else
													begin
														ClrScr;
														Gotoxy(25,12);textcolor(lightred);
														writeln('A quantidade solicitada e superior em relacao a quantidade existente');
														textcolor(white);
													end;
													encontrei:=true;
													seek(fich, FilePos(fich)-1);
													write(fich, prod);
											end;
									end;
							 close(fich);
							 if not encontrei then
									Begin
										ClrScr;
										Gotoxy(20,12);textcolor(lightred);
										writeln('O produto solicitado nao existe em nossos registos');
										textcolor(white);
									end;
							end;
						Recibo(arq3);
						goto atendimento;
				 End;
			2: Read
			Else goto atendimento;
		End;
	End;

Procedure Listar_Produtos_Vendidos(var fich: arquivo2);
	Var
		sold: Boolean;
		x, n, y: Integer;
	Begin
		ClrScr;
		x:=5;
		n:=1;
		quant_total_vend := 0;
		capital_total_vend := 0;
		Gotoxy(26,1);Writeln(' LISTA DOS PRODUTOS VENDINDOS ');
	  Gotoxy(2,3);Writeln('#|');
		gotoxy(4,3);WriteLn('ID');
	  Gotoxy(9,3);Writeln('|Marca do Produto');
	  Gotoxy(30,3);WriteLn('|Categoria');
		gotoxy(45,3);WriteLn('|Tipo');
		gotoxy(58,3);Writeln('|Quant.');
	  Gotoxy(66,3);Writeln('|Preco total');
		gotoxy(2,4);WriteLn('-------------------------------------------------------------------------------');
		Assign(fich,'Produto.dat');
	  Reset(fich);
		While Not Eof(fich)Do
			Begin
				Read(fich, prod);
				if prod.quant_prod_vend > 0 Then
					Begin
						Gotoxy(2,x);Writeln(n,'|');
						gotoxy(4,x);WriteLn(prod.id_prod_vend);
		        Gotoxy(9,x);Writeln('|',prod.nome_prod_vend);
		        Gotoxy(30,x);WriteLn('|',prod.categoria_vend);
						gotoxy(45,x);WriteLn('|',prod.tipo_vend);
						gotoxy(58,x);Writeln('|',prod.quant_prod_vend);
		        Gotoxy(66,x);Writeln('|',prod.valor_pagar:0:2,' MZN');
						sold := True;
						y:=x+1;
						x := x+1;
      			n := n+1;
					End;
				quant_total_vend := quant_total_vend + prod.quant_prod_vend;
				capital_total_vend := capital_total_vend + prod.valor_pagar;
			End;
		Close(fich);
		gotoxy(2,y);WriteLn('................................................................................');
		gotoxy(2,y+1);writeln('Total: ');
		gotoxy(58,y+1);Writeln('|',quant_total_vend);
		gotoxy(66, y+1);Writeln('|',capital_total_vend:0:2,' MZN');
		if not sold Then
			Begin
				ClrScr;
				gotoxy(20,8);textcolor(lightred);WriteLn('Nenhuma venda foi efectuada.');
				textcolor(white);gotoxy(20,9);
			End;
	End;

Procedure Reposicao_Produto_Stock(var fich: arquivo2);
	Label _quant_p;
	var quant: Integer;
	Begin
		ClrScr;
		textcolor(blue);
		textbackground(black);
		gotoxy(28,2);writeln('_REPOSICAO DE PRODUTO NO STOCK_');
		textcolor(white);
		textbackground(blue);
		gotoxy(20,6);write('ID do produto: ');
		Readln(_id_prod);
		for j:=1 to Length(_id_prod)Do
			_id_prod[j]:= Upcase(_id_prod[j]);
		Assign(fich,'Produto.dat');
		Reset(fich);
		for i:=0 to FileSize(fich)-1 Do
			Begin
				Seek(fich, i);
				Read(fich, prod);
				if (_id_prod = prod.id_prod) Then
					Begin
						gotoxy(20,7);WriteLn('Marca: ',prod.nome_prod);
						gotoxy(20,8);WriteLn('Categoria: ',prod.categoria);
						gotoxy(20,9);WriteLn('Tipo: ', prod.tipo);
						gotoxy(20,10);write('Preco: ',prod.preco_prod:0:2);
						_quant_p:
						gotoxy(20,11);write('Quantidade: ');
						Readln(quant);
						if quant <= 0 Then
							Begin
								gotoxy(20,12);textcolor(lightred);WriteLn('A quantidade introduzida e invalida');
								gotoxy(20,13);textcolor(white);WriteLn('Pressione qualquer tecla para tentar novamente');
								Readkey; gotoxy(20,11); delline; quant := 0;
								GotoXY(20,12);ClrEOL; gotoxy(20,13);ClrEOL;
								textcolor(white); goto _quant_p;
							End
						Else
							Begin
								prod.quant_prod := prod.quant_prod + quant;
								Seek(fich, FilePos(fich)-1);
								write(fich, prod);
								encontrei := True;
								ClrScr;
								Progress_Bar;
								ClrScr;
								gotoxy(20,7);textcolor(lightgreen);writeln('Reposicao feita com sucesso');
								gotoxy(20,8);textcolor(white);WriteLn('Clique enter para voltar ao menu');
								Readln;
							End;
					End;
			End;
			Close(fich);
			if not encontrei Then
				Begin
					ClrScr;
					gotoxy(25,12);textcolor(lightred);writeln('Produto nao registado.');
					gotoxy(25,13);textcolor(white);writeln('Clique enter para voltar.');
					readln;
				End;
	End;

Procedure Stock(var fich: arquivo2);
	Label stock_;
	Begin
		stock_:
		ClrScr;
		Textcolor(blue);
	  Textbackground(black);
	  gotoxy(27,3);Writeln('_GESTAO DE STOCK_');
	  Textcolor(white);
	  Textbackground(blue);
		gotoxy(25,8);writeln('[1] PRODUTOS VENDIDOS');
		gotoxy(25,9);writeln('[2] GESTAO DE PRODUTOS');
		gotoxy(25,10);WriteLn('[3] REPOSICAO DE PRODUTOS');
		gotoxy(25,11);writeln('[4] Voltar');
		gotoxy(25,12);writeln('=====================');
		gotoxy(25,13);write('>>> ');
		Readln(opcao);
		Case(opcao)Of
			1: Begin
					 ClrScr;
					 Progress_Bar;
					 ClrScr;
					 Listar_Produtos_Vendidos(arq2);
					 WriteLn('Clique enter para voltar ao menu');
					 Readln;   goto stock_;
			 	 End;
			2: Begin
					 ClrScr;
					 Progress_Bar;
					 ClrScr;
					 Listar_Stock_Produtos(arq2);
					 WriteLn('Clique enter para voltar ao menu');
					 Readln; goto stock_;
				 End;
			3: Begin
						ClrScr;
						if user_account = 'GESTOR' then goto stock_
						Else
							Begin
								Reposicao_Produto_Stock(arq2);
								goto stock_;
							End;
				 End;
			4: Read
			Else goto stock_;
		End;
	End;

Function Existe_Relatorio(var arq: Text): Boolean;
	Begin
		{$I-}
		Reset(arq);
		if IOResult = 0 Then
			Existe_Relatorio := True
		Else
			Existe_Relatorio := False;
		{$I+}
	End;

Procedure Relatorio_Geral(var fich: arquivo2);
	Label rel_geral;
	var
		rel_out, rel_in: Text;
		quant_prod_, cash_total,cash_prod, quant_total, quant_total_out, data, d,m,a,
		data_sell, d_sell, m_sell, a_sell, cash_total_out, capital_, _quant_, count_: String;
		total_prod, total_prod_out, _quant_rest, count_prod, _quant, count : Integer;
		total, total_out, capital, capital_final: Real;
	Begin
			Assign(fich, 'Produto.dat');
			rel_geral:
			ClrScr;
			total := 0;
			total_out := 0;
			total_prod := 0;
			total_prod_out := 0;
			count_prod := 0;
			count := 0;
			capital := 0;
			_quant := 0;
			Textcolor(blue);
		  Textbackground(black);
		  gotoxy(30,3);Writeln('_RELATORIOS_');
		  Textcolor(white);
	 		Textbackground(blue);
			gotoxy(25,8);WriteLn('[1] RELATORIO DE ENTRADA');
			gotoxy(25,9);WriteLn('[2] RELATORIO DE SAIDA');
			gotoxy(25,10);WriteLn('[3] Voltar');
			Gotoxy(25,11);WriteLn('=======================');
			gotoxy(25,12);Write('>>> ');
			Readln(opcao);
			Case(opcao)of
				1: Begin
							ClrScr;
							Progress_Bar;
							ClrScr;
							Assign(rel_in, 'Relatorio_IN.txt');
							Existe_Relatorio(rel_in);
							if Existe_Relatorio(rel_in) = True Then
								Begin
									Assign(rel_in, 'Relatorio_IN.txt');
									Append(rel_in);
								End
							Else
								Begin
									Assign(rel_in, 'Relatorio_IN.txt');
									Rewrite(rel_in);
								End;
							Reset(fich);
							Writeln(rel_in,'RELATÓRIO DE ENTRADA DE PRODUTOS');
							WriteLn(rel_in,'.........................................................');
							While Not Eof(fich)Do
								Begin
									Read(fich, prod);
									Str(prod.day, d);
									Str(prod.mounth, m);
									Str(prod.year, a);
									data := Concat(d,'/',m,'/',a);
									Writeln(rel_in,'Data: ',data);
									Writeln(rel_in,'ID: ',prod.id_prod_en);
						      Writeln(rel_in,'Marca: ',prod.nome_prod_en);
						      Writeln(rel_in,'Categoria: ',prod.categoria_en);
						      Writeln(rel_in,'Tipo: ',prod.tipo_en);
									total_prod := total_prod + prod.quant_prod_en;
									Str(prod.quant_prod_en, quant_prod_);
						      Writeln(rel_in,'Quantidade: ',quant_prod_);
									total := total + prod.preco_prod_en;
						      Str(prod.preco_prod_en:0:2, cash_prod);
						      Writeln(rel_in,'Preco: ',cash_prod,' MZN');
									WriteLn(rel_in,'.........................................................');
									Inc(count_prod);
								End;
						  Close(fich);
							Str(total_prod, quant_total);
						  Str(total:0:2,cash_total);
							WriteLn(rel_in,'Numero de produtos: ', count_prod);
							WriteLn(rel_in, 'Quantidade Total: ',quant_total);
						  Writeln (rel_in,'Total: ',cash_total,' MZN');
							WriteLn(rel_in,'.........................................................');
							Close(rel_in);
							shellexecute(0,'open','Relatorio_IN.txt',nil,nil,1);
              goto rel_geral;
					 End;
				2: Begin
							ClrScr;
							Progress_Bar;
							ClrScr;
							Assign(rel_out, 'Relatorio_OUT.txt');
							Existe_Relatorio(rel_out);
							if Existe_Relatorio(rel_out) = True Then
								Begin
									Assign(rel_out, 'Relatorio_OUT.txt');
									Append(rel_out);
								End
							Else
								Begin
									Assign(rel_out, 'Relatorio_OUT.txt');
									Rewrite(rel_out);
								End;
							Writeln(rel_out,'RELATÓRIO DE VENDA DE PRODUTOS');
							WriteLn(rel_out,'.........................................................');
							Reset(fich);
							While Not Eof(fich)Do
								Begin
										Read(fich, prod);
										If prod.quant_prod_vend > 0 Then
											Begin
												Str(prod.day_sell, d_sell);
												Str(prod.mounth_sell, m_sell);
												Str(prod.year_sell, a_sell);
												data_sell := Concat(d_sell,'/',m_sell,'/',a_sell);
												Writeln(rel_out,'Data: ',data_sell);
												Writeln(rel_out,'ID: ',prod.id_prod_vend);
												Writeln(rel_out,'Marca: ',prod.nome_prod_vend);
												Writeln(rel_out,'Categoria: ',prod.categoria_vend);
												Writeln(rel_out,'Tipo: ',prod.tipo_vend);
												total_prod_out := total_prod_out + prod.quant_prod_vend;
												Str(prod.quant_prod_vend, quant_prod_);
												Writeln(rel_out,'Quantidade: ',quant_prod_);
												total_out := total_out + prod.valor_pagar;
												Str(prod.valor_pagar:0:2, cash_prod);
												Writeln(rel_out,'Preco: ',cash_prod,' MZN');
												WriteLn(rel_out,'.........................................................');
												Inc(count_prod);
											End;
										if  prod.quant_prod > 0 Then
											Begin
												_quant  := _quant + prod.quant_prod;
												capital := capital + prod.preco_prod;
												Inc(count);
											End;
								End;
						  Close(fich);
							Str(total_prod_out, quant_total_out);
						  Str(total_out:0:2,cash_total_out);
							WriteLn(rel_out,'Numero de produtos vendidos: ', count_prod);
							WriteLn(rel_out,'Quantidade Total: ',quant_total_out);
						  Writeln (rel_out, 'Rendimento Total: ',cash_total_out,' MZN');
							WriteLn(rel_out,'=========================================================');
							WriteLn(rel_out,'STOCK');
							WriteLn(rel_out,'.........................................................');
							Str(count, count_);
							Str(_quant, _quant_);
							Str(capital:0:2, capital_);
							WriteLn(rel_out,'Numero de produtos restante: ', count_);
							WriteLn(rel_out,'Quantidade restante: ', _quant_);
							WriteLn(rel_out,'Capital total: ', capital_);
							WriteLn(rel_out,'.........................................................');
							Close(rel_out);
							shellexecute(0,'open','Relatorio_OUT.txt',nil,nil,1);
							goto rel_geral;
					 End;
				3: Read
				Else goto rel_geral;
			End;
	End;

Procedure Menu_Produtos;
	Label
		menu_prod;
	Begin
		menu_prod:
		ClrScr;
		Textcolor(blue);
	  Textbackground(black);
	  gotoxy(30,3);Writeln('_GERENCIAMENTO DE PRODUTOS_');
	  Textcolor(white);
	  Textbackground(blue);
		gotoxy(31,9);writeln('[1] REGISTAR PRODUTO');
		gotoxy(31,10);writeln('[2] ALTERAR PRODUTO');
		GotoXY(31,11);writeln('[3] REMOVER PRODUTO');
		GotoXY(31,12);WriteLn('[4] LISTA DE PRODUTOS');
		gotoxy(31,13);WriteLn('[5] VOLTAR');
		GotoXY(31,14);WriteLn('=====================');
		GotoXY(31,15);write('>>> ');
		Readln(opcao);
		Case(opcao)Of
			1: Begin
						ClrScr;
						Formulario_Produto(arq2);
						ClrScr;
						Progress_Bar;
						ClrScr;
						gotoxy(22,8);textcolor(lightgreen);writeln('Produto(s) registado(s) com sucesso.');
						gotoxy(22,9);textcolor(white);writeln('Clique enter para voltar ao menu incial');
						readln; goto menu_prod;
				 End;
			2: Begin
						ClrScr;
						Alterar_Produto(arq2);
						ClrScr;
						Progress_Bar;
						ClrScr;
						gotoxy(22,8);textcolor(lightgreen);writeln('Dados do produto alterados com sucesso.');
						gotoxy(22,9);textcolor(white);writeln('Clique enter para voltar ao menu incial');
						readln;goto menu_prod;
				 End;
			3: Begin
						ClrScr;
						Remover_Produto(arq2);
						goto menu_prod;
				 End;
			4: Begin
						ClrScr;
						Progress_Bar;
						ClrScr;
						Assign(arq2,'Produto.dat');
						Listar_Produtos_Disponiveis(arq2);
						WriteLn('Clique enter para voltar');
						Readln; Goto menu_prod;
				 End;
			5: Read
			Else goto menu_prod;
		End;
	End;

{-----Programa Principal-----}
Begin
	//Design.Layout_2;
	inicio:
	textbackground(blue);
	ClrScr;
	Textcolor(blue);
  Textbackground(black);
  gotoxy(27,3);Writeln('_BEM VINDO AO MENU INICIAL_');
  Textcolor(white);
  Textbackground(blue);
	textcolor(yellow);gotoxy(16,30);
	lowvideo;writeln('Desenvolvedores: Carlos Macaneta & Luana Maculuve');
	normvideo;window(1,1, 255, 255);textbackground(blue);
	gotoxy(25,11);writeln('  [1] Iniciar sessao              ');
	gotoxy(25,12);writeln('  [2] Criar usuário               ');
	gotoxy(25,13);writeln('  [3] Opções                      ');
	gotoxy(25,14);writeln('  [4] Info                        ');
	gotoxy(25,15);WriteLn('  [5] Sair                        ');
	gotoxy(25,16);writeln('==================================');
	gotoxy(25,17);write('>>> ');
	readln(opcao);
	case(opcao)Of
		1: Begin
					login:
					senha := '';
					user_account := '';
					Assign(arq1, 'Gestor.dat');
					Existe_Gestor(arq1);
					if(Existe_Gestor(arq1) = True)Then
						Begin
							ClrScr;
							Textcolor(blue);
		          Textbackground(black);
		          gotoxy(34,3);Writeln('_LOGIN DO GESTOR_');
		          Textcolor(white);
		          Textbackground(blue);
							gotoxy(25,12);write('Username: ');
							textcolor(lightgreen);readln(user);
							for j :=1 to Length(user)do
								user[j]:= Upcase(user[j]);
							gotoxy(25,13);textcolor(white);
							write('Password: ');
							Repeat
								ch := ReadKey;
								if(ch = #8)Then
									Begin
									  if(count > 0)Then
											senha := senha + ch;
											write(#8);write(#32);write(#8);
											Delete(senha, count, 1);
											Dec(count);
										if count <= 0 Then
											senha := '';
									End
								Else
									Begin
										if(ch in [#32..#126])Then
											Begin
												write(#42);
												senha := senha + ch;
												inc(count);
											End;
									End;
							Until(ch = #13);
							for j := 1 to Length(senha)do
								senha[j]:= upcase(senha[j]);
							Assign(arq1, 'Gestor.dat');
							Reset(arq1);
							for i:=0 to FileSize(arq1)-1 Do
								Begin
									Seek(arq1, i);
									Read(arq1, gest);
									if(user = gest.username)and(senha = gest.password)Then
										Begin
											Progress_Bar;
											ClrScr;
											user_account := gest.perfil;
											if Existe_Produto(arq2) = true then
												Begin
													Assign(arq2,'Produto.dat');
													Reset(arq2);
													while Not Eof(arq2)Do
														Begin
															Read(arq2, prod);
															if(prod.quant_prod < 50)Then
																Begin
																	stock_found := true;
																End;
														End;
													Close(arq2);
													if stock_found = True Then
														Begin
															Listar_Stock_Produtos(arq2);
															WriteLn('Clique enter para voltar ao menu');
															Readln; goto menu_2;
														End;
													if not stock_found then goto menu_2;
												end
											Else
												Begin
													menu_2:
													ClrScr;
													Textcolor(blue);
						 							Textbackground(black);
												  Gotoxy(33,2);Writeln ('_MENU PRINCIPAL_');
													Textcolor(white);
						 							Textbackground(blue);
													getdate(ano, mes, dia, semana);
													gettime(hora, minuto, segundo, msegundo);
													gotoxy(3,5);writeln('ID: ',gest.id);
													gotoxy(3,6);writeln('PERFIL: ',gest.perfil);
													gotoxy(38,5);Writeln(hora,':',minuto);
													gotoxy(60,5);Writeln(SEMANAS[semana],',',dia,'/',MESES[mes],'/',ano);
													gotoxy(25,12);writeln('[1] GERENCIAMENTO DE OPERADOR');
													gotoxy(25,13);WriteLn('[2] GESTAO DE STOCK');
													gotoxy(25,14);writeln('[3] RELATORIO');
													gotoxy(25,15);WriteLn('[4] VOLTAR');
													gotoxy(25,16);writeln('============================');
													gotoxy(25,17);write('>>> ');
													Readln(opcao);
													Case(opcao)Of
														1: Begin
																	menu_op:
																	Clrscr;
																	Textcolor(blue);
						         							Textbackground(black);
																  Gotoxy(32,2);
																  Writeln ('_MENU OPERADOR_');
																	Textcolor(white);
						         							Textbackground(blue);
																	Gotoxy(25,10);Writeln('[1] REGISTAR OPERADOR');
																	Gotoxy(25,11);Writeln('[2] EDITAR DADOS DE ACESSO DO OPERADOR');
																	Gotoxy(25,12);Writeln('[3] REMOVER PERFIL DO OPERADOR');
																	Gotoxy(25,13);Writeln('[4] PESQUISAR OPERADOR POR ID');
																	Gotoxy(25,14);Writeln('[5] VOLTAR');
																	gotoxy(25,15);WriteLn('---------------------------------------');
																	gotoxy(25,16);write('>>> ');
																	readln(opcao);
																	Case(opcao)Of
																		1: Begin
																					ClrScr;
																					Formulario_Operador(arq1);
																					goto menu_op;
																			 End;
																		2: Begin
																					ClrScr;
																					Alterar_Operador(arq1);
																					Goto menu_op;
																			 End;
																		3: Begin
																					ClrScr;
																					Remover_Operador(arq1);
																					goto menu_op;
																			 End;
																		4: Begin
																					ClrScr;
																					Pesquisa_ID_Operador(arq1);
																					goto menu_op;
																			 End;
																		5: goto menu_2;
																	End;
															 End;
														2: Begin
																	ClrScr;
																	Stock(arq2);
																	goto menu_2;
															 End;
														3: Begin
																	ClrScr;
																	Relatorio_Geral(arq2);
																	goto menu_2;
															 End;
														4: goto inicio;
														Else goto menu_2;
													End;
													autentica_user := True;
												end;
										End
									Else autentica_user := False;
								End;
								Close(arq1);
							if (autentica_user = False)Then
								Begin
									Assign(arq1, 'Operador.dat');
									Reset(arq1);
									for i:=0 to FileSize(arq1)-1 Do
										Begin
											Seek(arq1, i);
											Read(arq1, func);
											if(user = func.username)and(senha = func.password)Then
												Begin
													user_account := func.perfil;
													operador := func.nome;
													ClrScr;
													Progress_Bar;
													menu:
													ClrScr;
													Textcolor(blue);
						 							Textbackground(black);
												  Gotoxy(33,2);Writeln ('_MENU PRINCIPAL_');
													Textcolor(white);
						 							Textbackground(blue);
													getdate(ano, mes, dia, semana);
													gettime(hora, minuto, segundo, msegundo);
													gotoxy(3,5);writeln('ID: ',func.id);
													gotoxy(3,6);writeln('PERFIL: ',func.perfil);
													gotoxy(38,5);Writeln(hora,':',minuto);
													gotoxy(60,5);Writeln(SEMANAS[semana],',',dia,'/',MESES[mes],'/',ano);
													gotoxy(25,12);writeln('[1] GERENCIAMENTO DE PRODUTOS');
													gotoxy(25,13);WriteLn('[2] CAIXA');
													gotoxy(25,14);writeln('[3] GESTAO DE STOCK');
													gotoxy(25,15);WriteLn('[4] VOLTAR');
													gotoxy(25,16);writeln('============================');
													gotoxy(25,17);write('>>> ');
													Readln(opcao);
													Case(opcao)Of
														1: Begin
																	ClrScr;
																	Menu_Produtos;
																	goto menu;
															 End;
														2: Begin
																	if Existe_Produto(arq2) = True Then
																		Begin
																			clrscr;
																			Venda_Produto(arq2);
																			ClrScr;
																			goto  menu;
																		End
																	Else
																		Begin
																			ClrScr;
																			gotoxy(25,12);textcolor(lightred);writeln('Sem produtos registados em nosso sistema.');
																			gotoxy(25,13);textcolor(white);writeln('Clique enter para voltar');
																			Readln; goto menu;
																		End;
															 End;
														3: Begin
																	if Existe_Produto(arq2) = True Then
																		Begin
																			clrscr;
																			Stock(arq2);
																			goto  menu;
																		End
																	Else
																		Begin
																			ClrScr;
																			gotoxy(25,12);textcolor(lightred);writeln('Sem produtos registados em nosso sistema.');
																			gotoxy(25,13);textcolor(white);writeln('Clique enter para voltar');
																			Readln; goto menu;
																		End;
															 End;
														4: goto inicio;
														Else goto menu;
													End;
													encontrei := True;
												End;
										End;
									Close(arq1);
									if not encontrei Then
										Begin
											gotoxy(25,12);textcolor(lightred);writeln('Username ou password incorrecto.');
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
								End;
						End
					Else
						Begin
							ClrScr;
							textcolor(lightred);gotoxy(22,8);writeln('Sem gestor(es) registado(s).');
							textcolor(white);gotoxy(22,9);writeln('Clique enter para voltar ao menu inicial.');
							readln; goto inicio;
						End;
			 End;
		2: Begin
					ClrScr;
					Formulario_Gestor(arq1);
					ClrScr;
					Progress_Bar;
					ClrScr;
					gotoxy(22,8);textcolor(lightgreen);writeln('Gestor(es) registado(s) com sucesso.');
					gotoxy(22,9);textcolor(white);writeln('Clique enter para voltar ao menu incial');
					readln; goto inicio;
			 End;
		3: Begin
					ClrScr;
					Assign(arq1, 'Gestor.dat');
					Existe_Gestor(arq1);
					if(Existe_Gestor(arq1) = True)Then
						Begin
							Assign(arq1, 'Gestor.dat');
							Menu_Gestor(arq1);
							goto inicio;
						End
					Else
						Begin
							ClrScr;
							textcolor(lightred);gotoxy(22,8);writeln('Sem gestores(es) registado(s).');
							textcolor(white);gotoxy(22,9);writeln('Clique enter para voltar ao menu inicial.');
							readln; goto inicio;
						End;
			 End;
		4: Begin
					ClrScr;
					Progress_Bar;
					ClrScr;
					shellexecute(0,'open','INFO.docx',Nil, Nil,1);
					Goto inicio;
			 End;
		5: Begin
					deseja_continuar:
					textcolor(yellow);
					GotoXY(25,17); delline;
					GotoXY(24,17);writeln('Tem certeza de que deseja sair[S/N]?');
					tecla:= ReadKey;
					tecla:= Upcase(tecla);
					if(tecla = 'S')then Exit
					Else
						Begin
							If(tecla = 'N')Then goto inicio
							Else goto deseja_continuar;
						end;
			 End;
		Else goto inicio;
	End;
End.