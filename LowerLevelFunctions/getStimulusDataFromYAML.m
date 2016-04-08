%%%% Function: Get Stimulus Data From YAML
%  This function extracts the data from the Stimulus.yaml file that has
%  information about the desired stimulus applied to the worm. This data
%  was sent the FPGA in force clamp mode, or indicated the length of the
%  tracking window for behavior mode. It converts the data to a
%  .mat file readble by Matlab.
%
%  params {directory} string, location where the data on the disk 
%  params {experimentTitle} string, name of the experiment
%  returns {Stimulus} struct, a structure of data represting the stimulus
%  data.
%
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%


function StimulusData = getStimulusDataFromYAML(directory,experimentTitle)
    stimulusDataFilename = strcat(experimentTitle, '_stimulus.yaml');
    % Get Stimulus Data:
    mat_file = fullfile(directory,strcat(experimentTitle,'_stimulus_parsedData.mat'));
    %if the data has already been read from the .yaml file, just load the mat
    %file created last time:
    if (exist(mat_file, 'file')==2)
        load(mat_file);
    else %otherwise, parse through .yaml file:
        %file to parse name (must be structured correctly)
        stimulus_file = fullfile(directory, stimulusDataFilename);
        %If necessary, remove the first line of the yaml file.
        fid = fopen(stimulus_file);
        firstLine = fgetl(fid);
        if (firstLine(1:9) == '%YAML:1.0')
            buffer = fread(fid, Inf);
            fclose(fid);
            delete(stimulus_file)
            fid = fopen(stimulus_file, 'w')  ;   % Open destination file.
            fwrite(fid, buffer) ;                         % Save to file.
            fclose(fid) ;
        else
            fclose(fid);
        end
        %parse yaml file:
        StimulusData = ReadYaml(stimulus_file);
        %write file to .mat file
        save(mat_file, 'StimulusData');
    end
end