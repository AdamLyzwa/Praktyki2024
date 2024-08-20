PROGRAM _INIT
	MpDelta4Axis_0.Enable := TRUE; 
	MpDelta4Axis_0.Override := 100.0; 
  //File stored on FileDevice
	
	FB_Axis1;
	FB_Axis2;
	FB_Axis3;
	FB_Axis4;

//	gAxisQ1;
//	gAxisQ2;
//	gAxisQ3;
//	gAxisQ4;
	
	FB_Axis1.Enable := TRUE;
	FB_Axis2.Enable := TRUE;
	FB_Axis3.Enable := TRUE;
	FB_Axis4.Enable := TRUE;
	
	KrokXYZ := CHECK;
END_PROGRAM

PROGRAM _CYCLIC
	CASE KrokXYZ OF
		CHECK:
			IF MpDelta4Axis_0.Active THEN
	  			KrokXYZ := POWER;
			END_IF;
		POWER:
			MpDelta4Axis_0.Power := TRUE;
			IF MpDelta4Axis_0.PowerOn THEN
				KrokXYZ := HOME;
			END_IF;
		HOME:
			MpDelta4Axis_0.Home := TRUE;
			IF MpDelta4Axis_0.IsHomed THEN
				MpDelta4Axis_0.Home := FALSE;
				KrokXYZ := PROG;
				setX := X;
				setY := Y;
				setZ := Z;
			END_IF;
		PROG:
			(*DeltaParameters.ProgramName := 'Robotic.st';*)
			X := MpDelta4Axis_0.Info.JointAxisPosition[0];
			Y := MpDelta4Axis_0.Info.JointAxisPosition[1];
			Z := MpDelta4Axis_0.Info.JointAxisPosition[2];				
//			P1.Pos.X:= setX;
//			P1.Pos.Y:= setY;
//			P1.Pos.Z:= setZ;
//			DeltaParameters.Distance[0] := ABS(MpDelta4Axis_0.X - setX);
//			DeltaParameters.Distance[1]:= ABS(MpDelta4Axis_0.Y - setY);
//			DeltaParameters.Distance[2]:=ABS(MpDelta4Axis_0.Z - setZ);
			DeltaParameters.Position[0] := setX;
			DeltaParameters.Position[1]:= setY;
			DeltaParameters.Position[2]:= setZ;
			IF saveChanges THEN
	  			KrokXYZ:=RUCH;
			END_IF;
		RUCH:
				MpDelta4Axis_0.MoveLinear :=TRUE;
//				MpDelta4Axis_0.MoveProgram := TRUE;				
	END_CASE;
	
	FB_Axis1.MpLink     := ADR(gAxisQ1);
	FB_Axis1.Parameters := ADR(AxisParam1);
	FB_Axis1();
	
	FB_Axis2.MpLink     := ADR(gAxisQ2);
	FB_Axis2.Parameters := ADR(AxisParam2);
	FB_Axis2();
	
	FB_Axis3.MpLink     := ADR(gAxisQ3);
	FB_Axis3.Parameters := ADR(AxisParam3);
	FB_Axis3();
	
	FB_Axis4.MpLink     := ADR(gAxisQ4);
	FB_Axis4.Parameters := ADR(AxisParam4);
	FB_Axis4();
		
	MpDelta4Axis_0.Parameters := ADR(DeltaParameters); 
	MpDelta4Axis_0.MpLink := ADR(g4AxDeltaA);
	MpDelta4Axis_0();
	
END_PROGRAM
	
PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

