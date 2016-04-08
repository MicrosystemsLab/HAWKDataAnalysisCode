%%%% Function: moveOldData
%  If re-analyzing data and you want to save the previous analysis, this
%  function creates a new folder and moves the old analysis to it.
%  
%  params {directory} string, current location of the experiment data.
%  params {numStims} int, the number of stimulus in this experiment.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%

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