clear all
if (ispc)
    DestinationFolder = 'C:\Users\HAWK\Documents\CantileverCalibrationData';
    addpath(genpath('C:\Users\HAWK\Documents\HAWKDataAnalysisCode\YAMLMatlab_0.4.3'));
elseif (ismac)
    DestinationFolder = '/Users/emazzochette/Documents/MicrosystemsResearch/HAWK/PIDControlAnalysisData';
    addpath(genpath('/Users/emazzochette/Documents/MicrosystemsResearch/HAWK/HAWKDataAnalysisCode/HAWKDataAnalysisCode'));
end
[ files, directory ] = uigetfile('*.yaml', 'MultiSelect', 'on', 'Choose the folder where the data is located',DestinationFolder);

%% Extra Data
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

%% Analyze
plottingPoints = {'r', 'b', 'g', 'm', 'k'};
DataMean = 0;
for fileCount = 1:numFiles;
    for point = 1:length(fieldnames(RawData(fileCount).CantileverSignal))
       Data(fileCount).PiezoSignal(point) = RawData(fileCount).CantileverSignal.(['Point' num2str(point-1)]);
       Data(fileCount).ActuatorPosition(point) = RawData(fileCount).ActuatorPositions.(['Point' num2str(point-1)]);
    end
    Data(fileCount).PositivePiezoPoints = find(Data(fileCount).PiezoSignal > 0);
    [Data(fileCount).fitData] = polyfit(Data(fileCount).ActuatorPosition(Data(fileCount).PositivePiezoPoints), Data(fileCount).PiezoSignal(  Data(fileCount).PositivePiezoPoints),1);
   DataMean = DataMean + 1/Data(fileCount).fitData(1); 
    plot(Data(fileCount).ActuatorPosition, Data(fileCount).PiezoSignal, plottingPoints{fileCount});
    stringForLegend{fileCount} = strcat('File  ', num2str(fileCount), ' Sensitivity =  ', num2str(1/Data(fileCount).fitData(1)), ' um/V');
    hold on
end
DataMean = DataMean/numFiles;
    legend(stringForLegend ,'Location','SouthEast');
    title(strcat('Cantilever Sensitivity Calibration, Average = ', num2str(DataMean),'um/V'));
    xlabel('Displacement (um)');
    ylabel('Cantilever Signal (V)');
