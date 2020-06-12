function saveSimData2T(LTDatVarName, MTDatVarName, FileName)
% Use this function to Modify Simulation Save Parameters

%% Lead Truck Block
evalin('base',[LTDatVarName,'= LT_SimData;'])

%% Middle Truck Block
evalin('base',[MTDatVarName,'= MT_SimData;'])

%% Tail Truck Block
% evalin('base',[TTDatVarName,'= TT_SimData;'])

%% Save as a common file
PathName = 'C:\Users\Aman-Home\Documents\MATLAB\DocResWork\Simulation_Models\Platooning_EM\Results_MostRecent\';
FileName = strcat(PathName,FileName,'.mat');
% evalin('base',['save(',FileName,LTDatVarName,MTDatVarName,TTDatVarName,');'])
evalin('base',['save ',FileName,' ',LTDatVarName,' ',MTDatVarName,''])
disp('## Variables were saved in the Results folder ##')

end

