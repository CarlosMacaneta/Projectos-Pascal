Program Date_Hour;
Uses crt, dos;

Const
	Max = 2;

Procedure Data_hour;
	Var
		dia, mes, ano, hora, minuto, segundo, msegundo, weekday: word;

	Const
		diadasemana: Array [0..6] of String = ('Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab');
		mesdoano: Array [1..12] of String = ('Janeiro', 'Fevereiro', 'Marco', 'Abril', 'Maio', 'Junho',
		'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro');
	Begin
		getdate(ano, mes, dia, weekday);
		gettime(hora, minuto, segundo, msegundo);
		gotoxy(30,12);Writeln('Data e Hora: ');
		gotoxy(30,13);Writeln(diadasemana[weekday],',',dia,'/', mesdoano[mes],'/',ano);
		gotoxy(30,14);Write(hora,':',minuto,':',segundo:2);
		textcolor(yellow);writeln(':', msegundo);textcolor(white);
	end;

var
	i: integer;

Begin
	textbackground(black);
	ClrScr;
	i:=1;
	while i < Max do
		Begin
			Data_hour;
			delay(1);
		end;
end.