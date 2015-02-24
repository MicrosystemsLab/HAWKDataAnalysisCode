%%%% Function: Get Tracking Data From YAML
%  This function extracts the data from the tracking.yaml file that has
%  data collected by HAWK during the experiment. It converts the data to a
%  .mat file readble by Matlab.
%
%  params {directory} string, location where the data on the disk 
%  params {experimentTitle} string, name of the experiment
%  returns {Stimulus} struct, a structure of data represting the experiment
%  data and the tracking data by frame.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%


function TrackingData = getTrackingDataFromYAML(directory,experimentTitle)
    trackingDataFilename = strcat(experimentTitle, '_tracking.yaml');

    % Get Tracking Data:
    mat_file = fullfile(directory,strcat(experimentTitle,'_tracking_parsedData.mat'));
    %if the data has already been read from the .yaml file, just load the mat
    %file created last time:
    if (exist(mat_file, 'file')==2)
        load(mat_file);
    else %otherwise, parse through .yaml file:
        %file to parse name (must be structured correctly)
        tracking_file = fullfile(directory, trackingDataFilename);
        %If necessary, remove the first line of the yaml file.
        fid = fopen(tracking_file);
        firstLine = fgetl(fid);
        if (firstLine(1:9) == '%YAML:1.0')
            buffer = fread(fid, Inf);
            fclose(fid);
            delete(tracking_file)
            fid = fopen(tracking_file, 'w')  ;   % Open destination file.
            fwrite(fid, buffer) ;                         % Save to file.
            fclose(fid) ;
        else
            fclose(fid);
        end
        %parse
        TrackingData = ReadYaml(tracking_file);
        %write file to .mat
        mat_file = fullfile(directory,strcat(experimentTitle,'_tracking_parsedData.mat'));
        save(mat_file, 'TrackingData');
    end

end