Program per;
Uses crt, dos;

var
	i, j: Integer;
Begin
Textbackground(lightblue);
ClrScr;
j:=0;
gotoxy(33,12);writeln('Aguarde Por favor...');
Textbackground(lightblue);
	for i := 1 to 25 do
		Begin
	    j:=j+4;
	    Gotoxy(41,14);
	    textcolor(white);

	    Writeln(j,'%');
	    Gotoxy(i+29,13);
	    textcolor(Black);
	    Write(#226);
	    delay(15);
		end;
		textcolor(white);
End.