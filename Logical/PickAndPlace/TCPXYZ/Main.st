PROGRAM _INIT
	MpDelta4Axis_0.Override := 100.0; 
	//	MpDelta4Axis_0.Enable := TRUE;
	DeltaParameters.Velocity :=10;
	DeltaParameters.Acceleration :=100;
	DeltaParameters.Deceleration :=100;
	FB_Axis1.Enable :=TRUE;
	FB_Axis2.Enable :=TRUE;
	FB_Axis3.Enable :=TRUE;
	FB_Axis4.Enable :=TRUE;
//	TCP := TRUE;
//	saveChanges := FALSE;
//		
	AxisParam1.Homing.Mode := mcHOMING_ABSOLUTE;
	AxisParam1.Homing.Position := -472776.56;
	AxisParam2.Homing.Mode := mcHOMING_ABSOLUTE;
	AxisParam2.Homing.Position := 77660.78;
	AxisParam3.Homing.Mode := mcHOMING_ABSOLUTE;
	AxisParam3.Homing.Position := 3712.2;
		
	KrokXYZ := POWERAXIS;
END_PROGRAM

PROGRAM _CYCLIC
	CASE KrokXYZ OF
		POWERAXIS:
			IF FB_Axis1.Active AND FB_Axis2.Active AND FB_Axis3.Active THEN
				FB_Axis1.Power := TRUE;
				FB_Axis2.Power := TRUE;
				FB_Axis3.Power := TRUE;
				FB_Axis4.Power := TRUE;
				KrokXYZ := HOMEAXIS;
			END_IF
		HOMEAXIS:
			IF FB_Axis1.PowerOn AND FB_Axis2.PowerOn AND FB_Axis3.PowerOn THEN
				FB_Axis1.Home := TRUE;
				FB_Axis2.Home := TRUE;
				FB_Axis3.Home := TRUE;
				FB_Axis4.Home := TRUE;
				
				KrokXYZ := CHECKAXIS;
			END_IF
		CHECKAXIS:
			IF FB_Axis1.IsHomed AND FB_Axis2.IsHomed AND FB_Axis3.IsHomed THEN
				FB_Axis1.Home := FALSE;
				FB_Axis2.Home := FALSE;
				FB_Axis3.Home := FALSE;
				FB_Axis4.Home := FALSE;
				
				FB_Axis1.Enable :=FALSE;
				FB_Axis2.Enable :=FALSE;
				FB_Axis3.Enable :=FALSE;
				FB_Axis4.Enable :=FALSE;
				//				
				KrokXYZ := CHECKDELTA;
			END_IF
		CHECKDELTA:
			IF NOT FB_Axis1.Active AND NOT FB_Axis2.Active AND NOT FB_Axis3.Active THEN
				MpDelta4Axis_0.Enable :=TRUE;
				KrokXYZ := CHECK;
			END_IF
		CHECK:
			MpDelta4Axis_0.MoveDirect := FALSE;
			MpDelta4Axis_0.MoveLinear := FALSE;
			IF MpDelta4Axis_0.Active AND MpDelta4Axis_0.IsHomed AND MpDelta4Axis_0.PowerOn THEN
				KrokXYZ := HOME;
			END_IF;

			
			IF MpDelta4Axis_0.Active THEN
				KrokXYZ := POWER;
			END_IF;
		POWER:
			MpDelta4Axis_0.Power := TRUE;
			IF MpDelta4Axis_0.PowerOn THEN
				KrokXYZ := HOME;
			END_IF;
		HOME:
			IF MpDelta4Axis_0.IsHomed THEN
				setX := MpDelta4Axis_0.X;
				setY :=  MpDelta4Axis_0.Y;
				setZ := MpDelta4Axis_0.Z;
					
				setAxis1 := MpDelta4Axis_0.Info.JointAxisPosition[0];
				setAxis2 := MpDelta4Axis_0.Info.JointAxisPosition[1];
				setAxis3 := MpDelta4Axis_0.Info.JointAxisPosition[2];
				
				KrokXYZ := PROG;
			END_IF;
		PROG:
			IF TCP = TRUE THEN
				DeltaParameters.CoordSystem := 1;
				DeltaParameters.Position[0] := setX;
				DeltaParameters.Position[1]:= setY;
				DeltaParameters.Position[2]:= setZ;
				DeltaParameters.Position[3]:= 0;
			ELSE 
				DeltaParameters.CoordSystem := 0;
				DeltaParameters.Position[0] := setAxis1;
				DeltaParameters.Position[1]:= setAxis2;
				DeltaParameters.Position[2]:= setAxis3;
				DeltaParameters.Position[3]:= 0;
 			END_IF;

			IF saveChanges THEN
				KrokXYZ:=RUCH;
			END_IF;
		RUCH:
			IF DeltaParameters.CoordSystem = 1 THEN
				MpDelta4Axis_0.MoveLinear := TRUE;
			ELSE 
				MpDelta4Axis_0.MoveDirect := TRUE;
			END_IF;

			saveChanges :=FALSE;
			KrokXYZ:=FLAGI;
		FLAGI: 
			IF DeltaParameters.CoordSystem = 0 AND ABS(MpDelta4Axis_0.Info.JointAxisPosition[0]-setAxis1)<0.1 AND ABS(MpDelta4Axis_0.Info.JointAxisPosition[1]-setAxis2)<0.1 AND ABS(MpDelta4Axis_0.Info.JointAxisPosition[2]-setAxis3)<0.1 THEN
				KrokXYZ:=CHECK;
			END_IF
			
			IF DeltaParameters.CoordSystem = 1 AND ABS(MpDelta4Axis_0.X-setX)<0.1 AND ABS(MpDelta4Axis_0.Y - setY)<0.1 AND ABS(MpDelta4Axis_0.Z-setZ)<0.1 THEN
				KrokXYZ:=CHECK;
			END_IF
			
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

