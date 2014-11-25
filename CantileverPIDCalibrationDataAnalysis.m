% This script analyzes the data retrieved from the PID calibration done
% on HAWK

% Get destination of files from user:
DestinationFolder = 'C:\Users\HAWK\Documents\CantileverCalibrationData';
[ files, directory ] = uigetfile('*.yaml', 'MultiSelect', 'on', 'Choose the folder where the data if located',DestinationFolder);

%% Get data from file
numFiles = length(files);

%path to Matlab YAML folder
addpath(genpath('YAMLMatlab_0.4.3'));

for fileCount = 1:numFiles
    % Get Tracking Data:
    %file to parse name (must be structured correctly)
    file = fullfile(directory, files{fileCount});
    %If necessary, remove the first line of the yaml file.
    fid = fopen(file);
    firstLine = fgetl(fid);
    if (firstLine(1:9) == '%YAML:1.0')
        buffer = fread(fid, Inf);
        fclose(fid);
        delete(file)
        fid = fopen(file, 'w')  ;   % Open destination file.
        fwrite(fid, buffer) ;                         % Save to file.
        fclose(fid) ;
    else
        fclose(fid);
    end
    
    RawData(fileCount) = ReadYaml(file);
    
end

%% Extract data
for fileCount = 1:numFiles;
    for point = 1:length(fieldnames(RawData(fileCount).CantileverSignal))
        Data(fileCount).PiezoSignal(point) = RawData(fileCount).CantileverSignal.(['Point' num2str(point-1)]);
        Data(fileCount).DriveSignal(point) = RawData(fileCount).ActuatorCommandSignal.(['Point' num2str(point-1)]);
    end
end

%% Analyze Data

%plot it:
timeInterval = 0.001;
for fileCount = 1:numFiles
    time = 0:length(Data(fileCount).PiezoSignal)-1;
    time = time.*timeInterval;
    subplot(numFiles,1,fileCount)
    plot(time,Data(fileCount).PiezoSignal, time, Data(fileCount).DriveSignal);
end