
PROGRAM _INIT

	P_Step := P_WAIT_ENABLE;
	Error := FALSE;
	restart := FALSE; 
	polka := 0;
	PlaceHoldersSpacing := 120; // distance between two consecutive place holders
	tablicaPlace[0] := 35;
	tablicaPlace[1] := 80;
	tablicaPlace[2] := 125;
	tablicaPlace[3] := 170;
	
	PlaceY := 30;
	
	abc := 0;
	iteracja := 0;
	tryb := 1;
	

END_PROGRAM

PROGRAM _CYCLIC
	
	CASE P_Step OF
		P_WAIT_ENABLE:
			P_Step := P_ENABLE_REGISTER_FB;
			
		P_ENABLE_REGISTER_FB:
			MpPickRegister_0.Enable := TRUE;
			P_Step := P_WAIT_ENABLE_REGISTER_FB;
			
		P_WAIT_ENABLE_REGISTER_FB:
			IF MpPickRegister_0.Active THEN
				P_Step := P_ENABLE_REGISTER_COMP;
            
			ELSIF MpPickRegister_0.Error THEN
				LastStep := P_Step;
				P_Step := P_ERROR;
			END_IF;
			
		P_ENABLE_REGISTER_COMP:
			MpPickRegister_0.RegisterEnable := TRUE;
			P_Step := P_WAIT_ENABLE_REGISTER_COMP;
			
		P_WAIT_ENABLE_REGISTER_COMP:
			IF MpPickRegister_0.RegisterActive THEN
				P_Step := P_ENABLE_ADD_REGISTER_FBS;
            
			ELSIF MpPickRegister_0.Error THEN
				LastStep := P_Step;
				P_Step := P_ERROR;
			END_IF;
			
		P_ENABLE_ADD_REGISTER_FBS:
			MpPickRegCreatePlaceholder.Enable := TRUE;
			MpPickRegCreatePlaceholder.Create := FALSE;
			P_Step := P_WAIT_ENABLE_ADD_REGISTER_FBS;
			
		P_WAIT_ENABLE_ADD_REGISTER_FBS:
			IF 	MpPickRegCreatePlaceholder.Active THEN
				P_Step := P_WAIT_START_PROCESS;
            
			ELSIF MpPickRegCreatePlaceholder.Error THEN
				LastStep := P_Step;
				P_Step := P_ERROR;
			END_IF;
			
		P_WAIT_START_PROCESS: // waits user start command and conveyor moving
			ReadyPlaceReg := TRUE;
			IF CmdStart AND ReadyToStart (*AND (PlaceConveyorPosition > 0)*) THEN
				P_Step := P_CREATE_OBJECTS;
			END_IF;
			
			(* We need to create positions (place holders) on place conveyor where to place picked objects *)
		P_CREATE_OBJECTS:
		
		//	IF tryb THEN
				
				        

				
			
				IF abc THEN

					
					CASE iteracja OF
						0:
							MpPickRegCreatePlaceholder.Parameters.LatchedConveyor.Position := PlaceConveyorPosition;
							MpPickRegCreatePlaceholder.Parameters.Mode := mpPICK_CREATE_SINGLEITEM_PLACEH;
							MpPickRegCreatePlaceholder.Parameters.ObjectTypeName := 'MyProduct';
							MpPickRegCreatePlaceholder.Parameters.Translation.X := tablicaPlace[0];
							MpPickRegCreatePlaceholder.Parameters.Translation.Y := PlaceY; // in the middle of conveyor width
							MpPickRegCreatePlaceholder.Create := TRUE;
							PHID := MpPickRegCreatePlaceholder.ObjectPositionId;
							iteracja := 1;
							abc := 0;
						
							
			
						1:
							MpPickRegCreatePlaceholder.Parameters.LatchedConveyor.Position := PlaceConveyorPosition;
							MpPickRegCreatePlaceholder.Parameters.Mode := mpPICK_CREATE_SINGLEITEM_PLACEH;
							MpPickRegCreatePlaceholder.Parameters.ObjectTypeName := 'MyProduct';
							MpPickRegCreatePlaceholder.Parameters.Translation.X := tablicaPlace[1];
							MpPickRegCreatePlaceholder.Parameters.Translation.Y := PlaceY; // in the middle of conveyor width
							MpPickRegCreatePlaceholder.Create := TRUE;
							iteracja := 2;
							abc := 0;
						2:
							MpPickRegCreatePlaceholder.Parameters.LatchedConveyor.Position := PlaceConveyorPosition;
							MpPickRegCreatePlaceholder.Parameters.Mode := mpPICK_CREATE_SINGLEITEM_PLACEH;
							MpPickRegCreatePlaceholder.Parameters.ObjectTypeName := 'MyProduct';
							MpPickRegCreatePlaceholder.Parameters.Translation.X := tablicaPlace[2];
							MpPickRegCreatePlaceholder.Parameters.Translation.Y := PlaceY; // in the middle of conveyor width
							MpPickRegCreatePlaceholder.Create := TRUE;
							iteracja := 3;
							abc := 0;
			
						3:
							MpPickRegCreatePlaceholder.Parameters.LatchedConveyor.Position := PlaceConveyorPosition;
							MpPickRegCreatePlaceholder.Parameters.Mode := mpPICK_CREATE_SINGLEITEM_PLACEH;
							MpPickRegCreatePlaceholder.Parameters.ObjectTypeName := 'MyProduct';
							MpPickRegCreatePlaceholder.Parameters.Translation.X := tablicaPlace[3];
							MpPickRegCreatePlaceholder.Parameters.Translation.Y := PlaceY; // in the middle of conveyor width
							MpPickRegCreatePlaceholder.Create := TRUE;
							iteracja := 4;
							abc := 0;
						4:
							abc :=0;
					END_CASE;
				ELSE
					MpPickRegCreatePlaceholder.Create := FALSE;

					abc :=1;
				END_IF
			
//			
//		//	ELSE
//
//			END_IF
			
			
			
//			MpPickRegGetObjectsContainer.Parameters.DataAddress := ADR(gContainerInfo);
//			MpPickRegGetObjectsContainer.Parameters.GetMode := mpPICK_GET_CONTAINER_CONTENT;
//			MpPickRegGetObjectsContainer.Parameters.ObjectPositionId := ContainerID;
//			MpPickRegGetObjectsContainer.Parameters.ObjectTypeName := 'MyContainer';			
//			MpPickRegGetObjectsContainer.Parameters.NumberOfObjectPositions := 4;
//			MpPickRegGetObjectsContainer.MpLink := ADR(gPlaceRegister);
//			MpPickRegGetObjectsContainer();
			
			
//			// Konfiguracja bloku GetObjects1
//			GetObjects1.Parameters.DataAddress :=ADR(g
//			GetObjects1.Parameters.GetMode := mpPICK_GET_ALL_SINGLEITEMS;
//			GetObjects1.Parameters.ObjectTypeName := WSTRING_TO_STRING("MyProduct");
//			GetObjects1.Parameters.ObjectPositionId := LREAL_TO_UDINT(MpPickRegCreatePlaceholder.Parameters.LatchedConveyor.Position);
//
//			// Aktywacja bloku
//			GetObjects1.Enable := TRUE;
//
//			// Czekanie na zakoñczenie operacji
//			IF GetObjects1.CommandDone THEN
//				ilosc1 := GetObjects1.ObjectPositionsFound; // Pobieranie liczby znalezionych obiektów
//				GetObjects1.Enable := FALSE;  // Zatrzymanie bloku po zakoñczeniu operacji
//			END_IF;
			
		P_ERROR:
			Error := TRUE;
			ReadyPlaceReg := FALSE;

	END_CASE;
    
	(* FB calls *)    
	MpPickRegister_0.MpLink := ADR(gPlaceRegister);
	MpPickRegister_0();
    
	MpPickRegCreatePlaceholder.MpLink := ADR(gPlaceRegister);
	MpPickRegCreatePlaceholder();
	
	GetObjects1.MpLink := ADR(gPlaceRegister);
	GetObjects1;


END_PROGRAM

