function simBatchPlatoon(MdlName, batchConfigMat, simType, suffix)
%SIMBATCHPLATOON Summary of this function goes here
%   Detailed explanation goes here
%% Confirm if batchConfigMat is correct for the simType
[~,c] = size(batchConfigMat);
if simType ~= c
    error('Incompatible dimensions between inputs!')
else
    if simType == 3
        run('startHetPlatoonModel.m')
        evalin('base',['LT.Type = ',num2str(batchConfigMat(1)),';'])
        evalin('base',['MT.Type = ',num2str(batchConfigMat(2)),';'])
        evalin('base',['TT.Type = ',num2str(batchConfigMat(3)),';'])
        set_param(MdlName, 'SimulationCommand', 'update')
        tic
        outsim = sim(MdlName,'ReturnWorkspaceOutputs','on');
        toc
        close_system
    %     msgDisp = strcat('## Simulation: ',num2str(i),'/',num2str(r),', Completed! ##');
        msgDisp = strcat('## Simulation Completed! ##');
        disp(msgDisp)
        % -- Variable Name Selection --
        codename = '';
        switch batchConfigMat(1)
            case 1
                str1 = strcat('LT_CT_T3_',suffix);
                codename = strcat(codename,'C');
            case 2
                str1 = strcat('LT_ST_T3_',suffix);
                codename = strcat(codename,'S');
            case 3
                str1 = strcat('LT_BT_T3_',suffix);
                codename = strcat(codename,'B');
        end

        switch batchConfigMat(2)
            case 1
                str2 = strcat('MT_CT_T3_',suffix);
                codename = strcat(codename,'C');
            case 2
                str2 = strcat('MT_ST_T3_',suffix);
                codename = strcat(codename,'S');
            case 3
                str2 = strcat('MT_BT_T3_',suffix);
                codename = strcat(codename,'B');
        end

        switch batchConfigMat(3)
            case 1
                str3 = strcat('TT_CT_T3_',suffix);
                codename = strcat(codename,'C');
            case 2
                str3 = strcat('TT_ST_T3_',suffix);
                codename = strcat(codename,'S');
            case 3
                str3 = strcat('TT_BT_T3_',suffix);  
                codename = strcat(codename,'B');
        end

        % -- File Name Selection --
        fname = strcat(suffix,'_',codename,'_T3');
        %% Save Data
        % Use this function to Modify Simulation Save Parameters

        %% Lead Truck Block
        eval([str1,'= outsim.LT_SimData;'])

        %% Middle Truck Block
        eval([str2,'= outsim.MT_SimData;'])

        %% Tail Truck Block
        eval([str3,'= outsim.TT_SimData;'])

        %% Save as a common file
        PathName = 'C:\Users\Aman-Home\Documents\MATLAB\DocResWork\Simulation_Models\Platooning_EM\Results_MostRecent\';
        FileName = strcat(PathName,fname,'.mat');
        % evalin('base',['save(',FileName,LTDatVarName,MTDatVarName,TTDatVarName,');'])
        eval(['save ',FileName,' ',str1,' ',str2,' ',str3,''])
        disp('## Variables were saved in the Results folder ##')
    elseif simType == 2
        run('startHetPlatoonModel.m')
        evalin('base',['LT.Type = ',num2str(batchConfigMat(1)),';'])
        evalin('base',['MT.Type = ',num2str(batchConfigMat(2)),';'])
        evalin('base',['TT.Type = ',num2str(batchConfigMat(2)),';'])
        set_param(MdlName, 'SimulationCommand', 'update')
        tic
        outsim = sim(MdlName,'ReturnWorkspaceOutputs','on');
        toc
        close_system
    %     msgDisp = strcat('## Simulation: ',num2str(i),'/',num2str(r),', Completed! ##');
        msgDisp = strcat('## Simulation Completed! ##');
        disp(msgDisp)
        % -- Variable Name Selection --
        codename = '';
        switch batchConfigMat(1)
            case 1
                str1 = strcat('LT_CT_T2_',suffix);
                codename = strcat(codename,'C');
            case 2
                str1 = strcat('LT_ST_T2_',suffix);
                codename = strcat(codename,'S');
            case 3
                str1 = strcat('LT_BT_T2_',suffix);
                codename = strcat(codename,'B');
        end

        switch batchConfigMat(2)
            case 1
                str2 = strcat('TT_CT_T2_',suffix);
                codename = strcat(codename,'C');
            case 2
                str2 = strcat('TT_ST_T2_',suffix);
                codename = strcat(codename,'S');
            case 3
                str2 = strcat('TT_BT_T2_',suffix);
                codename = strcat(codename,'B');
        end
        % -- File Name Selection --
        fname = strcat(suffix,'_',codename,'_T2');
        %% Save Data
        % Use this function to Modify Simulation Save Parameters

        %% Lead Truck Block
        eval([str1,'= outsim.LT_SimData;'])

        %% Tail Truck Block
        eval([str2,'= outsim.MT_SimData;'])

        %% Save as a common file
        PathName = 'C:\Users\Aman-Home\Documents\MATLAB\DocResWork\Simulation_Models\Platooning_EM\Results_MostRecent\';
        FileName = strcat(PathName,fname,'.mat');
        % evalin('base',['save(',FileName,LTDatVarName,MTDatVarName,TTDatVarName,');'])
        eval(['save ',FileName,' ',str1,' ',str2,''])
        disp('## Variables were saved in the Results folder ##')
    end
end

