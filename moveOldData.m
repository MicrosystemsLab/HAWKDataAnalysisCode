function moveOldData(directory, numStims)
    %create directory
    mkdir(directory,'OldAnalysis');
    
    experimentTitle = getExperimentTitle(directory);
    
    %Copy stimulus file
    source =  fullfile(directory,strcat(experimentTitle,'_DataByStimulus.mat'));
    destination =  fullfile(directory,'OldAnalysis',strcat(experimentTitle,'_DataByStimulus.mat'));
    try copyfile(source,destination); end
  
    %Move image files
    for stim = 1:numStims 
        filename = strcat(experimentTitle,'_Stimulus_',num2str(stim),'.png');
        source =  fullfile(directory,filename);
        destination = fullfile(directory,'OldAnalysis',filename);
        try movefile(source,destination); end
    end
end