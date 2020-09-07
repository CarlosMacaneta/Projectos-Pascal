Program CRUD;
Uses crt, dos, shellapi;

Label
	inicio, login, menu, deseja_continuar, nova_conta, tente_novamente, vende;

Const
	SEMANAS: Array [0..6] of String = ('Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab');
	MESES: Array [1..12] of String = ('Janeiro', 'Fevereiro', 'Marco', 'Abril', 'Maio', 'Junho',
	'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro');

Type
	Gestor = Record
		username, password: String[15];
		nome, endereco, perfil: String;
		nascimento, genero: string[10];
		bi: String[13];
		id: Integer;
	End;
	arquivo1 = File Of Gestor;
	Recyclebin = Record
		recy_username, recy_password: String[15];
		recy_nome, recy_endereco, recy_perfil: String;
		recy_nascimento, recy_genero: string[10];
		recy_bi: String[13];
		estado: Boolean;
		recy_id: Integer;
	End;
	archive1 = File Of Recyclebin;
	Funcionario = Record
		username, password: String[15];
		nome, endereco, perfil: String;
		nascimento, genero: string[10];
		bi: String[13];
		id: Integer;
	End;
	arquivo2 = File Of Funcionario;
	Backup = Record
		back_username, back_password: String[15];
		back_nome, back_endereco, back_perfil: String;
		back_nascimento, back_genero: string[10];
		back_bi: String[13];
		estado: Boolean;
		back_id: Integer;
	End;
	archive2 = File Of Backup;
	Produto = Record
		nome_prod, nome_prod_vend, categoria, categoria_vend, id_prod, id_prod_vend: String;
		preco, preco_vend, valor_pagar: Real;
		quantidade, quant_prod_vend: Integer;
	End;
	arquivo3 = File Of Produto;

Var
	arq1: arquivo1;
	gest: Gestor;
	arq2: arquivo2;
	func: Funcionario;
	arc1: archive1;
	recb: Recyclebin;
	arc2: archive2;
	back: Backup;
	arq3: arquivo3;
	prod: Produto;
	i, n, j, size, autentica_id, opcao, count, codigo, codigo_erro, tamanho, quant_total_vend, nr_prod, _quant_prod: Integer;
	senha, user, vazio, perfil_gest, code, _id_prod, _nome_prod: String;
	dia, semana, mes, ano, hora, minuto, segundo, msegundo, _dia_, _mes_, _ano_: Word;
	encontrei, autentica, remover, actualiza, autentica_user: Boolean;
	tecla, caracter, sexo: Char;
	capital_total_vend, media: Real;

Procedure Uppercase(var palavra: String);
	Begin
		for j:=1 to Length(palavra)Do
			palavra[j] := Upcase(palavra[j]);
	End;

{---------------Gestor---------------}
Function Existe_Gestor(var fich: arquivo1): Boolean;
	Begin
		Assign(fich,'Gestor.dat');
		{$I-}
			Reset(fich);
			if IOResult = 0 Then
				Existe_Gestor := True
			Else
				Existe_Gestor := False
		{$I+}
	End;

Procedure Registo(var fich: arquivo1);
	var profile: String;
	Begin
		textcolor(blue);
		textbackground(black);
	  gotoxy(30,2);Writeln('_REGISTO_');
	  textcolor(white);
		textbackground(blue);
		gest.perfil := 'GESTOR';
		GotoXY(18,8);writeln('Perfil: ', gest.perfil);
		gotoxy(18,9);write('Nome completo: ');
		Readln(gest.nome);
		Uppercase(gest.nome);
		gotoxy(18,10);write('Data de nascimento(dd/mm/aaaa): ');
		Readln(gest.nascimento);
		val((copy(gest.nascimento,1,2)), _dia_, codigo_erro);
		val((copy(gest.nascimento,4,2)), _mes_, codigo_erro);
		val((copy(gest.nascimento,7,2)), _ano_, codigo_erro);
		while(((_dia_ = 0)or( _dia_ > 31 ))or((_mes_ = 0)or(_mes_ > 12))or((_ano_ = 0)or(_ano_ >= 2019))or(copy(gest.nascimento,3,1) <> '/')and(copy(gest.nascimento,6,1) <> '/')or(Length(gest.nascimento) < 10)) do
			Begin
				Delete(gest.nascimento,1,Length(gest.nascimento));
				gotoxy(18,11);textcolor(lightred);WriteLn('O formato introduzido e incorrecto');
				textcolor(white); readkey; gotoxy(18,11);  ClrEOL; gotoxy(18,10); delline;
				gotoxy(18,10);write('Data de nascimento(dd/mm/aaaa): ');
				read(gest.nascimento);
			end;
		gotoxy(18,11);write('Bilhete de identidade: ');
		Readln(gest.bi);
		While((Length(gest.bi) < 13)or(Length(gest.bi) > 13))Do
			Begin
				Delete(gest.nascimento,1,Length(gest.nascimento));
				gotoxy(18,12);textcolor(lightred);WriteLn('O numero introduzido e incorrecto');
				textcolor(white); readkey; gotoxy(18,12);  ClrEOL; gotoxy(18,11); delline;
				gotoxy(18,11);write('Bilhete de identidade: ');
				Read(gest.bi);
			End;
		Uppercase(gest.bi);
		GotoXY(18,12);write('Genero[M/F]: ');
		sexo := ReadKey;
		sexo := Upcase(sexo);
		Repeat
			if( sexo = 'M' )Then
				Begin
					gest.genero := 'MASCULINO';
				End
			Else
				Begin
					if( sexo = 'F' )Then
						Begin
							gest.genero := 'FEMENINO';
						End
					Else
						Begin
							gotoxy(18,13);textcolor(lightred);WriteLn('O genero introduzido e invalido');
							textcolor(white); readkey; gotoxy(18,13);  ClrEOL; gotoxy(18,12); delline;
							GotoXY(18,12);write('Genero[M/F]: ');
							sexo := ReadKey;
							sexo := Upcase(sexo);
						End;
				End;
		Until((gest.genero = 'MASCULINO') or (gest.genero = 'FEMENINO'));
		GotoXY(18,12);write('Genero[M/F]: ',gest.genero);
		GotoXY(18,13);write('Endereco: ');
		Readln(gest.endereco);
		Uppercase(gest.endereco);
		gotoxy(18,14);write('=================================');
		gotoxy(18,15);write('Nome do usuario: ');
		Readln(gest.username);
		Uppercase(gest.username);
		GotoXY(18,16);write('Palavra-passe: ');
		Readln(gest.password);
		while(Length(gest.password) < 8) or (Length(gest.password) >= 15)do
			Begin
				Delete(gest.password,1,Length(gest.password));
				gotoxy(18,17);textcolor(lightred);WriteLn('Introduza 8 caracteres no minimo e 15 no maximo');
				textcolor(white); readkey; gotoxy(18,17);  ClrEOL; gotoxy(18,16);delline;
				gotoxy(18,15);write('Palavra-passe: ');
				read(gest.password);
			End;
		Uppercase(gest.password);
		if Existe_Gestor(fich) = True Then
			Begin
				Assign(fich,'Gestor.dat');
				Reset(fich);
				Seek(fich, FileSize(fich));
				size := FileSize(fich);
				Seek(fich, FileSize(fich));
				if FileSize(fich) >= 0 Then
					gest.id := size+1;
				GotoXY(18,7);writeln('ID: ', gest.id);delay(1000);
				Write(fich, gest);
			End
		Else
			Begin
				Assign(fich,'Gestor.dat');
				ReWrite(fich);
				gest.id := 1;
				GotoXY(18,7);writeln('ID: ', gest.id);delay(1000);
				Write(fich, gest);
			End;
		Close(fich);
		ClrScr;
		textcolor(lightgreen);gotoxy(22,8);writeln('GESTOR registado com sucesso.');
		textcolor(white);gotoxy(22,9);writeln('Clique enter para voltar ao menu');
		Readln;
	End;

Procedure Visualizar_Dados(var fich: arquivo1);
	Begin
		Assign(fich,'Gestor.dat');
		Reset(fich);
		for i:=0 to FileSize(fich)-1 do
			Begin
				Seek(fich, i);
				Read(fich, gest);
				if (gest.id = autentica_id) Then
					Begin
						ClrScr;
						textcolor(blue);
						textbackground(black);
						gotoxy(34,3);writeln('_DADOS PESSOAIS_');
						textcolor(white);
						textbackground(blue);
						gotoxy(10,7);writeln('ID: ', gest.id);
						gotoxy(10,8);writeln('PERFIL: ', gest.perfil);
						gotoxy(10,9);writeln('NOME: ', gest.nome);
						gotoxy(10,10);writeln('DATA DE NASCIMENTO: ', gest.nascimento);
						gotoxy(10,11);writeln('BILHETE DE IDENTIDADE: ', gest.bi);
						gotoxy(10,12);writeln('GENERO: ', gest.genero);
						gotoxy(10,13);WriteLn('ENDERECO: ', gest.endereco);
						textcolor(blue);
						textbackground(black);
						gotoxy(29,15);writeln('_DADOS DE ACESSO AO SISTEMA_');
						TEXTCOLOR(white);
						textbackground(blue);
						gotoxy(10,18);writeln('Nome do usuario: ', gest.username);
						gotoxy(10,19);writeln('Palavra-passe: ', gest.password);
						encontrei:= True;
						gotoxy(10,20);writeln('-------------------------------');
						gotoxy(10,21);writeln('Clique [enter] para voltar ');
						readln;
					End
			End;
			Close(fich);
			If Not encontrei Then
				Begin
					ClrScr;
					gotoxy(25,12);textcolor(lightred);writeln('Funcionario(a) nao registado(a).');
					gotoxy(25,13);textcolor(white);writeln('Clique enter para voltar');
					Readln;
				End;
	End;

Procedure Alterar_Dado(var fich: arquivo1);
	Label change;
	Begin
		change:
		ClrScr;
		TEXTCOLOR(BLUE);
		TEXTBACKGROUND(black);
		gotoxy(30,2);writeln('_ALTERAR DADOS_');
		TEXTCOLOR(WHITE);
		TEXTBACKGROUND(BLUE);
		gotoxy(20,8);WriteLn('[1] ALTERAR DADOS PESSOAIS');
		GotoXY(20,9);WriteLn('[2] ALETERAR DADOS DE ACESSO AO SISTEMA');
		gotoxy(20,10);writeln('[3] VOLTAR');
		GOTOXY(20,11);writeln('----------------------------------------');
		gotoxy(20,12);Write('>>> ');
		Readln(opcao);
		Case(opcao)Of
			1: Begin
						ClrScr;
						Assign(fich,'Gestor.dat');
						Reset(fich);
						textcolor(blue);
						textbackground(black);
					  gotoxy(30,2);Writeln('_ALTERAR DADOS PESSOAIS_');
					  textcolor(white);
						textbackground(blue);
						Gotoxy(18,7);WriteLn('ID: ', gest.id);
						GotoXY(18,8);writeln('Perfil: ', gest.perfil);
						gotoxy(18,9);write('Nome completo: ');
						Readln(gest.nome);
						Uppercase(gest.nome);
						gotoxy(18,10);write('Data de nascimento(dd/mm/aaaa): ');
						Readln(gest.nascimento);
						val((copy(gest.nascimento,1,2)), _dia_, codigo_erro);
						val((copy(gest.nascimento,4,2)), _mes_, codigo_erro);
						val((copy(gest.nascimento,7,2)), _ano_, codigo_erro);
						while(((_dia_ = 0)or( _dia_ > 31 ))or((_mes_ = 0)or(_mes_ > 12))or((_ano_ = 0)or(_ano_ >= 2019))or(copy(gest.nascimento,3,1) <> '/')and(copy(gest.nascimento,6,1) <> '/')or(Length(gest.nascimento) < 10)) do
							Begin
								Delete(gest.nascimento,1,Length(gest.nascimento));
								gotoxy(18,11);textcolor(lightred);WriteLn('O formato introduzido e incorrecto');
								textcolor(white); readkey; gotoxy(18,11);  ClrEOL; gotoxy(18,10); delline;
								gotoxy(18,10);write('Data de nascimento(dd/mm/aaaa): ');
								read(gest.nascimento);
							end;
						gotoxy(18,11);write('Bilhete de identidade: ');
						Readln(gest.bi);
						While((Length(gest.bi) < 13)or(Length(gest.bi) > 13))Do
							Begin
								Delete(gest.nascimento,1,Length(gest.nascimento));
								gotoxy(18,12);textcolor(lightred);WriteLn('O numero introduzido e incorrecto');
								textcolor(white); readkey; gotoxy(18,12);  ClrEOL; gotoxy(18,11); delline;
								gotoxy(18,11);write('Bilhete de identidade: ');
								Read(gest.bi);
							End;
						Uppercase(gest.bi);
						GotoXY(18,12);write('Genero[M/F]: ',gest.genero);
						GotoXY(18,13);write('Endereco: ');
						Readln(gest.endereco);
						Uppercase(gest.endereco);
						Seek(fich, FilePos(fich)-1);
						write(fich, gest);
						Close(fich);
				 end;
			2: Begin
						ClrScr;
						textcolor(blue);
						textbackground(black);
					  gotoxy(30,2);Writeln('_ALTERAR DADOS DE ACESSO AO SISTEMA_');
					  textcolor(white);
						textbackground(blue);
						gotoxy(20,8);write('Nome do usuario: ');
						Readln(gest.username);
						Uppercase(gest.username);
						GotoXY(20,8);write('Palavra-passe: ');
						Readln(gest.password);
						while(Length(gest.password) < 8) or (Length(gest.password) >= 15)do
							Begin
								Delete(gest.genero,1,Length(gest.genero));
								gotoxy(20,9);textcolor(lightred);WriteLn('Introduza 8 caracteres no minimo e 15 no maximo');
								textcolor(white); readkey; gotoxy(20,9);  ClrEOL; gotoxy(18,8);delline;
								gotoxy(20,8);write('Palavra-passe: ');
								read(gest.password);
							End;
						Uppercase(gest.password);
						Seek(fich, FilePos(fich)-1);
						write(fich, gest);
						Close(fich);
				 End;
			3: Read
			Else goto change;
		End;
		ClrScr;
		textcolor(lightgreen);gotoxy(5,8);writeln('Dados alterados com sucesso.');
		textcolor(white);gotoxy(5,9);writeln('Clique enter para voltar ao menu');
		Readln;
	End;

Function Existe_Reciclagem: Boolean;
	Begin
	   Assign(arc1,'RecycleBin.bin');
		 {$I-}
		 	Reset(arc1);
			If IOResult = 0 Then
				Existe_Reciclagem := True
			Else
				Existe_Reciclagem := False;
		 {$I+}
	End;

Procedure Recycle;
	Begin
		if Existe_Reciclagem = true Then
			Begin
				Assign(arc1,'RecycleBin.bin');
				Reset(arc1);
				Seek(arc1, FileSize(arc1));
				write(arc1, recb);
				Close(arc1);
			End
		Else
			Begin
				Assign(arc1,'RecycleBin.bin');
				ReWrite(arc1);
				write(arc1, recb);
				Close(arc1);
			End;
	End;

Procedure Remover_(var fich: arquivo1);
	Var ident : Integer;
		nome_del: String;
	Begin
		ClrScr;
		textcolor(blue);
		textbackground(black);
	  gotoxy(30,2);Writeln('_REMOVER DADOS_');
	  textcolor(white);
		textbackground(blue);
		GotoXY(18,7);writeln('ID: ');
		Readln(autentica_id);
		Assign(fich,'Gestor.dat');
		Reset(fich);
		for i:=0 to FileSize(fich)-1 do
			Begin
				Seek(fich, i);
				Read(fich, gest);
				if(autentica_id = gest.id)Then
					Begin
						recb.estado := true;
						recb.recy_id := gest.id;
						recb.recy_perfil := gest.perfil;
						recb.recy_nome := gest.nome;
						recb.recy_nascimento := gest.nascimento;
						recb.recy_bi := gest.bi;
						recb.recy_genero := gest.genero;
						recb.recy_endereco := gest.endereco;
						recb.recy_username := gest.username;
						recb.recy_password := gest.password;
						Recycle;
						gotoxy(18,6);WriteLn('Perfil: ', gest.id);
						gotoxy(18,8);WriteLn('Nome: ',gest.nome);
						Close(fich);
						gotoxy(18,9);WriteLn('Tem certeza que deseja eliminar conta [S/N]?');
						tecla := ReadKey;
						tecla := Upcase(tecla);
						if tecla = 'S' Then
							Begin
								Reset(fich);
			          Seek(fich, i + 1);
			          While Not Eof(fich) Do
			            Begin
			              read(fich, gest);
			              Seek(fich, Filepos(fich) - 2);
			              Write(fich, gest);
			              Seek(fich, Filepos(fich) + 1);
			            End;
			          Seek(fich, Filesize(fich) - 1);
			          Truncate(fich);
								Close(fich);
								remover := True;
								ClrScr;
								WriteLn('Usuario removido com sucesso');
								writeln('Clique [enter] para voltar');
								Readln;
							End
						Else
							Begin
								if tecla = 'N' Then
									Begin
										ClrScr;
										WriteLn('Operacao cancelada');
										writeln('Clique [enter] para voltar');
										Readln;
									End
								Else RunError;
							End;
					End;
			End;
		if not remover Then
			Begin
				ClrScr;
				gotoxy(20,5);textcolor(lightred);WriteLn('ID nao encontrado em nossos registos');
				gotoxy(20,6);textcolor(white);WriteLn('Clique [enter] para voltar');
				Readln;
			End;
	End;

Procedure Recupera_Info;
	Begin
		write('ID: ');
		Readln(autentica_id);
		Assign(arc1,'RecycleBin.bin');
		Reset(arc1);
		for i:=0 to FileSize(arc1)-1 Do
			Begin
				Seek(arc1, i);
				Read(arc1, recb);
				if autentica_id = recb.recy_id Then
					Begin
						gotoxy(18,8);WriteLn('Perfil: ', recb.recy_perfil);
						gotoxy(18,9);WriteLn('Nome completo: ', recb.recy_nome);
						GotoXY(18,10);WriteLn('Tem certeza de que deseja recuperar estes dados?[S/N]');
						tecla := ReadKey;
						tecla := Upcase(tecla);
						if tecla = 'S' Then
							Begin
								recb.estado := True;
								gest.id := recb.recy_id;
								gest.perfil := recb.recy_perfil;
								gest.nome := recb.recy_nome;
								gest.nascimento := recb.recy_nascimento;
								gest.bi := recb.recy_bi;
								gest.genero := recb.recy_genero;
								gest.endereco := recb.recy_endereco;
								gest.username := recb.recy_username;
								gest.password := recb.recy_password;
								Assign(arq1, 'Gestor.dat');
								Reset(arq1);
								Seek(arq1, FileSize(arq1));
								write(arq1, gest);
								Close(arq1);
								if recb.estado = True Then
									Begin
										Reset(arc1);
					          Seek(arc1, i + 1);
					          While Not Eof(arc1) Do
					            Begin
					              read(arc1, recb);
					              Seek(arc1, Filepos(arc1) - 2);
					              Write(arc1, recb);
					              Seek(arc1, Filepos(arc1) + 1);
					            End;
					          Seek(arc1, Filesize(arc1) - 1);
					          Truncate(arc1);
										Close(arc1);
									End;
								ClrScr;
								gotoxy(22,5);textcolor(lightgreen);WriteLn('Dados recuperados com sucesso.');
								gotoxy(22,6);textColor(white);WriteLn('Clique [enter] para voltar');
								Readln;
						  End
						Else
							Begin
								ClrScr;
								gotoxy(22,5);WriteLn('Operacao cancela com sucesso.');
								gotoxy(22,6);WriteLn('Clique [enter] para voltar');
								Readln;
							End;
						encontrei := True;
					End;
			End;
		Close(arc1);
		if not encontrei then
			Begin
				ClrScr;
				gotoxy(22,5);textcolor(lightred);WriteLn('ID introduzido nao encontrado');
				gotoxy(22,6);textcolor(white);WriteLn('Clique [enter] para voltar');
				Readln;
			End;
	End;

{---------------FUNCIONARIO---------------}
Function Existe_Funcionario(var fich: arquivo2): Boolean;
	Begin
		Assign(fich,'Funcionario.dat');
		{$I-}
			Reset(fich);
			if IOResult = 0 Then
				Existe_Funcionario := True
			Else
				Existe_Funcionario := False
		{$I+}
	End;

Procedure Registo_Func(var fich: arquivo2);
	var profile: String;
	Begin
		textcolor(blue);
		textbackground(black);
	  gotoxy(30,2);Writeln('_REGISTO_');
	  textcolor(white);
		textbackground(blue);
		func.perfil := 'FUNCIONARIO';
		GotoXY(18,8);writeln('Perfil: ', func.perfil);
		gotoxy(18,9);write('Nome completo: ');
		Readln(func.nome);
		Uppercase(func.nome);
		gotoxy(18,10);write('Data de nascimento(dd/mm/aaaa): ');
		Readln(func.nascimento);
		val((copy(func.nascimento,1,2)), _dia_, codigo_erro);
		val((copy(func.nascimento,4,2)), _mes_, codigo_erro);
		val((copy(func.nascimento,7,2)), _ano_, codigo_erro);
		while(((_dia_ = 0)or( _dia_ > 31 ))or((_mes_ = 0)or(_mes_ > 12))or((_ano_ = 0)or(_ano_ >= 2019))or(copy(func.nascimento,3,1) <> '/')and(copy(func.nascimento,6,1) <> '/')or(Length(func.nascimento) < 10)) do
			Begin
				Delete(func.nascimento,1,Length(func.nascimento));
				gotoxy(18,11);textcolor(lightred);WriteLn('O formato introduzido e incorrecto');
				textcolor(white); readkey; gotoxy(18,11);  ClrEOL; gotoxy(18,10); delline;
				gotoxy(18,10);write('Data de nascimento(dd/mm/aaaa): ');
				read(func.nascimento);
			end;
		gotoxy(18,11);write('Bilhete de identidade: ');
		Readln(func.bi);
		While((Length(func.bi) < 13)or(Length(func.bi) > 13))Do
			Begin
				Delete(func.nascimento,1,Length(func.nascimento));
				gotoxy(18,12);textcolor(lightred);WriteLn('O numero introduzido e incorrecto');
				textcolor(white); readkey; gotoxy(18,12);  ClrEOL; gotoxy(18,11); delline;
				gotoxy(18,11);write('Bilhete de identidade: ');
				Read(func.bi);
			End;
		Uppercase(func.bi);
		GotoXY(18,12);write('Genero[M/F]: ');
		sexo := ReadKey;
		sexo := Upcase(sexo);
		Repeat
			if( sexo = 'M' )Then
				Begin
					func.genero := 'MASCULINO';
				End
			Else
				Begin
					if( sexo = 'F' )Then
						Begin
							func.genero := 'FEMENINO';
						End
					Else
						Begin
							gotoxy(18,13);textcolor(lightred);WriteLn('O genero introduzido e invalido');
							textcolor(white); readkey; gotoxy(18,13);  ClrEOL; gotoxy(18,12); delline;
							GotoXY(18,12);write('Genero[M/F]: ');
							sexo := ReadKey;
							sexo := Upcase(sexo);
						End;
				End;
		Until((func.genero = 'MASCULINO') or (func.genero = 'FEMENINO'));
		GotoXY(18,12);write('Genero[M/F]: ',func.genero);
		GotoXY(18,13);write('Endereco: ');
		Readln(func.endereco);
		Uppercase(func.endereco);
		gotoxy(18,14);write('=================================');
		gotoxy(18,15);write('Nome do usuario: ');
		Readln(func.username);
		Uppercase(func.username);
		GotoXY(18,16);write('Palavra-passe: ');
		Readln(func.password);
		while(Length(func.password) < 8) or (Length(func.password) >= 15)do
			Begin
				Delete(func.password,1,Length(func.password));
				gotoxy(18,17);textcolor(lightred);WriteLn('Introduza 8 caracteres no minimo e 15 no maximo');
				textcolor(white); readkey; gotoxy(18,17);  ClrEOL; gotoxy(18,16);delline;
				gotoxy(18,15);write('Palavra-passe: ');
				read(func.password);
			End;
		Uppercase(func.password);
		if Existe_funcionario(fich) = True Then
			Begin
				Assign(arq1, 'Gestor.dat');
				Reset(arq1);
				size := FileSize(arq1);
				Close(arq1);
				Assign(fich,'Funcionario.dat');
				Reset(fich);
				Seek(fich, FileSize(fich));
				tamanho := FileSize(fich);
				if size >= 0 Then
					func.id := tamanho+2;
				GotoXY(18,7);writeln('ID: ', func.id);delay(1000);
				Write(fich, func);
			End
		Else
			Begin
				Assign(arq1, 'Gestor.dat');
				Reset(arq1);
				size := FileSize(arq1);
				Close(arq1);
				Assign(fich,'Funcionario.dat');
				ReWrite(fich);
				if size >= 0 Then
					func.id := size+1;
				GotoXY(18,7);writeln('ID: ', func.id);delay(1000);
				Write(fich, func);
			End;
		Close(fich);
		ClrScr;
		textcolor(lightgreen);gotoxy(22,8);writeln('Funcionario registado com sucesso.');
		textcolor(white);gotoxy(22,9);writeln('Clique enter para voltar ao menu');
		Readln;
	End;

Procedure Pesquisar_Dados(var fich: arquivo2);
	Begin
		Assign(fich,'Funcionario.dat');
		Reset(fich);
		for i:=0 to FileSize(fich)-1 do
			Begin
				Seek(fich, i);
				Read(fich, func);
				if (func.id = autentica_id) Then
					Begin
						ClrScr;
						textcolor(blue);
						textbackground(black);
						gotoxy(34,3);writeln('_DADOS PESSOAIS_');
						textcolor(white);
						textbackground(blue);
						gotoxy(10,7);writeln('ID: ', func.id);
						gotoxy(10,8);writeln('PERFIL: ', func.perfil);
						gotoxy(10,9);writeln('NOME: ', func.nome);
						gotoxy(10,10);writeln('DATA DE NASCIMENTO: ', func.nascimento);
						gotoxy(10,11);writeln('BILHETE DE IDENTIDADE: ', func.bi);
						gotoxy(10,12);writeln('GENERO: ', func.genero);
						gotoxy(10,13);WriteLn('ENDERECO: ', func.endereco);
						encontrei:= True;
						gotoxy(10,14);writeln('-------------------------------');
						gotoxy(10,15);writeln('Clique [enter] para voltar ');
						readln;
					End
			End;
			Close(fich);
			If Not encontrei Then
				Begin
					ClrScr;
					gotoxy(25,12);textcolor(lightred);writeln('Funcionario(a) nao registado(a).');
					gotoxy(25,13);textcolor(white);writeln('Clique enter para voltar');
					Readln;
				End;
	End;

Procedure Listar_Func(var fich: arquivo2);
	Begin
		ClrScr;
		textcolor(blue);
		textbackground(black);
		gotoxy(34,1);writeln('_LISTA DE FUNCIONARIOS_');
		textcolor(white);
		textbackground(blue);
		Assign(fich,'Funcionario.dat');
		Reset(fich);
		While Not Eof(fich)Do
			Begin
				Read(fich, func);
				writeln('ID: ', func.id);
				writeln('PERFIL: ', func.perfil);
				writeln('NOME: ', func.nome);
				writeln('DATA DE NASCIMENTO: ', func.nascimento);
				writeln('BILHETE DE IDENTIDADE: ', func.bi);
				writeln('GENERO: ', func.genero);
				WriteLn('ENDERECO: ', func.endereco);
				writeln('--------------------------------------------');
			End;
			Close(fich);
			WriteLn('Clique [enter] para voltar');
			Readln;
	End;

Procedure Alterar_Dados_Pessoais(var fich: arquivo2);
	Begin
		textcolor(blue);
		textbackground(black);
	  gotoxy(30,2);Writeln('_ALTERAR DADOS DO FUNCIONARIO_');
	  textcolor(white);
		textbackground(blue);
		GOTOXY(18,7);Write('ID: ');
		Readln(autentica_id);
		Assign(fich,'Funcionario.dat');
		Reset(fich);
		for i:=0 to FileSize(fich)-1 Do
			Begin
				Seek(fich, i);
				Read(fich, func);
				if(autentica_id = func.id)Then
					Begin
						GotoXY(18,8);writeln('Perfil: ', func.perfil);
						gotoxy(18,9);write('Nome completo: ');
						Readln(func.nome);
						Uppercase(func.nome);
						gotoxy(18,10);write('Data de nascimento(dd/mm/aaaa): ');
						Readln(func.nascimento);
						val((copy(func.nascimento,1,2)), _dia_, codigo_erro);
						val((copy(func.nascimento,4,2)), _mes_, codigo_erro);
						val((copy(func.nascimento,7,2)), _ano_, codigo_erro);
						while(((_dia_ = 0)or( _dia_ > 31 ))or((_mes_ = 0)or(_mes_ > 12))or((_ano_ = 0)or(_ano_ >= 2019))or(copy(func.nascimento,3,1) <> '/')and(copy(func.nascimento,6,1) <> '/')or(Length(func.nascimento) < 10)) do
							Begin
								Delete(func.nascimento,1,Length(func.nascimento));
								gotoxy(18,11);textcolor(lightred);WriteLn('O formato introduzido e incorrecto');
								textcolor(white); readkey; gotoxy(18,11);  ClrEOL; gotoxy(18,10); delline;
								gotoxy(18,10);write('Data de nascimento(dd/mm/aaaa): ');
								read(func.nascimento);
							end;
						gotoxy(18,11);write('Bilhete de identidade: ');
						Readln(func.bi);
						While((Length(func.bi) < 13)or(Length(func.bi) > 13))Do
							Begin
								Delete(func.nascimento,1,Length(func.nascimento));
								gotoxy(18,12);textcolor(lightred);WriteLn('O numero introduzido e incorrecto');
								textcolor(white); readkey; gotoxy(18,12);  ClrEOL; gotoxy(18,11); delline;
								gotoxy(18,11);write('Bilhete de identidade: ');
								Read(func.bi);
							End;
						Uppercase(func.bi);
						GotoXY(18,12);write('Genero[M/F]: ');
						sexo := ReadKey;
						sexo := Upcase(sexo);
						Repeat
							if( sexo = 'M' )Then
								Begin
									func.genero := 'MASCULINO';
								End
							Else
								Begin
									if( sexo = 'F' )Then
										Begin
											func.genero := 'FEMENINO';
										End
									Else
										Begin
											gotoxy(18,13);textcolor(lightred);WriteLn('O genero introduzido e invalido');
											textcolor(white); readkey; gotoxy(18,13);  ClrEOL; gotoxy(18,12); delline;
											GotoXY(18,12);write('Genero[M/F]: ');
											sexo := ReadKey;
											sexo := Upcase(sexo);
										End;
								End;
						Until((func.genero = 'MASCULINO') or (func.genero = 'FEMENINO'));
						GotoXY(18,12);write('Genero[M/F]: ',func.genero);
						GotoXY(18,13);write('Endereco: ');
						Readln(func.endereco);
					  Uppercase(func.endereco);
						Seek(fich, FilePos(fich)-1);
						write(fich, func);
						encontrei:= True;
						ClrScr;
						gotoxy(22,5);textcolor(lightgreen);WriteLn('Dados alterados com sucesso.');
						gotoxy(22,6);textcolor(white);WriteLn('Clique [enter] para voltar');
						Readln;
					End;
			End;
			close(fich);
			if not encontrei Then
				Begin
					ClrScr;
					gotoxy(22,5);textcolor(lightred);WriteLn('Dados alterados com sucesso.');
					gotoxy(22,6);textcolor(white);WriteLn('Clique [enter] para voltar');
					Readln;
				End;
	End;

Function Existe_Reciclagem_: Boolean;
	Begin
	   Assign(arc2,'Funcionario.bin');
		 {$I-}
		 	Reset(arc2);
			If IOResult = 0 Then
				Existe_Reciclagem_ := True
			Else
				Existe_Reciclagem_ := False;
		 {$I+}
	End;

Procedure Backup_;
	Begin
		if Existe_Reciclagem_ = true Then
			Begin
				Assign(arc2,'Backup.bin');
				Reset(arc2);
				Seek(arc2, FileSize(arc2));
				write(arc2, back);
				Close(arc2);
			End
		Else
			Begin
				Assign(arc2,'Backup.bin');
				ReWrite(arc2);
				write(arc2, back);
				Close(arc2);
			End;
	End;

Procedure Remover_Func(var fich: arquivo2);
	Var ident : Integer;
		nome_del: String;
	Begin
		ClrScr;
		textcolor(blue);
		textbackground(black);
	  gotoxy(30,2);Writeln('_REMOVER DADOS_');
	  textcolor(white);
		textbackground(blue);
		GotoXY(18,7);write('ID: ');
		Readln(autentica_id);
		Assign(fich,'Funcionario.dat');
		Reset(fich);
		for i:=0 to FileSize(fich)-1 do
			Begin
				Seek(fich, i);
				Read(fich, func);
				if(autentica_id = func.id)Then
					Begin
						back.estado := True;
						back.back_id := func.id;
						back.back_perfil := func.perfil;
						back.back_nome := func.nome;
						back.back_nascimento := func.nascimento;
						back.back_bi := func.bi;
						back.back_genero := func.genero;
						back.back_endereco := func.endereco;
						back.back_username := func.username;
						back.back_password := func.password;
						gotoxy(18,8);WriteLn('Perfil: ', func.perfil);
						gotoxy(18,9);WriteLn('Nome: ',func.nome);
						Close(fich);
						gotoxy(18,10);WriteLn('Tem certeza que deseja eliminar conta [S/N]?');
						tecla := ReadKey;
						tecla := Upcase(tecla);
						if tecla = 'S' Then
							Begin
								Backup_;
								Reset(fich);
			          Seek(fich, i + 1);
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
								WriteLn('Usuario removido com sucesso');
								writeln('Clique enter para voltar');
								Readln;
							End
						Else
							Begin
								if tecla = 'N' Then
									Begin
										ClrScr;
										WriteLn('Operacao cancelada');
										writeln('Clique [enter] para voltar');
										Readln;
									End
								Else RunError;
							End;
					End;
			End;
		if not remover Then
			Begin
				ClrScr;
				gotoxy(20,5);textcolor(lightred);WriteLn('ID nao encontrado em nossos registos');
				gotoxy(20,6);textcolor(white);WriteLn('Clique [enter] para voltar');
				Readln;
			End;
	End;

Procedure Recupera_Info_Func;
	Begin
		ClrScr;
		textcolor(blue);
		textbackground(black);
	  gotoxy(30,2);Writeln('_RECUPERAR DADOS_');
	  textcolor(white);
		textbackground(blue);
		gotoxy(18,7);write('ID: ');
		Readln(autentica_id);
		Assign(arc2,'Backup.bin');
		Reset(arc2);
		for i:=0 to FileSize(arc2)-1 Do
			Begin
				Seek(arc2, i);
				Read(arc2, back);
				if autentica_id = back.back_id Then
					Begin
						gotoxy(18,8);WriteLn('Perfil: ', back.back_perfil);
						gotoxy(18,9);WriteLn('Nome completo: ', back.back_nome);
						GotoXY(18,10);WriteLn('Tem certeza de que deseja recuperar estes dados?[S/N]');
						tecla := ReadKey;
						tecla := Upcase(tecla);
						if tecla = 'S' Then
							Begin
								back.estado := true;
								func.id := back.back_id;
								func.perfil := back.back_perfil;
								func.nome := back.back_nome;
								func.nascimento := back.back_nascimento;
								func.bi := back.back_bi;
								func.genero := back.back_genero;
								func.endereco := back.back_endereco;
								func.username := back.back_username;
								func.password := back.back_password;
								Assign(arq2, 'Funcionario.dat');
								Reset(arq2);
								Seek(arq2, FileSize(arq2));
								write(arq2, func);
								Close(arq2);
								if back.estado = True Then
									Begin
										Reset(arc2);
					          Seek(arc2, i + 1);
					          While Not Eof(arc2) Do
					            Begin
					              read(arc2, back);
					              Seek(arc2, Filepos(arc2) - 2);
					              Write(arc2, back);
					              Seek(arc2, Filepos(arc2) + 1);
					            End;
					          Seek(arc2, Filesize(arc2) - 1);
					          Truncate(arc2);
										Close(arc2);
									End;
								ClrScr;
								gotoxy(22,5);textcolor(lightgreen);WriteLn('Dados recuperados com sucesso.');
								gotoxy(22,6);textcolor(white);WriteLn('Clique [enter] para voltar');
								Readln;
						  End
						Else
							Begin
								ClrScr;
								gotoxy(22,5);WriteLn('Operacao cancela com sucesso.');
								gotoxy(22,6);WriteLn('Clique [enter] para voltar');
								Readln;
							End;
						encontrei := True;
					End;
			End;
		if not encontrei then
			Begin
				ClrScr;
				gotoxy(22,5);textcolor(lightred);WriteLn('ID introduzido nao encontrado');
				gotoxy(22,6);textcolor(white);WriteLn('Clique [enter] para voltar');
				Readln;
			End;
	End;

//-----------------------------------------------------------------
{-----Subprogramas de Produtos-----}
Function Existe_Produto(var fich: arquivo3): Boolean;
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

Procedure Registo_Produto(var fich: arquivo3);
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
		gotoxy(20,8);write('Nome do produto: ');
		Readln(prod.nome_prod);
		Uppercase(prod.nome_prod);
		prod.id_prod := concat(copy(prod.nome_prod,1,2),code);
		GotoXY(20,7);WriteLn('ID: ',prod.id_prod);
		GotoXY(20,9);write('Categoria do produto: ');
		Readln(prod.categoria);
		Uppercase(prod.categoria);
		gotoxy(20,10);write('Quantidade do produto: ');
		Readln(prod.quantidade);
		gotoxy(20,11);write('Preco do produto: ');
		Readln(prod.preco);
		if Existe_Produto(fich) = True Then
			Begin
				Assign(fich,'Produto.dat');
				Reset(fich);
				Seek(fich, FileSize(fich));
				write(fich, prod);
				close(fich);
			End
		Else
			Begin
				Assign(fich,'Produto.dat');
				ReWrite(fich);
				write(fich, prod);
				Close(fich);
			End;
	End;

	Procedure Listar_Produtos_Disponiveis(var fich: arquivo3);
	Var
		x, n: Integer;
	Begin
		ClrScr;
		x:=5;
		n:=1;
		Gotoxy(26,1);Writeln(' LISTA DOS PRODUTOS DISPONÍVEIS ');
	  Gotoxy(2,3);Writeln('#|');
		gotoxy(4,3);WriteLn('ID');
	  Gotoxy(9,3);Writeln('|Nome do Produto');
	  Gotoxy(30,3);WriteLn('|Categoria');
		gotoxy(45,3);Writeln('|Quant.');
	  Gotoxy(58,3);Writeln('|Preco Unitario');
		gotoxy(2,4);WriteLn('-------------------------------------------------------------------------------');
		Assign(fich,'Produto.dat');
	  Reset(fich);
		While Not Eof(fich)Do
			Begin
				Read(fich, prod);
				if (prod.quantidade > 0) Then
					Begin
						Gotoxy(2,x);Writeln(n,'|');
						gotoxy(4,x);WriteLn(prod.id_prod);
		        Gotoxy(9,x);Writeln('|',prod.nome_prod);
		        Gotoxy(30,x);WriteLn('|',prod.categoria);
						gotoxy(45,x);Writeln('|',prod.quantidade);
		        Gotoxy(58,x);Writeln('|',prod.preco:0:2,' MZN');
					End;
				x := x+1;
      	n := n+1;
			End;
		writeln;
		Close(fich);
	End;

Procedure Lista_Por_Categoria(var fich: arquivo3);
	var categ: String;
			x: Integer;
	Begin
		 ClrScr;
		 gotoxy(20,8);write('Categoria: ');
		 Readln(categ); Uppercase(categ);
		 Assign(fich, 'Produto.dat');
		 Reset(fich);
		 ClrScr;
		 x:= 5;
		 n:= 1;
		 Gotoxy(26,1);Writeln(' LISTA DOS PRODUTOS ');
		  Gotoxy(2,3);Writeln('#|');
			gotoxy(4,3);WriteLn('ID');
		  Gotoxy(9,3);Writeln('|Nome do Produto');
		  Gotoxy(30,3);WriteLn('|Categoria');
			gotoxy(45,3);Writeln('|Quant.');
		  Gotoxy(58,3);Writeln('|Preco Unitario');
			gotoxy(2,4);WriteLn('-------------------------------------------------------------------------------');
		 While Not Eof(fich)Do
		 	Begin
				Read(fich, prod);
				if(categ = prod.categoria)Then
					Begin
						Gotoxy(2,x);Writeln(n,'|');
						gotoxy(4,x);WriteLn(prod.id_prod);
		        Gotoxy(9,x);Writeln('|',prod.nome_prod);
		        Gotoxy(30,x);WriteLn('|',prod.categoria);
						gotoxy(45,x);Writeln('|',prod.quantidade);
		        Gotoxy(58,x);Writeln('|',prod.preco:0:2,' MZN');
					End;
				x := x+1;
      	n := n+1;
			End;
		 Close(fich);
	End;

Procedure Imprimr_Por_Valor(var fich: arquivo3);
	var money: Real;
			x: Integer;
	Begin
		 ClrScr;
		 gotoxy(20,8);write('Valor: ');
		 Readln(money);
		 Assign(fich, 'Produto.dat');
		 Reset(fich);
		 ClrScr;
		 x:= 5;
		 n:= 1;
		 Gotoxy(26,1);Writeln(' LISTA DOS PRODUTOS ');
		 Gotoxy(2,3);Writeln('#|');
		 gotoxy(4,3);WriteLn('ID');
		 Gotoxy(9,3);Writeln('|Nome do Produto');
		 Gotoxy(30,3);WriteLn('|Categoria');
		 gotoxy(45,3);Writeln('|Quant.');
		 Gotoxy(58,3);Writeln('|Preco Unitario');
		 gotoxy(2,4);WriteLn('-------------------------------------------------------------------------------');
		 While Not Eof(fich)Do
		 	Begin
				Read(fich, prod);
				if(prod.preco > money)Then
					Begin
						Gotoxy(2,x);Writeln(n,'|');
						gotoxy(4,x);WriteLn(prod.id_prod);
		        Gotoxy(9,x);Writeln('|',prod.nome_prod);
		        Gotoxy(30,x);WriteLn('|',prod.categoria);
						gotoxy(45,x);Writeln('|',prod.quantidade);
		        Gotoxy(58,x);Writeln('|',prod.preco:0:2,' MZN');
					End;
				x := x+1;
      	n := n+1;
			End;
		 Close(fich);
	End;

Procedure Listar_Produtos_Vendidos(var fich: arquivo3);
	Var
		sold: Boolean;
		x, n, y: Integer;
	Begin
		ClrScr;
		x:=5;
		n:=1;
		quant_total_vend := 0;
		capital_total_vend := 0;
		Gotoxy(26,1);Writeln(' HISTORICO DOS PRODUTOS VENDINDOS ');
	  Gotoxy(2,3);Writeln('#|');
		gotoxy(4,3);WriteLn('ID');
	  Gotoxy(9,3);Writeln('|Nome do Produto');
	  Gotoxy(30,3);WriteLn('|Categoria');
		gotoxy(45,3);Writeln('|Quant.');
	  Gotoxy(58,3);Writeln('|Preco total');
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
						gotoxy(45,x);Writeln('|',prod.quant_prod_vend);
		        Gotoxy(58,x);Writeln('|',prod.valor_pagar:0:2,' MZN');
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
		gotoxy(45,y+1);Writeln('|',quant_total_vend);
		gotoxy(58, y+1);Writeln('|',capital_total_vend:0:2,' MZN');
		if not sold Then
			Begin
				ClrScr;
				gotoxy(20,8);textcolor(lightred);WriteLn('Nenhuma venda foi efectuada.');
				textcolor(white);gotoxy(20,9);
			End;
	End;

Procedure Relatorio_Produtos_Vendidos(var fich: arquivo3);
	Var
		sold: Boolean;
		x, n, y: Integer;
	Begin
		ClrScr;
		x:=5;
		n:=1;
		quant_total_vend := 0;
		capital_total_vend := 0;
		Gotoxy(26,1);Writeln(' RELATORIO DOS PRODUTOS VENDINDOS ');
	  Gotoxy(2,3);Writeln('#|');
		gotoxy(4,3);WriteLn('ID');
	  Gotoxy(9,3);Writeln('|Nome do Produto');
	  Gotoxy(30,3);WriteLn('|Categoria');
		gotoxy(45,3);Writeln('|Quant.');
	  Gotoxy(58,3);Writeln('|Preco total');
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
						gotoxy(45,x);Writeln('|',prod.quant_prod_vend);
		        Gotoxy(58,x);Writeln('|',prod.valor_pagar:0:2,' MZN');
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
		gotoxy(45,y+1);Writeln('|',quant_total_vend);
		gotoxy(58, y+1);Writeln('|',capital_total_vend:0:2,' MZN');
		if not sold Then
			Begin
				ClrScr;
				gotoxy(20,8);textcolor(lightred);WriteLn('Nenhuma venda foi efectuada.');
				textcolor(white);gotoxy(20,9);
			End;
	End;

Procedure Listar_Stock_Produtos(var fich: arquivo3);
	Var
		x, n, y, quant_total_disp: Integer;
		capital_total: Real;
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
		gotoxy(45,3);Writeln('|Quant.');
	  Gotoxy(58,3);Writeln('|Preco Unitario');
		gotoxy(2,4);WriteLn('-------------------------------------------------------------------------------');
		Assign(fich,'Produto.dat');
	  Reset(fich);
		While Not Eof(fich)Do
			Begin
				Read(fich, prod);
				if (prod.quantidade < 50)Then
					Begin
						Textcolor(white);
            Gotoxy(2,x);Writeln(n,'|');
						gotoxy(4,x);WriteLn(prod.id_prod);
		        Gotoxy(9,x);Writeln('|',prod.nome_prod);
		        Gotoxy(30,x);WriteLn('|',prod.categoria);
						textcolor(lightred);
						gotoxy(45,x);Writeln('|',prod.quantidade);
						textcolor(white);
		        Gotoxy(58,x);Writeln('|',prod.preco:0:2,' MZN');
            Textcolor(white);
					End
				Else
					Begin
						if(prod.quantidade >= 50)and(prod.quantidade <= 100)Then
							Begin
								Textcolor(white);
		          	Gotoxy(2,x);Writeln(n,'|');
								gotoxy(4,x);WriteLn(prod.id_prod);
				        Gotoxy(9,x);Writeln('|',prod.nome_prod);
				        Gotoxy(30,x);WriteLn('|',prod.categoria);
								textcolor(yellow);
								gotoxy(45,x);Writeln('|',prod.quantidade);
								textcolor(white);
				        Gotoxy(58,x);Writeln('|',prod.preco:0:2,' MZN');
		            Textcolor(white);
							End
						Else
							Begin
								if(prod.quantidade > 100)Then
									Begin
										Textcolor(white);
				            Gotoxy(2,x);Writeln(n,'|');
										gotoxy(4,x);WriteLn(prod.id_prod);
						        Gotoxy(9,x);Writeln('|',prod.nome_prod);
						        Gotoxy(30,x);WriteLn('|',prod.categoria);
										textcolor(lightgreen);
										gotoxy(45,x);Writeln('|',prod.quantidade);
										textcolor(white);
						        Gotoxy(58,x);Writeln('|',prod.preco:0:2,' MZN');
				            Textcolor(white);
									End;
							End;
					End;
				y:=x+1;
				quant_total_disp := quant_total_disp + prod.quantidade;
				capital_total := capital_total + prod.preco;
				x := x+1;
      	n := n+1;
			End;
			Textcolor(white);
			gotoxy(2,y);WriteLn('...............................................................................');
			gotoxy(2,y+1);writeln('Total: ');
			gotoxy(45,y+1);Writeln('|',quant_total_disp);
			gotoxy(58, y+1);Writeln('|',capital_total:0:2,' MZN');
			Writeln;
			Textcolor(lightgreen); Write('Verde');
			Textcolor(WHITE); Writeln('- Quantidade estável');
			Textcolor(yellow); Write('Amarelo');
			Textcolor(WHITE); Writeln('- ALERTA  de quantidade razoável');
			Textcolor(lightred); Write('Vermelho');
			Textcolor(WHITE); Writeln('- ALERTA URGENTE a quantidade está abaixo de 50.');
			Close(fich);
	End;

Procedure Produto_AMedia;
	var x: Integer;
	Begin
		ClrScr;
		x:=5;
		n:=1;
		Gotoxy(26,1);Writeln(' LISTA DE PRODUTOS ACIMA DA MEDIA ');
	  Gotoxy(2,3);Writeln('#|');
		gotoxy(4,3);WriteLn('ID');
	  Gotoxy(9,3);Writeln('|Nome do Produto');
	  Gotoxy(28,3);WriteLn('|Categoria');
		gotoxy(42,3);Writeln('|Quant.');
	  Gotoxy(52,3);Writeln('|P. Unitario');
		GotoXY(66,3);WriteLn('|P.Total');
		gotoxy(2,4);WriteLn('-------------------------------------------------------------------------------');
		Assign(arq3,'Produto.dat');
		Reset(arq3);
		While Not Eof(arq3)Do
			Begin
				Read(arq3, prod);
				nr_prod := nr_prod + 1;
				media := media + prod.preco;
				encontrei := True;
			End;
		Close(arq3);
		if encontrei = True Then
			Begin
				media := media / nr_prod;
				Reset(arq3);
				While Not Eof(arq3) Do
					Begin
						Read(arq3, prod);
						if prod.preco > media Then
							Begin
								Gotoxy(2,x);Writeln(n,'|');
								gotoxy(4,x);WriteLn(prod.id_prod);
				        Gotoxy(9,x);Writeln('|',prod.nome_prod);
				        Gotoxy(28,x);WriteLn('|',prod.categoria);
								gotoxy(42,x);Writeln('|',prod.quantidade);
				        Gotoxy(52,x);Writeln('|',prod.preco:0:2,' MZN');
								GotoXY(66,x);WriteLn('|', (prod.preco*prod.quantidade):0:2,' MZN');
							End;
						x := x+1;
						n := n+1;
					End;
				Close(arq3);
			End;
	End;

	Procedure Alterar_Produto(var fich: arquivo3);
	Begin
		ClrScr;
		gotoxy(20,8);write('ID do produto: ');
		Readln(_id_prod);
		Uppercase(_id_prod);
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
						gotoxy(20,8);write('Nome do produto: ');
						Readln(prod.nome_prod);
						Uppercase(prod.nome_prod);
						prod.id_prod := concat(copy(prod.nome_prod,1,2),code);
						GotoXY(20,7);WriteLn('ID: ',prod.id_prod);
						GotoXY(20,9);write('Categoria do produto: ');
						Readln(prod.categoria);
						Uppercase(prod.categoria);
						gotoxy(20,10);write('Quantidade do produto: ');
						Readln(prod.quantidade);
						gotoxy(20,11);write('Preco do produto: ');
						Readln(prod.preco);
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

Procedure Remover_Produto(var fich: arquivo3);
	Begin
		ClrScr;
		gotoxy(20,8);write('ID do produto: ');
		Readln(_id_prod);
		Uppercase(_id_prod);
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

Procedure Menu_Produto;
	Label menu_prod;
	Begin
		menu_prod:
		ClrScr;
		Textcolor(blue);
	  Textbackground(black);
	  gotoxy(30,3);Writeln('_GESTAO DE PRODUTOS_');
	  Textcolor(white);
	  Textbackground(blue);
		gotoxy(31,9);writeln('[1] REGISTAR PRODUTO');
		gotoxy(31,10);writeln('[2] ALTERAR PRODUTO');
		GotoXY(31,11);writeln('[3] REMOVER PRODUTO');
		GotoXY(31,12);WriteLn('[4] LISTA DE PRODUTOS');
		gotoxy(31,13);WriteLn('[5] LISTA POR CATEGORIA');
		gotoxy(31,14);WriteLn('[6] LISTA POR VALOR');
		gotoxy(31,15);WriteLn('[7] VOLTAR');
		GotoXY(31,16);WriteLn('=====================');
		GotoXY(31,17);write('>>> ');
		Readln(opcao);
		Case(opcao)Of
			1: Begin
						ClrScr;
						Registo_Produto(arq3);
						ClrScr;
						gotoxy(22,8);textcolor(lightgreen);writeln('Produto(s) registado(s) com sucesso.');
						gotoxy(22,9);textcolor(white);writeln('Clique enter para voltar ao menu incial');
						readln; goto menu_prod;
				 End;
			2: Begin
						ClrScr;
						Alterar_Produto(arq3);
						ClrScr;
						gotoxy(22,8);textcolor(lightgreen);writeln('Dados do produto alterados com sucesso.');
						gotoxy(22,9);textcolor(white);writeln('Clique [enter] para voltar ao menu incial');
						readln;goto menu_prod;
				 End;
			3: Begin
						ClrScr;
						Remover_Produto(arq3);
						goto menu_prod;
				 End;
			4: Begin
						ClrScr;
						Assign(arq3,'Produto.dat');
						Listar_Produtos_Disponiveis(arq3);
						WriteLn('Clique [enter] para voltar');
						Readln; Goto menu_prod;
				 End;
			5: Begin
						ClrScr;
						Lista_Por_Categoria(arq3);
						WriteLn('Clique [enter] para voltar');
						Readln; Goto menu_prod;
				 End;
			6: Begin
						ClrScr;
						Imprimr_Por_Valor(arq3);
						WriteLn('Clique [enter] para voltar');
						Readln; Goto menu_prod;
				 End;
			7: Read
			Else goto menu_prod;
		End;
	End;

Procedure Menu_Stock;
	Label stock;
	Begin
		stock:
		ClrScr;
		Textcolor(blue);
	  Textbackground(black);
	  gotoxy(27,3);Writeln('_GESTAO DE STOCK_');
	  Textcolor(white);
	  Textbackground(blue);
		gotoxy(25,8);writeln('[1] PRODUTOS VENDIDOS');
		gotoxy(25,9);writeln('[2] STOCK');
		gotoxy(25,10);writeln('[3] LISTA DE PRODUTOS ACIMA DA MEDIA');
		gotoxy(25,11);WriteLn('[4] VOLTAR');
		gotoxy(25,12);writeln('=====================');
		gotoxy(25,13);write('>>> ');
		Readln(opcao);
		Case(opcao)Of
			1: Begin
					 ClrScr;
					 Listar_Produtos_Vendidos(arq3);
					 WriteLn('Clique enter para voltar ao menu');
					 Readln;   goto stock;
			 	 End;
			2: Begin
					 ClrScr;
					 Listar_Stock_Produtos(arq3);
					 WriteLn('Clique enter para voltar ao menu');
					 Readln; goto stock;
				 End;
			3: Begin
						ClrScr;
						Produto_AMedia;
						writeln;WriteLn('Clique [enter] para voltar');
						Readln; goto stock;
				 End;
			4: Read
			Else goto stock;
		End;
	End;
 //---Relatorio
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
//-----------------------------------------------------------------
{---------------EXPLORADOR DO GESTOR---------------}
Procedure Opcoes(Var fich: arquivo1);
	Label opcoes_;
	Begin
		opcoes_:
		ClrScr;
		TEXTCOLOR(BLUE);
		TEXTBACKGROUND(black);
		gotoxy(30,2);writeln('_MENU GESTOR_');
		TEXTCOLOR(WHITE);
		TEXTBACKGROUND(BLUE);
		gotoxy(25,10);writeln('  [1] CONSULTAR DADOS   ');
		gotoxy(25,11);WriteLn('  [2] REMOVER  DADOS    ');
		gotoxy(25,12);writeln('  [3] ALTERAR DADOS     ');
		gotoxy(25,13);writeln('  [4] VOLTAR            ');
		gotoxy(25,14);writeln('========================');
		gotoxy(25,15);write('>>> ');
		readln(opcao);
		Case(opcao)Of
			1: Begin
						ClrScr;
						Visualizar_Dados(arq1);
						goto opcoes_;
				 End;
			2: Begin
						ClrScr;
						Remover_(arq1);
				 End;
			3: Begin
						ClrScr;
						Alterar_Dado(arq1);
						goto opcoes_;
				 End;
			4: Read
			Else goto opcoes_;
		End;
	End;

Procedure Menu_Princ(var fich: arquivo1);
	Label menu_princ, menu_func;
	Var rel: Text;
			total_prod, total: Real;
			count_prod: Integer;
			cash_prod, quant_prod, cash_total, quant_total, d, m, a, data, time, hour, minute, second: String;
	Begin
		menu_princ:
		ClrScr;
		textcolor(blue);
		textbackground(black);
	  gotoxy(32,2);Writeln('_MENU PRINCIPAL_');
	  textcolor(white);
		textbackground(blue);
		getdate(ano, mes, dia, semana);
		gettime(hora, minuto, segundo, msegundo);
		gotoxy(3,5);writeln('ID: ',gest.id);
		gotoxy(3,6);writeln('PERFIL: ',gest.perfil);
		gotoxy(38,5);Writeln(hora,':',minuto);
		gotoxy(60,5);Writeln(SEMANAS[semana],',',dia,'/',MESES[mes],'/',ano);
		gotoxy(25,12);WriteLn('[1] GESTAO DE FUNCIONARIOS');
		gotoxy(25,13);WriteLn('[2] GESTAO DE PRODUTOS');
		gotoxy(25,14);WriteLn('[3] GESTAO DE STOCK');
		gotoxy(25,15);WriteLn('[4] RELATORIO');
		GotoXY(25,16);WriteLn('[5] DADOS DO GESTOR');
		gotoxy(25,17);WriteLn('[6] VOLTAR');
		gotoxy(25,18);writeln('============================');
		gotoxy(25,19);write('>>> ');
		Readln(opcao);
		Case(opcao)Of
			1: Begin
						menu_func:
						Clrscr;
						Textcolor(blue);
						Textbackground(black);
					  Gotoxy(32,2);
					  Writeln ('_MENU FUNCIONARIO_');
						Textcolor(white);
						Textbackground(blue);
						Gotoxy(25,10);Writeln('[1] REGISTAR FUNCIONARIO');
						Gotoxy(25,11);Writeln('[2] EDITAR DADOS DO FUNCIONARIO');
						Gotoxy(25,12);Writeln('[3] REMOVER DADOS DO FUNCIONARIO');
						Gotoxy(25,13);Writeln('[4] PESQUISAR FUNCIONARIO');
						Gotoxy(25,14);Writeln('[5] VER DADOS DE TODOS FUNCIONARIOS');
						Gotoxy(25,15);Writeln('[6] DADOS APAGADOS');
						GotoXY(25,16);WriteLn('[7] RESTAURAR DADOS APAGADOS');
						GotoXY(25,17);WriteLn('[8] VOLTAR');
						gotoxy(25,18);WriteLn('---------------------------------------');
						gotoxy(25,19);write('>>> ');
						readln(opcao);
						Case(opcao)Of
							1: Begin
										ClrScr;
										Registo_Func(arq2);
										goto menu_func;
							 	 End;
							2: Begin
										ClrScr;
										Alterar_Dados_Pessoais(arq2);
										goto menu_func;
							 	 End;
							3: Begin
										ClrScr;
										Remover_Func(arq2);
										goto menu_func;
							 	 End;
							4: Begin
										ClrScr;
										textcolor(blue);
										textbackground(black);
									  gotoxy(32,2);Writeln('_PESQUISA DE FUNCIONARIO_');
									  textcolor(white);
										textbackground(blue);
										gotoxy(18,7);write('ID: ');
										Readln(autentica_id);
										Pesquisar_Dados(arq2);
										goto menu_func;
							 	 End;
							5: Begin
										ClrScr;
										Listar_Func(arq2);
										goto menu_func;
							 	 End;
							6: Begin
										ClrScr;
									 gotoxy(30,1);WriteLn('LISTA DE FUNCIONARIOS DEMETIDOS');
									 Assign(arc2, 'Backup.bin');
									 Reset(arc2);
									 While Not Eof(arc2)Do
									 	Begin
											Read(arc2, back);
											writeln('ID: ', back.back_id);
											writeln('PERFIL: ', back.back_perfil);
											writeln('NOME: ', back.back_nome);
											writeln('DATA DE NASCIMENTO: ', back.back_nascimento);
											writeln('BILHETE DE IDENTIDADE: ', back.back_bi);
											writeln('GENERO: ', back.back_genero);
											WriteLn('ENDERECO: ', back.back_endereco);
											writeln('--------------------------------------------');
										End;
										Close(arc2);
										WriteLn('Clique [enter] para voltar');
										Readln; goto menu_func;
								 End;
							7: Begin
										ClrScr;
										Recupera_Info_Func;
										goto menu_func;
								 End;
							8: goto menu_princ
							Else goto menu_func;
						End;
				 End;
			2: Begin
						ClrScr;
						Menu_Produto;
						goto menu_princ;
				 End;
			3: Begin
						ClrScr;
						Menu_Stock;
						goto menu_princ;
				 End;
			4: Begin
						ClrScr;
						gotoxy(20,8);WriteLn('[1] VISUALIZAR RELATORIO');
						gotoxy(20,9);WriteLn('[2] IMPRIMIR RELATORIO');
						gotoxy(20,10);writeln('-----------------------');
						gotoxy(20,11);write('>>> ');
						Readln(opcao);
						Case(opcao)Of
							1: Begin
										Relatorio_Produtos_Vendidos(arq3);
										WriteLn('Clique [enter] para voltar');
										Readln;goto menu_princ;
								 End;
							2: Begin
										Assign(rel, 'Relatorio.txt');
										Existe_Relatorio(rel);
										if Existe_Relatorio(rel) = True Then
											Begin
												Assign(rel, 'Relatorio.txt');
												Append(rel);
											End
										Else
											Begin
												Assign(rel, 'Relatorio.txt');
												Rewrite(rel);
											End;
										Assign(arq3,'Produto.dat');
										Reset(arq3);
										Writeln(rel,'RELATÓRIO ');
										getdate(ano, mes, dia, semana);
										gettime(hora, minuto, segundo, msegundo);
										Str(dia, d); Str(hora, hour);
										Str(mes, m); Str(minuto, minute);
										Str(ano, a); Str(segundo, second);
										data := Concat(d,'/',m,'/',a);
										time := Concat(hour,':',minute,':', second);
										Writeln(rel,'Data: ',data);
										WriteLn(rel,'Hora: ', time);
										WriteLn(rel,'.........................................................');
										While Not Eof(arq3)Do
											Begin
												Read(arq3, prod);
												if prod.quant_prod_vend > 0 Then
													Begin
														Writeln(rel,'ID: ',prod.id_prod_vend);
											      Writeln(rel,'Nome do produto: ',prod.nome_prod_vend);
											      Writeln(rel,'Categoria: ',prod.categoria_vend);
														total_prod := total_prod + prod.quant_prod_vend;
														Str(prod.quant_prod_vend, quant_prod);
											      Writeln(rel,'Quantidade: ',quant_prod);
														total := total + prod.preco_vend;
											      Str(prod.valor_pagar:0:2, cash_prod);
											      Writeln(rel,'Preco: ',cash_prod,' MZN');
														WriteLn(rel,'.........................................................');
														Inc(count_prod);
													End;
											End;
									  Close(arq3);
										Close(rel);
										shellexecute(0,'open','Relatorio.txt',nil,nil,1);
										goto menu_princ;
								 End;
						End;

				 End;
			5: Begin
						Opcoes(fich);
						goto menu_princ;
				 End;
			6: Read
			Else goto menu_princ;
		End;
	End;
{---------------EXPLORADOR DO OPERADOR---------------}
Procedure Opcoes_func(Var fich: arquivo2);
	Label _opcoes_;
	Begin
		_opcoes_:
		ClrScr;
		TEXTCOLOR(BLUE);
		TEXTBACKGROUND(black);
		gotoxy(30,2);writeln('_MENU FUNCIONARIO_');
		TEXTCOLOR(WHITE);
		TEXTBACKGROUND(BLUE);
		gotoxy(25,10);writeln('  [1] CONSULTAR DADOS           ');
		gotoxy(25,11);WriteLn('  [2] ALTERAR DADOS  DE ACESSO  ');
		gotoxy(25,12);WriteLn('  [3] VOLTAR                    ');
		gotoxy(25,13);writeln('================================');
		gotoxy(25,14);write('>>> ');
		readln(opcao);
		Case(opcao)Of
			1: Begin
						ClrScr;
						Pesquisar_Dados(arq2);
						goto _opcoes_;
				 End;
			2: Begin
						ClrScr;
						Assign(fich,'Funcionario.dat');
						Reset(fich);
						textcolor(blue);
						textbackground(black);
					  gotoxy(30,2);Writeln('_ALTERAR DADOS DE ACESSO AO SISTEMA_');
					  textcolor(white);
						textbackground(blue);
						gotoxy(20,8);write('Nome do usuario: ');
						Readln(func.username);
						Uppercase(func.username);
						GotoXY(20,8);write('Palavra-passe: ');
						Readln(func.password);
						while(Length(func.password) < 8) or (Length(func.password) >= 15)do
							Begin
								Delete(func.genero,1,Length(func.genero));
								gotoxy(20,9);textcolor(lightred);WriteLn('Introduza 8 caracteres no minimo e 15 no maximo');
								textcolor(white); readkey; gotoxy(20,9);  ClrEOL; gotoxy(18,8);delline;
								gotoxy(20,8);write('Palavra-passe: ');
								read(func.password);
							End;
						Uppercase(func.password);
						Seek(fich, FilePos(fich)-1);
						write(fich, func);
						Close(fich);
						ClrScr;
						gotoxy(22,8);textcolor(lightgreen);writeln('Os seus dados foram alterados com sucesso.');
						gotoxy(22,9);textcolor(white);writeln('Clique [enter] para voltar.');
						readln;
						goto _opcoes_;
				 End;
			3: Read
			Else goto _opcoes_;
		End;
	End;

Procedure Menu_Princ_Func(var fich: arquivo2);
	Label main_menu, menu_prod,atendimento, stock_, vender;
	var k, x: integer;
			tako, preco_uni_: Real;
	Begin
		main_menu:
		ClrScr;
		textcolor(blue);
		textbackground(black);
	  gotoxy(32,2);Writeln('_MENU PRINCIPAL_');
	  textcolor(white);
		textbackground(blue);
		getdate(ano, mes, dia, semana);
		gettime(hora, minuto, segundo, msegundo);
		gotoxy(3,5);writeln('ID: ',func.id);
		gotoxy(3,6);writeln('PERFIL: ',func.perfil);
		gotoxy(38,5);Writeln(hora,':',minuto);
		gotoxy(60,5);Writeln(SEMANAS[semana],',',dia,'/',MESES[mes],'/',ano);
		gotoxy(25,12);WriteLn('[1] GESTAO DE PRODUTOS');
		gotoxy(25,13);WriteLn('[2] CAIXA');
		gotoxy(25,14);WriteLn('[3] GESTAO DE STOCK');
		GotoXY(25,15);WriteLn('[4] DADOS DO OPERADOR');
		gotoxy(25,16);WriteLn('[5] VOLTAR');
		gotoxy(25,17);writeln('============================');
		gotoxy(25,18);write('>>> ');
		Readln(opcao);
		Case(opcao)Of
			1: Begin
						ClrScr;
						Menu_Produto;
						goto main_menu;
				 End;
			2: Begin
						atendimento:
						ClrScr;
						Textcolor(blue);
					  Textbackground(black);
					  gotoxy(27,3);Writeln('_CAIXA_');
					  Textcolor(white);
					  Textbackground(blue);
						GotoXY(25,8);WriteLn('[1] VENDER PRODUTO');
						GotoXY(25,9);WriteLn('[2] VOLTAR');
						gotoxy(25,10);writeln('===============');
						gotoxy(25,11);write('>>> ');
						Readln(opcao);
						Case(opcao)Of
							1: Begin
										vender:
										ClrScr;
										gotoxy(25,7);write('ID: ');
										Readln(_id_prod);
										Uppercase(_id_prod);
										Assign(arq3, 'Produto.dat');
										reset(arq3);
						     		for i:= 0 to filesize(arq3)-1 do
											Begin
												Seek(arq3, i);
												read(arq3, prod);
												if(_id_prod = prod.id_prod) then
													begin
														gotoxy(25,8);write('Nome do produto:  ', prod.nome_prod);
														prod.nome_prod_vend := prod.nome_prod;
														prod.categoria_vend := prod.categoria;
														prod.id_prod_vend := prod.id_prod;
														gotoxy(25,9);writeln('Quantidade existente: ', prod.quantidade);
														Gotoxy(25,10);write('Quantidade desejada: ');
														readln(_quant_prod);
													 	if (_quant_prod > 0) and (_quant_prod <= prod.quantidade) then
															begin
																if(prod.nome_prod_vend = prod.nome_prod)and(prod.id_prod_vend = prod.id_prod)Then
																	Begin
																		prod.quant_prod_vend := prod.quant_prod_vend + _quant_prod;
																		prod.quantidade := prod.quantidade - _quant_prod;
																		prod.valor_pagar := prod.valor_pagar + (_quant_prod*prod.preco);
																		tako := (_quant_prod*prod.preco);
																	End
																Else
																	Begin
																		prod.quant_prod_vend := _quant_prod;
																		prod.quantidade := prod.quantidade - _quant_prod;
																		prod.valor_pagar := _quant_prod*prod.preco;
																		tako := prod.valor_pagar;
																	End;
																gotoxy(25,11);writeln('O valor a pagar: ', tako:0:2,' MZN');
																delay(1000);
																seek(arq3, FilePos(arq3)-1);
																write(arq3, prod);
																encontrei:=true;
																gotoxy(25,13);WriteLn('Deseja efectuar mais uma venda [S/N]');
																tecla := ReadKey;
																tecla := Upcase(tecla);
																if tecla = 'S' Then goto vender
																Else
																	Begin
																		ClrScr;
																		gotoxy(22,8);WriteLn('Venda(s) efectuada(s) com sucesso.');
																		gotoxy(22,9);WriteLn('Clique [enter]');
																		Readln; goto atendimento;
																	End;
															end
														else
															begin
																ClrScr;
																Gotoxy(25,12);textcolor(lightred);
																writeln('A quantidade solicitada e superior em relacao a quantidade existente');
																textcolor(white); gotoxy(25,13);WriteLn('Clique [enter] para tentar novamente');
																Readln; goto vender;
															end;
													End;
											end;
									 close(arq3);
									 if not encontrei then
									 	Begin
											ClrScr;
											Gotoxy(20,12);textcolor(lightred);
											writeln('O produto solicitado nao existe em nossos registos');
											textcolor(white);  gotoxy(20,13);WriteLn('Clique [enter] para voltar ao menu');
											Readln; goto atendimento;
										end;
								 End;
							2: goto main_menu
							Else goto atendimento;
						End;
				 End;
			3: Begin
						stock_:
						Menu_Stock;
						goto main_menu;
				 End;
			4: Begin
						Opcoes_func(fich);
						goto main_menu;
				 End;
			5: Read
			Else goto main_menu;
		End;
	End;
{---------------PROGRAMA PRINCIPAL---------------}
Begin
	inicio:
	textbackground(blue);
	ClrScr;
	Textcolor(blue);
  Textbackground(black);
  gotoxy(27,3);Writeln('_BEM VINDO AO MENU INICIAL_');
  Textcolor(white);
  Textbackground(blue);
	textcolor(yellow);gotoxy(2,30);
	lowvideo;writeln('Desenvolvedor: Carlos Macaneta');
	normvideo;window(1,1, 255, 255);textbackground(blue);
	If Existe_Gestor(arq1) = False Then
		Begin
			nova_conta:
			gotoxy(25,11);writeln('  [1] Criar conta                 ');
			gotoxy(25,12);WriteLn('  [2] Sair                        ');
			gotoxy(25,13);writeln('==================================');
			gotoxy(25,14);write('>>> ');
			readln(opcao);
			Case(opcao)Of
				1: Begin
							ClrScr;
							Registo(arq1);
							goto inicio;
					 End;
				2: Begin
							deseja_continuar:
							textcolor(yellow);
							GotoXY(25,14); delline;
							GotoXY(24,14);writeln('Tem certeza de que deseja sair[S/N]?');
							tecla:= ReadKey;
							tecla:= Upcase(tecla);
							if(tecla = 'S')then Exit
							Else
								Begin
									If(tecla = 'N')Then goto inicio
									Else goto deseja_continuar;
								end;
					 End
				Else Goto inicio;
			End;
		End
	Else
		Begin
			Assign(arq1,'Gestor.dat');
			Reset(arq1);
			While Not Eof(arq1)Do
				Begin
					Read(arq1, gest);
					perfil_gest := gest.perfil;
				End;
			If (FileSize(arq1) <= 0) or (perfil_gest = '')then
				goto nova_conta;
			Close(arq1);
			gotoxy(25,11);writeln('  [1] Iniciar sessao              ');
			gotoxy(25,12);WriteLn('  [2] Sair                        ');
			gotoxy(25,13);writeln('==================================');
			gotoxy(25,14);write('>>> ');
			readln(opcao);
			Case(opcao)Of
				1: Begin
							login:
							senha := vazio;
							ClrScr;
							Textcolor(blue);
		          Textbackground(black);
		          gotoxy(34,3);Writeln('_INICIAR SESSAO_');
		          Textcolor(white);
		          Textbackground(blue);
							gotoxy(25,8);write('NOME DE USUARIO: ');
							TEXTCOLOR(LIGHTGREEN);Readln(user);
							Uppercase(user); TEXTCOLOR(WHITE);
							gotoxy(25,10);write('PALAVRA-PASSE: ');
							Repeat
								caracter := ReadKey;
								if(caracter = #8)Then
									Begin
									  if(count > 0)Then
											Begin
												senha := senha + caracter;
												write(#8);write(#32);write(#8);
												Delete(senha, count, 1);
												Dec(count);
											End;
										if count <= 0 Then
											senha := vazio;
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
							Assign(arq1,'Gestor.dat');
							Reset(arq1);
							for i:=0 to FileSize(arq1)-1 Do
								Begin
									Seek(arq1, i);
									Read(arq1, gest);
									if(user = gest.username)and(senha = gest.password)Then
										Begin
											ClrScr;
											autentica_id := gest.id;
											Menu_Princ(arq1);
											goto inicio;
											autentica:= True;
										End;
								End;
							Close(arq1);
							if not autentica Then
								Begin
									If Existe_Funcionario(arq2) = True Then
										Begin
											Assign(arq2,'Funcionario.dat');
											Reset(arq2);
											for i:=0 to FileSize(arq2)-1 Do
												Begin
													Seek(arq2, i);
													Read(arq2, func);
													if(user = func.username)and(senha = func.password)Then
														Begin
															ClrScr;
															autentica_id := func.id;
															Menu_Princ_Func(arq2);
															goto inicio;
															encontrei:=True;
														End;
												End;
											Close(arq2);
											If Not encontrei Then
												Begin
													tente_novamente:
													gotoxy(15,12);textcolor(lightred);writeln('Nome de usuario ou palavra-passe incorrecto(s).');
													gotoxy(25,13);textcolor(white);writeln('Tentar novamente?[S/N]');
													tecla := readkey;
													tecla := upcase(tecla);
													if(tecla = 'S') then goto login
													else
														Begin
															If(tecla = 'N')then goto inicio
															else goto tente_novamente;
														end;
												End;
										end
									Else goto tente_novamente;
								End;
					 End;
				2: Goto deseja_continuar
				Else goto inicio;
			End;
		End;
End.