Unit Design;
Interface
Uses crt;

Procedure Layout_1;
Procedure Layout_2;

Implementation

Procedure Layout_1;
	Var i, j: Integer;
  Begin
		textbackground(blue);
		ClrScr;
		textcolor(yellow);gotoxy(16,30);
		lowvideo;Writeln('Desenvolvidores: Carlos Macaneta & Luana Maculuve');
		textcolor(white);
	  {----Letra C----}
	  For i:=4 To 16 Do
		  Begin;
		    Gotoxy(i,4);
		    Write(#232);
				delay(25);
		  End;
	  For i:=4 To 16 Do
		  Begin;
		    Gotoxy(4,i);
		    Write(#232);
				delay(25);
		  End;
	  For i:=4 To 16 Do
		  Begin;
		    Gotoxy(i,16);
		    Write(#232);
				delay(25);
		  End;
		{----Letra S----}
	  For i:= 18 To 30 Do
		  Begin;
		    Gotoxy(i,4);
		    Write(#232);
				delay(25);
		  End;
		For i:=4 To 10 Do
		  Begin;
		    Gotoxy(18,i);
		    Write(#232);
				delay(25);
		  End;
		For i:=18 To 30 Do
		  Begin;
		    Gotoxy(i,10);
		    Write(#232);
				delay(25);
		  End;
		For i:=10 To 16 Do
		  Begin;
		    Gotoxy(30,i);
		    Write(#232);
				delay(25);
		  End;
		For i:=18 To 30 Do
		  Begin;
		    Gotoxy(i,16);
		    Write(#232);
				delay(25);
		  End;
	End;

Procedure Layout_2;
	var i, j: Integer;
	Begin
		Layout_1;
	  Gotoxy(37,12);
	  textcolor(yellow);
	  Writeln('Computer Shop');
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
		Layout_1;
	  For i:=25 Downto 17 Do
	    Begin
	      Gotoxy(37,12);
	      textcolor(yellow);
	      Writeln('Computer Shop');
	      Gotoxy(37,13);
	      textcolor(lightgreen);
	      Writeln('Loading');
	      Gotoxy(i+20,15);
	      textcolor(yellow);
	      Write(#249);
	      delay(110);
	    End;
	  textcolor(white);
		Layout_1;
	  For i:=17 To 25 Do
	    Begin
	      Gotoxy(37,12);
	      textcolor(yellow);
	      Writeln('Computer Shop');
	      Gotoxy(37,13);
	      textcolor(lightgreen);
	      Writeln('Welcome to Computer Shop');
	      Gotoxy(i+20,15);
	      textcolor(lightred);
	      Write(#249);
	      delay(100);
	    End;
	End;

Begin
End.