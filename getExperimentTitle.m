%%%% Function: Get Experiment Title
%  This function retrieves the name of the experiment based on the
%  contents of the directory selected by the user. 
%  params {directory} string, location where the data on the disk 
%  returns {experimentTitle} string, name of the experiment extracted from
%  directory name
%
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%


function experimentTitle = getExperimentTitle(directory, slash)
    if (ispc) %if on PC workstation in MERL 223
        slash = '\';
    elseif(ismac) % if on MAC workstation
        slash = '/';
    end

    % move backwards through directory string until you find the "slash".
    % The character in after the slash to the end of the string is the
    % experiment name.
    for index = length(directory):-1:1
        if (directory(index) == slash)
            startTitleIndex = index+1;
            break;
        end
    end
    experimentTitle = directory(startTitleIndex:length(directory));
end