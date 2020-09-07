Program n_testes;
uses crt;

Label
	admitido;

Var
	n, i: Integer;
	somatestes,testes,
	media, peso,
	somapeso, pesoteste: Real;

Begin
	textbackground(black);
	ClrScr;
	write('Informe o numero de testes: ');
	readln(n);
	for i:=1 to n do
		Begin
			ClrScr;
			write('Teste ', i, ': ');
			readln(testes);
			write('Peso do teste ', i, ': ');
			readln(peso);
			if((testes < 0) and (testes > 20)) and((peso < 0) and (peso >1))then
				Begin
					ClrScr;
					writeln('O teste nao pode ter uma nota inferior a 0 e superior a 20.');
					writeln('O peso nao pode ser superior a 1 e inderior a 0.');
				end
			Else
				Begin
					somatestes := somatestes + testes;
					pesoteste := testes * peso;
					somapeso := somapeso + pesoteste;
					media := somapeso;
					if(media < 10)Then
						Begin
							ClrScr;
							writeln('A sua media e: ', media:2:2, ', excluido');
						end
					Else
						Begin
							if(testes >= 10)and(testes <= 20)Then
								Begin
									if(media >= 14)and(media <= 20) Then
										Begin
											ClrScr;
											writeln('A sua media e: ', media:2:2, ' dispensado');
										end
									Else
										Begin
											if(media <= 20)then
												Begin
													admitido:
													ClrScr;
													writeln('A sua media e: ', media:2:2, ' admitido');
												end;
										end;
								end
							Else goto admitido;
						end;
				end;
		end;
end.