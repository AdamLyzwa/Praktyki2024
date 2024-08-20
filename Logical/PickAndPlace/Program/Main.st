PROGRAM _INIT
	FB_Axis1;
	FB_Axis2;
	FB_Axis3;
	FB_Axis4;
	
	FB_Axis1.Enable := TRUE;
	FB_Axis2.Enable := TRUE;
	FB_Axis3.Enable := TRUE;
	FB_Axis4.Enable := TRUE;
	
	KrokXYZ := CHECK;
END_PROGRAM

PROGRAM _CYCLIC
	CASE KrokXYZ OF
		CHECK:
			FB_Axis1.MoveAbsolute :=FALSE;
			FB_Axis1.MoveAbsolute :=FALSE;
			FB_Axis1.MoveAbsolute :=FALSE;
			IF FB_Axis1.Active AND FB_Axis1.Active AND FB_Axis1.Active THEN
				KrokXYZ := POWER;
			END_IF;
		POWER:
			FB_Axis1.Power := TRUE;
			FB_Axis2.Power := TRUE;
			FB_Axis3.Power := TRUE;
			
			IF FB_Axis1.PowerOn AND FB_Axis1.PowerOn AND FB_Axis1.PowerOn THEN
				KrokXYZ := HOME;
			END_IF;
		HOME:
			FB_Axis1.Home := TRUE;
			FB_Axis2.Home := TRUE;
			FB_Axis3.Home := TRUE;
			
			IF FB_Axis1.IsHomed AND FB_Axis2.IsHomed AND FB_Axis3.IsHomed THEN
				FB_Axis1.Home := FALSE;
				FB_Axis2.Home := FALSE;
				FB_Axis3.Home := FALSE;
				
				KrokXYZ := PROG;
				setAxis1:=  FB_Axis1.Position;
				setAxis2 := FB_Axis2.Position;
				setAxis3 := FB_Axis3.Position;
			END_IF;
		PROG:
			(*DeltaParameters.ProgramName := 'Robotic.st';*)
			AxisParam1.Position := setAxis1;
			AxisParam2.Position := setAxis2;
			AxisParam3.Position := setAxis3;
			IF saveChanges THEN
				KrokXYZ:=RUCH;
			END_IF;
		RUCH:
			IF  FB_Axis1.Position<> setAxis1 THEN
	  			FB_Axis1.MoveAbsolute := TRUE;
			END_IF;
			IF FB_Axis2.Position <> setAxis2 THEN
				FB_Axis2.MoveAbsolute := TRUE;
			END_IF;
			IF FB_Axis3.Position <> setAxis3 THEN
				FB_Axis3.MoveAbsolute := TRUE;
			END_IF;
			saveChanges :=FALSE;
			
			KrokXYZ:=FLAGI;
		FLAGI: 
			IF FB_Axis1.Position = setAxis1 AND FB_Axis2.Position = setAxis2 AND FB_Axis3.Position = setAxis3 THEN
				KrokXYZ:=CHECK;
			END_IF
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
		

END_PROGRAM
	
PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

