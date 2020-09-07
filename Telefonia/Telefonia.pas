Program Telefonia;
uses crt, dos;

Label
	inicio, login, menu_admin,menu, vazio;

Const
	RECARGA=1000000000;

Type
	Clientes = Record
		nome, perfil: String;
		nascimento: String[10];
		bi: String[13];
		celular: Array [1..2] of String[9];
		net, saldo_disponivel, 
		transferir_saldo, sms, bonus,
		valor_credito, saldo,
		id_cliente, pin,recarregar: Integer;
		estado_credito:Boolean;
	end;
	arquivo = file of Clientes;
	Administrador = Record
		nome, perfil: String;
		nascimento: String[10];
		bi: string[13];
		username, password: String[15];
		id_admin: Integer;
	end;
	arquivo2 = file of Administrador;

Var
	arq: arquivo;
	reg: Clientes;
	arq2: arquivo2;
	admin: Administrador;
	tecla: char;
	credito, comprar_credito, transferir, consulta,
	pin, autentica_credito,
	indice, ibusca, i, numero_clientes,autentica_pin, up,
	size, id_admin, id_client, opcao: Integer;
	user, pass: string[15];
	autentica_numero, nome_admin, pin2: String;
	cel: Array [1..2] of String[9];
	encontrei: Boolean;

Function Existe_Administrador(var fich: arquivo2):Boolean;
	Begin
		{$I-}
			Reset(fich);
			if IOResult = 0 Then
				Existe_Administrador := True
			Else
				Existe_Administrador := False;
		{$I+}
	end;

Procedure Registrar_Admninistrador(var fich: arquivo2);
	Begin
		Assign(fich, 'Administrador.dat');
		ReWrite(fich);
		admin.id_admin:=1;
		admin.perfil:='ADMINISTRADOR';
		ClrScr;
		textcolor(blue);
		textbackground(black);
	  gotoxy(28,2);Writeln('_REGISTRO DO ADMINISTRADOR_');
	  textcolor(white);
		textbackground(blue);
		gotoxy(20,8);write('Nome completo: ');
		textcolor(yellow);readln(admin.nome);
		for up:= 1 to Length(admin.nome)do
			admin.nome[up]:= Upcase(admin.nome[up]);
		gotoxy(20,9); textcolor(white);
		write('Data de nascimento(dd/mm/aaaa): ');
		textcolor(yellow);readln(admin.nascimento);
		while((copy(admin.nascimento,3,1) <> '/')and(copy(admin.nascimento,6,1) <> '/')or(Length(admin.nascimento) < 8)) do
			Begin
				Delete(admin.nascimento,1,Length(admin.nascimento));
				textcolor(white);
				GotoXY(20,9); delline;
				gotoxy(20,9);write('Data de nascimento(dd/mm/aaaa): ');
				textcolor(yellow);readln(admin.nascimento);
				textcolor(white);
			end;
		gotoxy(20,10);write('Bilhete de identidade: ');
		textcolor(yellow);readln(admin.bi);
		for up:=1 to Length(admin.bi) Do
			admin.bi[up]:= Upcase(admin.bi[up]);
		gotoxy(20,11);textcolor(white);
		WriteLn('===========================================');
		gotoxy(20,12);write('Username: ');
		textcolor(yellow);readln(admin.username);
		gotoxy(20,13);textcolor(white);
		for up:= 1 to Length(admin.username)Do
			admin.username[up]:= Upcase(admin.username[up]);
		write('Password: ');
		textcolor(yellow); readln(admin.password);
		for up:= 1 to Length(admin.password)Do
			admin.password[up]:= upcase(admin.password[up]);
		while(Length(admin.password) < 8)do
			Begin
				gotoxy(20,13);delline;
				Delete(admin.password,1,Length(admin.password));
				gotoxy(20,13);textcolor(white);
				write('Password: ');
				textcolor(yellow); readln(admin.password);
				for up:= 1 to Length(admin.password)Do
					admin.password[up]:= upcase(admin.password[up]);
			End;
		write(fich, admin);
		Close(fich);
	end;

	Procedure Adicionar_Registro_Admninistrador(var fich: arquivo2);
	Begin
		Assign(fich, 'Administrador.dat');
		Reset(fich);
		Seek(fich, FileSize(fich));
		size:= FileSize(fich);
		Seek(fich, FileSize(fich));
		admin.id_admin:=size+1;
		admin.perfil:='ADMINISTRADOR';
		ClrScr;
		textcolor(blue);
		textbackground(black);
	  gotoxy(28,2);Writeln('_REGISTRO DO ADMINISTRADOR_');
	  textcolor(white);
		textbackground(blue);
		gotoxy(20,8);write('Nome completo: ');
		textcolor(yellow);readln(admin.nome);
		for up:= 1 to Length(admin.nome)Do
			admin.nome[up]:= upcase(admin.nome[up]);
		gotoxy(20,9); textcolor(white);
		write('Data de nascimento(dd/mm/aaaa): ');
		textcolor(yellow);readln(admin.nascimento);
		while((copy(admin.nascimento,3,1) <> '/')and(copy(admin.nascimento,6,1) <> '/')or(Length(admin.nascimento) < 10)) do
			Begin
				Delete(admin.nascimento,1,Length(admin.nascimento));
				textcolor(white);
				GotoXY(20,9); delline;
				gotoxy(20,9);write('Data de nascimento(dd/mm/aaaa): ');
				textcolor(yellow);readln(admin.nascimento);
				textcolor(white);
			end;
		gotoxy(20,10);write('Bilhete de identidade: ');
		textcolor(yellow);readln(admin.bi);
		for up:=1 to Length(admin.bi) Do
			admin.bi[up]:= Upcase(admin.bi[up]);
		gotoxy(20,11);textcolor(white);
		WriteLn('===========================================');
		gotoxy(20,12);write('Username: ');
		textcolor(yellow);readln(admin.username);
		for up:= 1 to Length(admin.username)Do
			admin.username[up]:= Upcase(admin.username[up]);
		gotoxy(20,13);textcolor(white);
		write('Password: ');
		textcolor(yellow); readln(admin.password);
		for up:= 1 to Length(admin.password)Do
			admin.password[up]:= Upcase(admin.password[up]);
		while(Length(admin.password) < 8)do
			Begin
				gotoxy(20,13);delline;
				Delete(admin.password,1,Length(admin.password));
				gotoxy(20,13);textcolor(white);
				write('Password: ');
				textcolor(yellow); readln(admin.password);
			End;
		write(fich, admin);
		Close(fich);
	end;

Function Autentica_Contacto(var fich: arquivo; numero: String):Boolean;
	Var
		indice: Integer;
	Begin
		indice:=1;
		Assign(fich, 'Clientes.dat');
		Reset(fich);
		for i:= 0 to FileSize(fich)-1 Do
			Begin
				Seek(fich, i);
				read(fich, reg);
				if(reg.celular[indice] = numero)or(reg.celular[indice+1] = numero)then
					Begin
						Autentica_Contacto := True;
					end
				Else
					Begin
						Autentica_Contacto := False;
					End;
			end;
		close(fich);
	end;

Function Existe_Clientes(var fich: arquivo):Boolean;
	Begin
		{$I-}
			Reset(fich);
			if IOResult = 0 Then
				Existe_Clientes := True
			Else
				Existe_Clientes := False;
		{$I+}
	End;

Procedure Registrar_Clientes(var fich: arquivo);
	Begin
		Assign(arq, 'Clientes.dat');
		ReWrite(arq);
		reg.id_cliente:=1;
		reg.perfil:= 'CLIENTE';
		gotoxy(8,8);write('Número de clientes que pretende registrar: ');
		readln(numero_clientes);
		for i:= 1 to numero_clientes do
			Begin
				ClrScr;
				textcolor(black+blue);
				textbackground(black);
			  gotoxy(30,2);Writeln('_REGISTRO DO CLIENTE_');
			  textcolor(white);
				textbackground(blue);
				gotoxy(15,7);writeln(reg.perfil,' n°: ',reg.id_cliente);
				gotoxy(15,8);write('Nome do cliente: ');
				textcolor(lightgreen);readln(reg.nome);
				for up:= 1 to Length(reg.nome)Do
					reg.nome[up]:= Upcase(reg.nome[up]);
				gotoxy(15,9);textcolor(white);write('Data de nascimento(dd/mm/aaaa): ');
				textcolor(lightgreen);readln(reg.nascimento);
				gotoxy(15,10);textcolor(white);write('Bilhete de identidade: ');
				textcolor(lightgreen);readln(reg.bi);
				for up:= 1 to Length(reg.bi)do
					reg.bi[up]:= Upcase(reg.bi[up]);
				textcolor(white);gotoxy(15,11);
				write('Celular 1: ');
				textcolor(lightgreen);readln(reg.celular[1]);
				textcolor(white);gotoxy(15,12);
				write('Celular 2: ');
				textcolor(lightgreen);readln(reg.celular[2]);
				gotoxy(15,13);textcolor(white);
				write('PIN: ');
				textcolor(lightgreen);readln(reg.pin);

				reg.saldo_disponivel:=0;
				reg.net:=0;
				reg.sms:=0;
				reg.bonus:=0;
				write(arq, reg);
				reg.id_cliente:= reg.id_cliente+1;
			end;
			close(arq);
	end;

Procedure Adicionar_Clientes(var fich: arquivo);
	Begin
		Assign(arq, 'Clientes.dat');
		Reset(arq);
		Seek(arq, FileSize(arq));
		ClrScr;
		reg.id_cliente:=reg.id_cliente+1;
		reg.perfil:= 'CLIENTE';
		gotoxy(8,8);write('Número de clientes que pretende registrar: ');
		readln(numero_clientes);
		for i:= 1 to numero_clientes do
			Begin
				ClrScr;
				textcolor(blue);
				textbackground(black);
			  gotoxy(30,2);Writeln('_REGISTRO DO CLIENTE_');
			  textcolor(white);
				textbackground(blue);
				gotoxy(15,7);writeln(reg.perfil,' n°: ',reg.id_cliente);
				gotoxy(15,8);write('Nome do cliente: ');
				textcolor(lightgreen);readln(reg.nome);
				for up:= 1 to Length(reg.nome)Do
					reg.nome[up]:= Upcase(reg.nome[up]);
				gotoxy(15,9);textcolor(white);write('Data de nascimento(dd/mm/aaaa): ');
				textcolor(lightgreen);readln(reg.nascimento);
				gotoxy(15,10);textcolor(white);write('Bilhete de identidade: ');
				textcolor(lightgreen);readln(reg.bi);
				for up:= 1 to Length(reg.bi)do
					reg.bi[up]:= Upcase(reg.bi[up]);
				textcolor(white);gotoxy(15,11);
				write('Celular 1: ');
				textcolor(lightgreen);readln(reg.celular[1]);
				textcolor(white);gotoxy(15,12);
				write('Celular 2: ');
				textcolor(lightgreen);readln(reg.celular[2]);
				gotoxy(15,13);textcolor(white);
				write('PIN: ');
				textcolor(lightgreen);readln(reg.pin);
				str(reg.pin, pin2);
				if(Length(pin2) < 4)Then
					Begin
						Delete(pin2,1, Length(pin2));
						GotoXY(15,13);
						delline;
						gotoxy(15,13);write('PIN: ');
						textcolor(lightgreen);readln(reg.pin);
					end;
				reg.saldo_disponivel:=0;
				reg.net:=0;
				reg.sms:=0;
				reg.bonus:=0;
				write(arq, reg);
				reg.id_cliente:= reg.id_cliente+1;
			end;
			close(arq);
	end;

Procedure Lista_de_clientes(var fich: arquivo);
	Begin
		ClrScr;
		Assign(arq, 'Clientes.dat');
		Reset(arq);
		while not Eof(arq) Do
			Begin
				read(arq, reg);
				writeln('Cliente n°: ', reg.id_cliente);
				writeln('Nome completo: ', reg.nome);
				writeln('Data de nascimento: ', reg.nascimento);
				writeln('Bilhete de identidade: ', reg.bi);
				writeln('Saldo: ', reg.saldo_disponivel,' MT');
				writeln('Bónus crédito: ', reg.bonus, ' MT');
				writeln('SMS: ', reg.sms);
				writeln('Megabytes: ', reg.net, ' MBs');
				writeln('Celular 1: ', reg.celular[1]);
				writeln('Celular 2: ', reg.celular[2]);
				writeln(reg.valor_credito);
				writeln(reg.sms);
				writeln(reg.bonus);
				writeln('------------------------------------------------');
			end;
		Close(arq);
	End;

Procedure Recarregar(var fich: arquivo);
	Begin
		ClrScr;
		indice:=1;
		textcolor(blue);
		textbackground(black);
	  gotoxy(28,2);Writeln('_PLATAFORMA DE RECARGA_');
	  textcolor(white);
		textbackground(blue);
		gotoxy(16,8);write('Número de celular: ');
		textcolor(yellow);readln(autentica_numero);
		gotoxy(16,9);textcolor(WHITE);
		write('PIN: ');
		Textcolor(yellow);readln(autentica_pin);
		Assign(arq, 'Clientes.dat');
		Reset(arq);
		for i:= 0 to FileSize(arq)-1 do
			Begin
				seek(arq, i);
				read(arq, reg);
				if((reg.celular[indice] = autentica_numero) or (reg.celular[indice+1] = autentica_numero))and(reg.pin = autentica_pin)Then
					Begin
						ClrScr;
						gotoxy(25,8);write('Código da recarga: ');
						textcolor(yellow);readln(autentica_credito);
						Assign(arq, 'Clientes.dat');
						Reset(arq);
						for i:= 0 to FileSize(arq)-1 do
							Begin
								Seek(fich, i);
								Read(arq, reg);
								if(reg.recarregar = autentica_credito)Then
									Begin
										ClrScr;
										Assign(fich, 'Clientes.dat');
										Reset(fich);
										ReWrite(fich);
										reg.saldo_disponivel := reg.saldo_disponivel + reg.valor_credito;
										gotoxy(8,8);writeln('Recarregou com ', reg.valor_credito, ' MT');
										gotoxy(8,9);writeln('O seu novo saldo é: ', reg.saldo_disponivel, ' MT');
										encontrei := True;
										write(fich, reg);
										gotoxy(8,10);writeln('Clique enter para voltar ao menu.');
										readln;
									end
								Else encontrei := False;
									if(encontrei = False) Then
										Begin
											ClrScr;
											gotoxy(8,8);textcolor(lightred);writeln('O código de recarga introduzido já foi usado');
											gotoxy(8,9);textcolor(white);writeln('Enter para voltar');
											readln;
										end
									Else
										Begin
											ClrScr;
											gotoxy(8,8);textcolor(lightred);writeln('O código de recarga introduzido é inválida');
											gotoxy(8,9);textcolor(white);writeln('Enter para voltar');
											readln;
										end;
								encontrei := True;
							end;
					End
				Else encontrei := False;
			End;
			close(arq);
			if (encontrei = False) Then
				Begin
					ClrScr;
					gotoxy(8,8);textcolor(lightred);writeln('O número ', autentica_numero,' nao foi registrado.');
					gotoxy(8,9);textcolor(white);writeln('Enter para voltar');
					readln;
				end;
	End;

Procedure Comprar_recarga(var fich: arquivo);
	Label
		airtime;
	Begin
		airtime:
		Assign(fich, 'Clientes.dat');
		Reset(fich);
		for i:= 1 to FileSize(fich)-1 do
		Begin
		seek(fich,i);
		read(fich, reg);
		ClrScr;
		textcolor(blue);
		textbackground(black);
	  gotoxy(28,2);Writeln('_PLATAFORMA DE COMPRA DE RECARGAS_');
	  textcolor(white);
		textbackground(blue);
		GotoXY(25,8);writeln('[1] 10 Mt');
		GotoXY(25,9);writeln('[2] 20 Mt');
		GotoXY(25,10);writeln('[3] 50 Mt');
		gotoxy(25,11);writeln('[4] 100 Mt');
		gotoxy(25,12);writeln('[5] 200 Mt');
		gotoxy(25,13);writeln('[6] Outras recargas');
		gotoxy(25,14);writeln('[7] Voltar');
		GotoXY(25,14);WriteLn('--------------------');
		GotoXY(25,15);write('>>> ');
		Readln(opcao);
		case(opcao)of
			1: Begin
						ClrScr;
						Assign(fich, 'Clientes.dat');
						Reset(fich);
						ReWrite(fich);
						reg.valor_credito := 10;
						reg.sms:= 3;
						reg.bonus:= 5;
						Randomize;
						reg.recarregar:= 10+Random(RECARGA);
						seek(fich,i);
						Write(fich,reg);
						Close(fich);
						//reg.estado_credito := True;
						ClrScr;
						gotoxy(10,8);writeln('A sua compra de recarga no valor de ', reg.valor_credito, ' foi efectuada com sucesso.');
						gotoxy(10,9);writeln('O codigo da recarga: ', reg.recarregar);
						gotoxy(10,10);writeln('Clique enter para voltar ao menu');
						readln;
				 end;
			2: Begin
						Assign(fich, 'Clientes.dat');
						Reset(fich);
						ReWrite(fich);
						ClrScr;
						reg.valor_credito := 20;
						reg.sms:= 5;
						reg.bonus:= 10;
						Randomize;
						reg.recarregar:= 20+Random(RECARGA);
						Write(fich,reg);
						Close(fich);
						//reg.estado_credito := True;
						ClrScr;
						gotoxy(10,8);writeln('A sua compra de recarga no valor de ', reg.valor_credito, ' foi efectuada com sucesso.');
						gotoxy(10,9);writeln('O codigo da recarga: ', reg.recarregar);
						gotoxy(10,10);writeln('Clique enter para voltar ao menu');
						readln;
				 end;
			3: Begin
						Assign(fich, 'Clientes.dat');
						Reset(fich);
						ReWrite(fich);
						ClrScr;
						reg.valor_credito := 50;
						reg.sms:= 10;
						reg.bonus:= 25;
						Randomize;
						reg.recarregar:= 50+Random(RECARGA);
						Write(fich,reg);
						Close(fich);
						//reg.estado_credito := True;
						ClrScr;
						gotoxy(10,8);writeln('A sua compra de recarga no valor de ', reg.valor_credito, ' foi efectuada com sucesso.');
						gotoxy(10,9);writeln('O codigo da recarga: ', reg.recarregar);
						gotoxy(10,10);writeln('Clique enter para voltar ao menu');
						readln;
				 end;
			4: Begin
						Assign(fich, 'Clientes.dat');
						Reset(fich);
						ReWrite(fich);
						clrScr;
						reg.valor_credito := 100;
						reg.sms:= 25;
						reg.bonus:= 50;
						Randomize;
						reg.recarregar:= 100+Random(RECARGA);
						Write(fich,reg);
						Close(fich);
						//reg.estado_credito := True;
						ClrScr;
						gotoxy(10,8);writeln('A sua compra de recarga no valor de ', reg.valor_credito, ' foi efectuada com sucesso.');
						gotoxy(10,9);writeln('O codigo da recarga: ', reg.recarregar);
						gotoxy(10,10);writeln('Clique enter para voltar ao menu');
						readln;
				 end;
			5: Begin
						Assign(fich, 'Clientes.dat');
						Reset(fich);
						ReWrite(fich);
						ClrScr;
						reg.valor_credito := 200;
						Randomize;
						reg.recarregar:= 200+Random(RECARGA);
						Write(fich,reg);
						Close(fich);
						//reg.estado_credito := True;
						ClrScr;
						gotoxy(10,8);writeln('A sua compra de recarga no valor de ', reg.valor_credito, ' foi efectuada com sucesso.');
						gotoxy(10,9);writeln('O codigo da recarga: ', reg.recarregar);
						gotoxy(10,10);writeln('Clique enter para voltar ao menu');
						readln;
				 End;
			6: Begin
						Assign(fich, 'Clientes.dat');
						Reset(fich);
						ReWrite(fich);
						ClrScr;
						GotoXY(25,8);write('Digite o valor da recarga: ');
						readln(reg.valor_credito);
						reg.sms:= reg.valor_credito div 2;
						reg.sms:= reg.sms div 2;
						reg.bonus:= reg.valor_credito div 2;
						reg.bonus:= reg.bonus div 2;
						reg.recarregar := reg.valor_credito+Random(RECARGA);
						//reg.estado_credito := True;
						write(fich, reg);
						Close(fich);
						if(reg.valor_credito < 0)and(reg.valor_credito < 10)Then
							Begin
								gotoxy(25,9);writeln('O valor minimo para compra de rercarga e de 10 Mt.');
								goto airtime;
							end;
						ClrScr;
						gotoxy(10,8);writeln('A sua compra de recarga no valor de ', reg.valor_credito, ' foi efectuada com sucesso.');
						gotoxy(10,9);writeln('O codigo da recarga: ', reg.recarregar);
						gotoxy(10,10);writeln('Clique enter para voltar ao menu');
						readln;
				 End;
			7: readln;
			//Else goto airtime;
		end;
		//break;
		end;
		Close(fich);
	end;
Begin
	inicio:
	Textcolor(white);
	Textbackground(Black+Blue);
	ClrScr;
	Textcolor(blue);
  Textbackground(black);
  gotoxy(26,3);Writeln('_BEM VINDO AO MENU INICIAL_');
  Textcolor(white);
  Textbackground(blue);
	gotoxy(25,10);writeln('  [1] Acessar o sistema           ');
	gotoxy(25,11);writeln('  [2] Criar usuário               ');
	gotoxy(25,12);writeln('  [3] Opções                      ');
	gotoxy(25,13);writeln('  [4] Sair                        ');
	gotoxy(25,14);writeln('==================================');
	gotoxy(25,15);write('>>> ');
	readln(opcao);
	case(opcao)Of
		1: Begin
				 login:
				 Assign(arq2, 'Administrador.dat');
				 Existe_Administrador(arq2);
				 if( Existe_Administrador(arq2) = True)Then
					 Begin
						 ClrScr;
			       Textcolor(blue);
		         Textbackground(black);
		         gotoxy(34,3);Writeln('_LOGIN DO ADMIN_');
		         Textcolor(white);
		         Textbackground(blue);
						 gotoxy(25,12);write('Username: ');
						 textcolor(lightgreen);readln(user);
						 for up :=1 to Length(user)do
							user[up]:= Upcase(user[up]);
						 gotoxy(25,13);textcolor(white);
						 write('Password: ');
						 textcolor(lightgreen);readln(pass);
						 for up := 1 to Length(pass)do
							pass[up]:= upcase(pass[up]);
						 Assign(arq2, 'Administrador.dat'); 
						 Reset(arq2);
						 for i:= 0 to FileSize(arq2)-1 do
						 	Begin
								 Seek(arq2, i);
								 read(arq2, admin);
								 if(admin.username = user)and(admin.password = pass)Then
								 	Begin
										menu:
										ClrScr;
										Textcolor(blue);
						        Textbackground(black);
						        gotoxy(24,3);Writeln('_BEM VINDO AO SISTEMA DE TELEFONIA_');
						        Textcolor(white);
						        Textbackground(blue);
										{window(10,8, 72,22);
										textbackground(lightred);
										ClrScr;                }
										gotoxy(23,8);writeln('[1] Registrar cliente');
										gotoxy(23,9);writeln('[2] Lista de clientes registrados');
										gotoxy(23,10);writeln('[3] Comprar credito');
										gotoxy(23,11);writeln('[4] Recarregar');
										gotoxy(23,12);writeln('[5] Consultar saldo');
										gotoxy(23,13);writeln('[6] Tranferir credito (Not working)');
										gotoxy(23,14);writeln('[7] Efectuar Chamada (Not working)');
										gotoxy(23,15);writeln('[8] Movimentos (Not working)');
										gotoxy(23,16);writeln('[9] Sair');
										GotoXY(23,17);writeln('---------------------------------');
										GotoXY(23,18);write('>>> ');
										Readln(opcao);
										Case(opcao)Of
											1: Begin
														ClrScr;
														Assign(arq, 'Clientes.dat');
														Existe_Clientes(arq);
														if(Existe_Clientes(arq) = True) Then
															Begin
																ClrScr;
																Assign(arq, 'Clientes.dat');
																Adicionar_Clientes(arq);
																ClrScr;
																gotoxy(22,8);textcolor(lightgreen);writeln('Cliente registrado com sucesso.');
																gotoxy(22,9);textcolor(white);writeln('Clique enter para voltar ao menu incial');
																readln; goto menu;
															End
														Else
															Begin
																ClrScr;
																Assign(arq, 'Clientes.dat');
																Registrar_Clientes(arq);
																ClrScr;
																gotoxy(22,8);textcolor(lightgreen);writeln('Cliente registrado com sucesso.');
																gotoxy(22,9);textcolor(white);writeln('Clique enter para voltar ao menu incial');
																readln; goto menu;
															End;
												 End;
											2: Begin
														ClrScr;
														Assign(arq, 'Clientes.dat');
														Existe_Clientes(arq);
														if(Existe_Clientes(arq) = True)Then
															Begin
																clrScr;
																Assign(arq, 'Clientes.dat');
																Lista_de_clientes(arq);
																writeln('Clique enter para voltar ao menu.');
																readln; goto menu;
															End
														Else
															Begin
																vazio:
																ClrScr;
																gotoxy(22,8);textcolor(lightred);writeln('Sem clientes registrados em nosso sistema.');
																gotoxy(22,9);textcolor(white);writeln('Clique enter para voltar ao menu incial');
																readln; goto menu;
															End;
												 End;
											3: Begin
														ClrScr;
														Assign(arq, 'Clientes.dat');
														Existe_Clientes(arq);
														if(Existe_Clientes(arq) = True)Then
															Begin
																ClrScr;
																Assign(arq, 'Clientes.dat');
																Comprar_recarga(arq);
																goto menu;
															End
														Else goto vazio;
												 End;
											4: Begin
														ClrScr;
														Assign(arq, 'Clientes.dat');
														Existe_Clientes(arq);
														if(Existe_Clientes(arq) = True)Then
															Begin
																Assign(arq, 'Clientes.dat');
																Recarregar(arq);
																goto menu;
															end
														Else goto vazio;
												 End;
											5: Begin
														ClrScr;
														Assign(arq, 'Clientes.dat');
														Existe_Clientes(arq);
														if(Existe_Clientes(arq) = True)Then
															Begin
																ClrScr;
																indice:=1;
																textcolor(blue);
																textbackground(lightcyan);
															  gotoxy(35,2);Writeln('_CONSULTA DE SALDO_');
															  textcolor(white);
																textbackground(blue);
																gotoxy(16,8);write('Número de celular: ');
																textcolor(yellow);readln(autentica_numero);
																gotoxy(16,9);textcolor(WHITE);
																write('PIN: ');
																Textcolor(yellow);readln(autentica_pin);
																Assign(arq, 'Clientes.dat');
																Reset(arq);
																for i:= 0 to FileSize(arq)-1 do
																	Begin
																		Seek(arq, i);
																		read(arq, reg);
																		if((reg.celular[indice] = autentica_numero)or(reg.celular[indice+1] = autentica_numero))and(reg.pin = autentica_pin)Then
																			Begin
																				ClrScr;
																				gotoxy(15,6);writeln('Numero de telefone: ', reg.celular[indice]);
																				gotoxy(15,7);writeln('Saldo: ', reg.saldo_disponivel);
																				gotoxy(15,8);writeln('Bonus credito: ', reg.bonus);
																				gotoxy(15,9);writeln('SMS: ', reg.sms);
																				encontrei := True;
																				gotoxy(15,10);writeln('-------------------------------------------');
																				gotoxy(15,11);writeln('Clique enter para voltar ao menu');
																				readln; goto menu;
																			end
																		Else encontrei := False;
																	end;
																	Close(arq);
																	if(encontrei = False)Then
																		Begin
																			ClrScr;
																			gotoxy(20,8);textcolor(lightred);writeln('Os dados introduzidos nao foram encontrados');
																			gotoxy(20,9);textcolor(white);writeln('Clique enter para voltar ao menu.');
																			readln; goto menu;
																		End;
															end
														Else goto vazio;
												 End;
											6: Begin
												 End;
											7: Begin
												 End;
											8: Begin
												 End;
											9: Exit
											Else goto menu;
										end;
										encontrei:= True;
									end
									Else encontrei:= False;
							End;
							Close(arq2);
							if(encontrei = false)Then
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
								end;
					 end
				Else
					Begin
						ClrScr;
						gotoxy(22,8);textcolor(lightred);writeln('Sem clientes registrados em nosso sistema.');
						gotoxy(22,9);textcolor(white);writeln('Clique enter para voltar ao menu incial');
						readln; goto inicio;
					End;
			 end;
		2: Begin
					Assign(arq2, 'Administrador.dat');
					Existe_Administrador(arq2);
					if(Existe_Administrador(arq2) = True)Then
						Begin
							Assign(arq2, 'Administrador.dat');
							Adicionar_Registro_Admninistrador(arq2);
							ClrScr;
							gotoxy(22,8);textcolor(lightgreen);writeln('Cliente registrado com sucesso.');
							gotoxy(22,9);textcolor(white);writeln('Clique enter para voltar ao menu incial');
							readln; goto inicio;
						End
					Else
						Begin
							Assign(arq2, 'Administrador.dat');
							Registrar_Admninistrador(arq2);
							ClrScr;
							gotoxy(22,8);textcolor(lightgreen);writeln('Cliente registrado com sucesso.');
							gotoxy(22,9);textcolor(white);writeln('Clique enter para voltar ao menu incial');
							readln; goto inicio;
						end;
			 End;
		3: Begin
					ClrScr;
					Assign(arq2, 'Administrador.dat');
					Reset(arq2);
					While not Eof(arq2)do
						Begin
							read(arq2, admin);
							writeln('ID: ',admin.id_admin);
							writeln('PERFIL: ', admin.perfil);
							writeln('NOME: ',admin.nome);
							writeln('DATA DE NASCIMENTO: ', admin.nascimento);
							writeln('BILHETE DE IDENTIDADE: ',admin.bi);
							writeln('USERNAME: ', admin.username);
							writeln('Password: ',admin.password);
							writeln('---------------------------------');
						end;
					Close(arq2);
			 End;
		4: Exit
		Else goto inicio;
	end;
end.