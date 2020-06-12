batchVecT3 = [1,1,1;
            1,1,2;
            1,1,3;
            1,2,2;
            1,2,1;
            1,2,3;
            1,3,3;
            1,3,1;
            1,3,2;
            2,1,1;
            2,1,2;
            2,1,3;
            2,2,2;
            2,2,1;
            2,2,3;
            2,3,3;
            2,3,1;
            2,3,2;
            3,1,1;
            3,1,2;
            3,1,3;
            3,2,2;
            3,2,1;
            3,2,3;
            3,3,3;
            3,3,1;
            3,3,2];
batchVecT2 = [1,1;
              1,2;
              1,3;
              2,1;
              2,2;
              2,3;
              3,1;
              3,2;
              3,3];
batchVecT2_Het = [1,2;
                  1,3;
                  2,1;
                  2,3;
                  3,1;
                  3,2];
batchVecT3_Het = [1,2,3;
                  1,3,2;
                  2,1,3;
                  2,3,1;
                  3,1,2;
                  3,2,1];
     
[r,~] = size(batchVecT3_Het);

for idx = 1:r
    simBatchPlatoon('het_platoon_model',batchVecT3_Het(idx,:),3,'PHRoute_40');
    msgd = strcat('Simulation: ',num2str(idx),' of ',num2str(r),' completed!');
    disp(msgd)
end