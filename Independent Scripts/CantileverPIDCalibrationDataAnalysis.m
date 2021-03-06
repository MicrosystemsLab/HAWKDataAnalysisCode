% This script analyzes the data retrieved from the PID calibration done
% on HAWK

% Get destination of files from user:
% Also add path to Matlab YAML folder

clear all
if (ispc)
    DestinationFolder = 'C:\Users\HAWK\Documents\CantileverCalibrationData';
    addpath(genpath('C:\Users\HAWK\Documents\HAWKDataAnalysisCode\YAMLMatlab_0.4.3'));
elseif (ismac)
    DestinationFolder = '/Users/emazzochette/Documents/MicrosystemsResearch/HAWK/PIDControlAnalysisData';
    addpath(genpath('/Users/emazzochette/Documents/MicrosystemsResearch/HAWK/HAWKDataAnalysisCode/HAWKDataAnalysisCode'));
end
[ files, directory ] = uigetfile('*.yaml', 'MultiSelect', 'on', 'Choose the folder where the data is located',DestinationFolder);

%% Get data from file
if iscell(files) == 0
    numFiles = 1;
else
    numFiles = length(files);
end



for fileCount = 1:numFiles
    % Get Tracking Data:
    %file to parse name (must be structured correctly)
    if numFiles == 1
        file = fullfile(directory, files);
    else 
        file = fullfile(directory, files{fileCount});
    end
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
        Data(fileCount).DriveSignal(point) = RawData(fileCount).ActuatorPositions.(['Point' num2str(point-1)]);
    end
end

%% Analyze Data

%plot it:
timeInterval = 0.001;
for fileCount = 1:numFiles
    time = 0:length(Data(fileCount).PiezoSignal)-1;
    time = time.*timeInterval;
    figureTitle = RawData(fileCount).Cantilever;
    createFigureForPIDCalibrationAnalysis([time;time]', [Data(fileCount).PiezoSignal;Data(fileCount).DriveSignal]', figureTitle)
%     subplot(numFiles,1,fileCount)
%     plot(time,Data(fileCount).PiezoSignal,'r');
%     hold on
%     plot(time, Data(fileCount).DriveSignal,'b');
%     title(RawData(fileCount).Cantilever); 
%     axis([2.6 4 -3 4]);
%     data = iddata(Data(fileCount).PiezoSignal(1:5000)',Data(fileCount).DriveSignal(1:5000)', timeInterval);
%     sys = tfest(data,2,0);
%     numerators(fileCount,:) = sys.num;
%     denominators(fileCount,:) = sys.den;
%     [z, p, k] = tf2zp(sys.num,sys.den);
    
    
end
% 
% frequencies = sqrt(denominators(:,3))./(2*pi);
% damping = (denominators(:,2))./(2.*frequencies);

