PROGRAM _INIT
	MpDelta4Axis_0.Override := 100.0; 
	//	MpDelta4Axis_0.Enable := TRUE;
	AxisParameters_0.Velocity     := 5.0;
	AxisParameters_0.Acceleration := 50.0;
	AxisParameters_0.Deceleration := 50.0;
	FB_AlarmCore.MpLink := ADR(gAlarmXCore);
	FB_AlarmCore.Enable := TRUE;	
	FB_AlarmHistory.MpLink := ADR(gAlarmXHistory);
	FB_AlarmHistory.Enable := TRUE;

	AxisParameters_1.Velocity     := 130.0;
	AxisParameters_1.Acceleration := 50.0;
	AxisParameters_1.Deceleration := 50.0;
			
//	AxisParam1.Homing.Mode := mcHOMING_ABSOLUTE;
//	AxisParam1.Homing.Position := -472771;
//	AxisParam2.Homing.Mode := mcHOMING_ABSOLUTE;
//	AxisParam2.Homing.Position := 77669;
//	AxisParam3.Homing.Mode := mcHOMING_ABSOLUTE;
//	AxisParam3.Homing.Position := 3718;
	
	KrokConv:= ENABLE;
	KrokXYZ := ENABLE;
	gAxisQ1;
	gAxisQ2;
	gAxisQ3;
	gAxisQ4;
END_PROGRAM

PROGRAM _CYCLIC
//	CASE KrokConv OF
//		ENABLE:
//			MpAxisBasic_0.Enable :=TRUE;
//			MpAxisBasic_1.Enable :=TRUE;
//			KrokConv:= CHECK;
//		CHECK:
//			IF MpAxisBasic_0.Active AND MpAxisBasic_1.Active THEN
//				MpAxisBasic_0.Power :=TRUE;
//				MpAxisBasic_1.Power :=TRUE;
//				KrokConv := POWER;
//			END_IF
//		POWER:
//			IF MpAxisBasic_0.PowerOn THEN
//				MpAxisBasic_0.Home := TRUE;
//				KrokConv := PROG;
//			END_IF
//		PROG:
//			IF MpAxisBasic_0.IsHomed THEN
//				IF ConveyerButton THEN
//					MpAxisBasic_0.MoveVelocity := TRUE;
//					KrokConv:= FLAGI;
//				ELSE
//					MpAxisBasic_0.MoveVelocity :=FALSE;
//				END_IF;
//
//			END_IF	
//		FLAGI:
//			IF NOT ConveyerButton OR NOT Mode THEN
//				MpAxisBasic_0.MoveVelocity :=FALSE;
//				MpAxisBasic_0.Home:=FALSE;
//				MpAxisBasic_0.Power:=FALSE;
//				MpAxisBasic_0.Enable:=FALSE;
//				KrokConv:= ON;
//			END_IF;
//	END_CASE


	CASE KrokXYZ OF
		ENABLE:
			FB_Axis1.Enable :=TRUE;
			FB_Axis2.Enable :=TRUE;
			FB_Axis3.Enable :=TRUE;
			FB_Axis4.Enable :=TRUE;
			MpAxisBasic_0.Enable:=TRUE;
			MpAxisBasic_1.Enable:=TRUE;
			
			KrokXYZ := POWERAXIS;
				
		POWERAXIS:
			IF FB_Axis1.Active AND FB_Axis2.Active AND FB_Axis3.Active THEN
				FB_Axis1.Power := TRUE;
				FB_Axis2.Power := TRUE;
				FB_Axis3.Power := TRUE;
				FB_Axis4.Power := TRUE;
				MpAxisBasic_0.Power := TRUE;
				MpAxisBasic_1.Power:=TRUE;	
				KrokXYZ := HOMEAXIS;
			END_IF
			
		HOMEAXIS:
			IF FB_Axis1.PowerOn AND FB_Axis2.PowerOn AND FB_Axis3.PowerOn THEN
				FB_Axis1.Home := TRUE;
				FB_Axis2.Home := TRUE;
				FB_Axis3.Home := TRUE;
				FB_Axis4.Home := TRUE;
				MpAxisBasic_0.Home := TRUE;
				MpAxisBasic_1.Home:=TRUE;
				
				KrokXYZ := CHECKAXIS;
			END_IF
			
		CHECKAXIS:
			IF FB_Axis1.IsHomed AND FB_Axis2.IsHomed AND FB_Axis3.IsHomed THEN
				FB_Axis1.Home := FALSE;
				FB_Axis2.Home := FALSE;
				FB_Axis3.Home := FALSE;
				FB_Axis4.Home := FALSE;
				MpAxisBasic_0.Home:= FALSE;
				MpAxisBasic_1.Home:=FALSE;
				FB_Axis1.Enable :=FALSE;
				FB_Axis2.Enable :=FALSE;
				FB_Axis3.Enable :=FALSE;
				FB_Axis4.Enable :=FALSE;
				
				KrokXYZ := CHECKDELTA;
			END_IF
			
		CHECKDELTA:
			IF NOT FB_Axis1.Active AND NOT FB_Axis2.Active AND NOT FB_Axis3.Active THEN
				MpDelta4Axis_0.Enable := TRUE;
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
			IF Mode AND ConveyerButton THEN
				MpAxisBasic_0.MoveVelocity := TRUE;
			ELSIF NOT Mode OR NOT ConveyerButton THEN
				MpAxisBasic_0.MoveVelocity :=FALSE;
			END_IF;
			IF NOT Mode THEN
				MpDelta4Axis_0.MoveDirect := FALSE;
				MpDelta4Axis_0.MoveLinear := FALSE;
				IF MpAxisBasic_0.IsHomed THEN
					MpAxisBasic_0.Home:= FALSE;
					ReadyMechanics := TRUE;
					KrokXYZ := PRGMECH;
				END_IF;
			END_IF
			IF ABS(MpDelta4Axis_0.Info.JointAxisPosition[0])<0.01 AND ABS(MpDelta4Axis_0.Info.JointAxisPosition[1])<0.01 AND ABS(MpDelta4Axis_0.Info.JointAxisPosition[2])<0.01 THEN
				HomePosition :=TRUE;
			ELSE
				HomePosition :=FALSE;
			END_IF
				
			IF TCP = TRUE AND HomeButton = FALSE THEN 
				DeltaParameters.CoordSystem := 1;
				DeltaParameters.Position[0] := setX;
				DeltaParameters.Position[1]:= setY;
				DeltaParameters.Position[2]:= setZ;
				DeltaParameters.Position[3]:= 0;
			
			ELSIF TCP = FALSE AND HomeButton =FALSE THEN
				DeltaParameters.CoordSystem := 0;
				DeltaParameters.Position[0] := setAxis1;
				DeltaParameters.Position[1]:= setAxis2;
				DeltaParameters.Position[2]:= setAxis3;
				DeltaParameters.Position[3]:= 0;

			ELSIF HomeButton THEN
				KrokXYZ :=HOMEFLAG;		
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
			IF ABS(MpDelta4Axis_0.Info.JointAxisPosition[0])<0.01 AND ABS(MpDelta4Axis_0.Info.JointAxisPosition[1])<0.01 AND ABS(MpDelta4Axis_0.Info.JointAxisPosition[2])<0.01 THEN
				HomePosition := TRUE;
			ELSE
				HomePosition := FALSE;
			END_IF
			IF DeltaParameters.CoordSystem = 0 AND ABS(MpDelta4Axis_0.Info.JointAxisPosition[0]-setAxis1)<0.01 AND ABS(MpDelta4Axis_0.Info.JointAxisPosition[1]-setAxis2)<0.01 AND ABS(MpDelta4Axis_0.Info.JointAxisPosition[2]-setAxis3)<0.01 THEN
				KrokXYZ:=CHECK;
			END_IF
		
			IF DeltaParameters.CoordSystem = 1 AND ABS(MpDelta4Axis_0.X-setX)<0.01 AND ABS(MpDelta4Axis_0.Y - setY)<0.01 AND ABS(MpDelta4Axis_0.Z-setZ)<0.01 THEN
				KrokXYZ:=CHECK;
			END_IF
		HOMEFLAG:
			DeltaParameters.CoordSystem := 0;
			DeltaParameters.Position[0] := 0;
			DeltaParameters.Position[1]:= 0;
			DeltaParameters.Position[2]:= 0;
			DeltaParameters.Position[3]:= 0;
			MpDelta4Axis_0.MoveDirect := TRUE;
			IF DeltaParameters.CoordSystem = 0 AND ABS(MpDelta4Axis_0.Info.JointAxisPosition[0])<0.01 AND ABS(MpDelta4Axis_0.Info.JointAxisPosition[1])<0.01 AND ABS(MpDelta4Axis_0.Info.JointAxisPosition[2])<0.01 THEN
				HomeButton:=FALSE;
				KrokXYZ:=CHECK;
			END_IF
		PRGMECH:
			
			MpAxisBasic_0.MoveVelocity := TRUE;
			IF CmdStart AND ReadyToStart THEN
				KrokXYZ:= AUTOMODE;
			END_IF
			IF Mode THEN
				MpAxisBasic_0.MoveVelocity :=FALSE;
				ReadyMechanics :=FALSE;
				KrokXYZ :=	PROG;
			END_IF
		AUTOMODE:
			IF Mode THEN
				MpAxisBasic_0.MoveVelocity :=FALSE;
				ReadyMechanics :=FALSE;
				KrokXYZ :=	PROG;
			END_IF
	END_CASE;

	ReadyToStart := ReadyMechanics AND ReadyPickReg AND ReadyPlaceReg AND ReadyPickCore;
	
	FB_AlarmCore();
	FB_AlarmHistory();

	
	IF MpDelta4Axis_0.Error THEN
		MpAlarmXSet(gAlarmXCore,'DeltaError');
	ELSE
		MpAlarmXReset(gAlarmXCore,'DeltaError');	  
	END_IF;
	
	IF MpAxisBasic_0.Error THEN	
		MpAlarmXSet(gAlarmXCore,'ConveyorAxisError');
	ELSE
		MpAlarmXReset(gAlarmXCore,'ConveyorAxisError');	  
	END_IF;
	
	IF FB_Axis1.Error THEN	
		MpAlarmXSet(gAlarmXCore,'DeltaAxis1Error');
	ELSE
		MpAlarmXReset(gAlarmXCore,'DeltaAxis1Error');	  
	END_IF;
	
	IF FB_Axis2.Error THEN	
		MpAlarmXSet(gAlarmXCore,'DeltaAxis2Error');
	ELSE
		MpAlarmXReset(gAlarmXCore,'DeltaAxis2Error');	  
	END_IF;
	
	IF FB_Axis3.Error THEN	
		MpAlarmXSet(gAlarmXCore,'DeltaAxis3Error');
	ELSE
		MpAlarmXReset(gAlarmXCore,'DeltaAxis3Error');	  
	END_IF;
	
	IF FB_Axis4.Error THEN	
		MpAlarmXSet(gAlarmXCore,'DeltaVirtualAxisError');
	ELSE
		MpAlarmXReset(gAlarmXCore,'DeltaVirtualAxisError');	  
	END_IF;
	

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
		
	MpAxisBasic_0.MpLink     := ADR(gAxis_1);
	MpAxisBasic_0.Parameters := ADR(AxisParameters_0);
	MpAxisBasic_0();
	
	MpAxisBasic_1.MpLink     := ADR(gAxis_2);
	MpAxisBasic_1.Parameters := ADR(AxisParameters_1);
	MpAxisBasic_1();
    
		
	MpDelta4Axis_0.Parameters := ADR(DeltaParameters); 
	MpDelta4Axis_0.MpLink := ADR(g4AxDeltaA);
	MpDelta4Axis_0();

	
	PickConveyorPosition  := MpAxisBasic_0.Position;
	PlaceConveyorPosition := MpAxisBasic_1.Position;
END_PROGRAM
	
//PROGRAM _EXIT
//	MpDelta4Axis_0.Enable := FALSE;
//	MpDelta4Axis_0.MpLink := 0;
//END_PROGRAM







