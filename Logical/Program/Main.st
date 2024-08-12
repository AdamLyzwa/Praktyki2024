PROGRAM _INIT
     

	MpDelta3Axis_0.Enable := TRUE; 
	MpDelta3Axis_0.Override := 100.0; 
	DeltaParameters.ProgramName := 'Robotic.st';    //File stored on FileDevice

END_PROGRAM

PROGRAM _CYCLIC
	
    MpDelta3Axis_0.Parameters := ADR(DeltaParameters); 
	MpDelta3Axis_0.MpLink := ADR(g3AxDeltaA);
	MpDelta3Axis_0();
	VisuPos[0] := LREAL_TO_REAL(MpDelta3Axis_0.Info.JointAxisPosition[0]);
	VisuPos[1] := LREAL_TO_REAL(MpDelta3Axis_0.Info.JointAxisPosition[1]);
	VisuPos[2] := LREAL_TO_REAL(MpDelta3Axis_0.Info.JointAxisPosition[2]);
	
	
	IF MpDelta3Axis_0.Error THEN
		DeltaStep := Delta_Error;
	END_IF;
	
	CASE DeltaStep OF	
		Delta_Idle://IDLE state - all comands reset
			MpDelta3Axis_0.Power := FALSE;
			MpDelta3Axis_0.Home := FALSE;
			MpDelta3Axis_0.MoveProgram := FALSE;
			
			IF diDeltaOn AND	MpDelta3Axis_0.Info.ReadyToPowerOn  THEN
				DeltaStep := Delta_Power;
			END_IF;
		Delta_Power://Power state - comand power is active - waiting for PowerON flag	
			 MpDelta3Axis_0.Power := TRUE;
			IF MpDelta3Axis_0.PowerOn THEN
				DeltaStep := Delta_Home;
			END_IF;
		Delta_Home://Homae state- comand gome is active - waiting for is Homed flag
			 MpDelta3Axis_0.Home:= TRUE;
			IF MpDelta3Axis_0.IsHomed THEN
				DeltaStep := Delta_Ready;
			END_IF;
		Delta_Ready://Ready state			
			MpDelta3Axis_0.Home := FALSE;
			MpDelta3Axis_0.MoveProgram := FALSE;
			
			IF   NOT diDeltaOn	THEN
				DeltaStep := Delta_Idle;	
			END_IF;
			
		Delta_Error://Error state - all caomends reset - waiting for Error flag to be reset
			MpDelta3Axis_0.Power := FALSE;
			MpDelta3Axis_0.Home := FALSE;
			MpDelta3Axis_0.MoveProgram := FALSE;
			
			IF NOT MpDelta3Axis_0.Error THEN
				DeltaStep := Delta_Idle;
			END_IF;
		  
	END_CASE;
     
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

