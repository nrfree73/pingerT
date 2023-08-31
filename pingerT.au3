#include <file.au3>
#include <Misc.au3>
Local $hDLL = DllOpen("user32.dll")
Dim $a=0
Dim $check
$target=InputBox ("Pinger", "Entrez le nom de votre fichier (*.txt):  ")
if $target="" then
Exit
endif

$file= FileOpen(@scriptdir & "\" & $target & ".txt" ,0)

if @error then
Exit
endif

$check=FileReadToArray($file)
 If @error Then
        MsgBox($MB_SYSTEMMODAL, "", "Error reading the file. @error: " & @error) ; An error occurred reading the current script file.
	 Exit
	 EndIf

Global $nbreping=1
$nbreping=InputBox ("Pinger", "Nombre de pings:" & @CRLF &@CRLF &"    compris entre : (1 - 4)  ","1", "" , -1 , -1 , Default , Default , 5)
if @error=2 Then
   $nbreping=1
   EndIf

if $nbreping<1 or $nbreping>4 Then
   $nbreping=1
EndIf

		while 1
$text=""

if UBound($check) > 500 Then
   MsgBox(0,"info !","fichier à plus de 500 lignes à pinger.. abandon",7)
   Exit
   EndIf

        For $i = 0 To UBound($check) - 1 ; Loop through the array. UBound($aArray) can also be used.

If _IsPressed("1B", $hDLL) Then ;If _ispressed("10", $hdll) Then ;   1B ESC key

	$t= MsgBox(1,"","[OK] pour quitter...")
	if $t=1 Then
	  Exit
   else

   EndIf
EndIf


			for $g=1 to $nbreping ;3; nbre de pings...
			    $pong = Ping ($check[$i],1100)

;cycle sans separateur " ";
Select
Case Not StringInStr( $check[$i]," ") ;Then
	  If $pong>0 or StringInStr($pong,"True") Then ;ok
   if $g=1 then
   $text=$text & "Ping [OK] : " & $check[$i] & " , En ligne : " & " < " & $pong &" ms > " ;& @CRLF
   Else
   $text=$text & " < " & $pong &" ms > " ;& @CRLF
   EndIf

Else ;ko
    if $g=1 Then
    $text=$text & "Ping [ NOK ] : "  & $check[$i] & " , Injoignable ! " ; & $g;& @CRLF
    Else
	;$text=$text & " #"
    EndIf
EndIf
;EndIf;not " ";

;cycle avec separateur " ";
	  case StringInStr( $check[$i]," "); Then
		 $check2=StringSplit($check[$i]," ")
		 if IsArray($check2) Then ;si array: ok
			$pong = Ping ($check2[1],1100)

If $pong>0 or StringInStr($pong,"True") Then ;ok
   if $g=1 then
   $text=$text & "Ping [OK] : " & $check2[1] & " -- < " & $check2[2] & " > , En ligne : " & " < " & $pong &" ms > " ;& @CRLF
   Else
   $text=$text & " < " & $pong &" ms > " ;& @CRLF
   EndIf
Else ;ko
   if $g=1 then
   $text=$text & "Ping [ NOK ] : "  & $check2[1] & " --< " & $check2[2] & " > , Injoignable ! " ; & $g;& @CRLF
   Else
  ; $text=$text & " #"
EndIf

   EndIf
   EndIf
;EndIf


EndSelect

next ;$g
$text=$text & @CRLF
ToolTip($text ,5,5, "  Pinger / [ "  & $target & ".txt ]--[ " & $i+1 & "/" & UBound($check) & " ]--[max: 500 lignes]" )
if $i=50 or $i=100 or $i=150 or $i=200 or $i=250 or $i=300 or $i=350 or $i=400 or $i=450 or $i=500 Then
   MsgBox(0,"","[PAUSE] ..." ,180)
   $text=""
EndIf

        Next ;$i

MsgBox(0,"","[OK] pour refaire un ping..." &@CRLF & "[ESC]: Quitter ?",180)
$text=""
	  WEnd
