VAR CONSTANT      
P1 : McPointType := (Pos:=(X:=140.4, Y:=0, Z:=97));
P2 : McPointType := (Pos:=(X:=-83, Y:=-195, Z:=80));
P3 : McPointType := (Pos:=(X:=-83, Y:=-195, Z:=42));
P5 : McPointType := (Pos:=(X:=-83, Y:=-30, Z:=80));
P6 : McPointType := (Pos:=(X:=-83, Y:=-30, Z:=39));
P8 : McPointType := (Pos:=(X:=-45, Y:=-195, Z:=80));
P9 : McPointType := (Pos:=(X:=-45, Y:=-195, Z:=47));
	Gripper := FALSE;
	END_VAR

	PROGRAM _MAIN          
	Feedrate(5000);   //move with reduced speeda
	MoveJ(P1);        //move system to point P1
	MoveJ(P2);        //move system to point P2
	MoveJ(P3);
	Gripper := TRUE;
	MoveJ(P2);
	MoveJ(P5);
	MoveJ(P6);
	Gripper := FALSE;
	MoveJ(P5);
	MoveJ(P8);
	MoveJ(P9);
	Gripper := TRUE;
	MoveJ(P8);
	MoveJ(P5);
	MoveJ(P6);
	Gripper := FALSE;
	MoveJ(P5);
	WaitTime(3);        //wait for 3 seconds
	MoveJ(P1);        //move back to origin position
	END_PROGRAM