PROGRAM _INIT
	KrokXYZ := CHECK;
	
	FB_Axis1.Enable := TRUE;
	FB_Axis2.Enable := TRUE;
	FB_Axis3.Enable := TRUE;
	
END_PROGRAM

PROGRAM _CYCLIC
//	CASE KrokXYZ OF
//		CHECK:
//			IF 	manXYZ THEN
//				FB_Axis1.Home := FALSE;
//				FB_Axis2.Home := FALSE;
//				FB_Axis3.Home := FALSE;
//				
//				FB_Axis1.Power := FALSE;
//				FB_Axis2.Power := FALSE;
//				FB_Axis3.Power := FALSE;
//				
//				FB_Axis1.Enable := FALSE;
//				FB_Axis2.Enable := FALSE;
//				FB_Axis3.Enable := FALSE;
//
//				KrokXYZ := WAIT;
//			END_IF;
//			FB_Axis1.MoveAbsolute :=FALSE;
//			FB_Axis2.MoveAbsolute :=FALSE;
//			FB_Axis3.MoveAbsolute :=FALSE;
//			IF FB_Axis1.Active AND FB_Axis2.Active AND FB_Axis3.Active THEN
//				KrokXYZ := POWER;
//			END_IF;
//		POWER:
//			FB_Axis1.Power := TRUE;
//			FB_Axis2.Power := TRUE;
//			FB_Axis3.Power := TRUE;
//			
//			IF FB_Axis1.PowerOn AND FB_Axis2.PowerOn AND FB_Axis3.PowerOn THEN
//				KrokXYZ := HOME;
//			END_IF;
		(*HOME:*)
	AxisParam1.Homing.Mode := mcHOMING_ABSOLUTE;
	AxisParam1.Homing.Position := -472776.56;
	AxisParam2.Homing.Mode := mcHOMING_ABSOLUTE;
	AxisParam2.Homing.Position := 77660.78;
	AxisParam3.Homing.Mode := mcHOMING_ABSOLUTE;
	AxisParam3.Homing.Position := 3712.2;

//			IF FB_Axis1.IsHomed AND FB_Axis2.IsHomed AND FB_Axis3.IsHomed THEN
//				FB_Axis1.Home := FALSE;
//				FB_Axis2.Home := FALSE;
//				FB_Axis3.Home := FALSE;
//				
//				setAxis1:=  FB_Axis1.Position;
//				setAxis2 := FB_Axis2.Position;
//				setAxis3 := FB_Axis3.Position;
//				KrokXYZ := PROG;
//				
//			END_IF;
//		PROG:
//			(*DeltaParameters.ProgramName := 'Robotic.st';*)
//			IF 	manXYZ THEN
//				KrokXYZ := CHECK;
//			END_IF;
//			AxisParam1.Position := setAxis1;
//			AxisParam2.Position := setAxis2;
//			AxisParam3.Position := setAxis3;
//			IF saveChanges THEN
//				KrokXYZ:=RUCH;
//			END_IF;
//		RUCH:
//			IF  FB_Axis1.Position<> setAxis1 THEN
//				FB_Axis1.MoveAbsolute := TRUE;
//			END_IF;
//			IF FB_Axis2.Position <> setAxis2 THEN
//				FB_Axis2.MoveAbsolute := TRUE;
//			END_IF;
//			IF FB_Axis3.Position <> setAxis3 THEN
//				FB_Axis3.MoveAbsolute := TRUE;
//			END_IF;
//			saveChanges :=FALSE;
//			
//			KrokXYZ:=FLAGI;
//		FLAGI: 
//			IF FB_Axis1.Position = setAxis1 AND FB_Axis2.Position = setAxis2 AND FB_Axis3.Position = setAxis3 THEN
//				KrokXYZ:=CHECK;
//			END_IF
//		WAIT:
//			IF NOT manXYZ THEN
//				FB_Axis1.Enable := TRUE;
//				FB_Axis2.Enable := TRUE;
//				FB_Axis3.Enable := TRUE;
//				FB_Axis4.Enable := TRUE;
//				KrokXYZ:= CHECK;
//			END_IF
//	END_CASE;
	
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
//		

END_PROGRAM
	
PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

