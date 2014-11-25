%% FPGA Data Analysis Script
% This script brings in the data from the yaml file generated by HAWK and
% analysizes the FPGA data.

% Written by: Eileen Mazzochette
% Created: October 9, 2014
% Modified: 

%%%%%
%% Import Data:
FilterSpec = {'*.yaml;*.yml','All yaml Files';'*.*','All Files'};
DestinationFolder = 'C:\Users\HAWK\Documents\HAWKData';
[yamlDataFileName, yamlDataPathName] = uigetfile(FilterSpec, 'Select yaml data file', DestinationFolder);

%% Convert to .mat file

%path to Matlab YAML folder
addpath(genpath('YAMLMatlab_0.4.3'));

%file to parse name (must be structured correctly)
yaml_file = fullfile(yamlDataPathName, yamlDataFileName);

%If necessary, remove the first line of the yaml file.
fid = fopen(yaml_file);
firstLine = fgetl(fid);

if (firstLine(1:9) == '%YAML:1.0')
    buffer = fread(fid, Inf);
    fclose(fid);
    delete(yaml_file)
    fid = fopen(yaml_file, 'w')  ;   % Open destination file.
    fwrite(fid, buffer) ;                         % Save to file.
    fclose(fid) ;
else
    fclose(fid);
end


%parse
FPGAData = ReadYaml(yaml_file);

%write file to .mat
mat_file = fullfile(yamlDataPathName,strcat(yamlDataFileName(1:length(yamlDataFileName)-5),'_parsedData.mat'));
save(mat_file, 'FPGAData');

%% Extract Data:
numDataFields = 4;
numStim =  length(fieldnames(FPGAData));
acquisitionInterval = 0.001;
for stim = 1:numStim
   for i = 0:size(fieldnames(FPGAData.(['Stimulus',num2str(stim)]).PiezoSignalMagnitudes))-1
       Stimulus(stim).PiezoSignal(i+1) = FPGAData.(['Stimulus',num2str(stim)]).PiezoSignalMagnitudes.(['Point', num2str(i)]);
       Stimulus(stim).ActuatorPosition(i+1) = FPGAData.(['Stimulus',num2str(stim)]).ActuatorPositionMagnitudes.(['Point', num2str(i)]);
       Stimulus(stim).ActuatorCommand(i+1) = FPGAData.(['Stimulus',num2str(stim)]).ActuatorCommandMagnitudes.(['Point', num2str(i)]);
       Stimulus(stim).DesiredSignal(i+1) = FPGAData.(['Stimulus',num2str(stim)]).DesiredSignalMagnitudes.(['Point', num2str(i)]);
       
    end
end



%% Plot:

numDataFields = 4;
numStim =  length(fieldnames(FPGAData));
acquisitionInterval = 0.001;
for stim = 1:numStim
    figure(stim);
    time = 0:(size(fieldnames(FPGAData.(['Stimulus',num2str(stim)]).PiezoSignalMagnitudes))-1);
    time = time*acquisitionInterval;
    subplot(numDataFields,1,1), plot(time,Stimulus(stim).PiezoSignal);
    title('Piezo resistor signal');
    xlabel('Time (s)');
    subplot(numDataFields,1,2), plot(time,Stimulus(stim).ActuatorPosition);
    title('Actuator Position Signal');
    xlabel('Time (s)');
    subplot(numDataFields,1,3), plot(time,Stimulus(stim).ActuatorCommand);
    title('Actuator Command Signal');
    xlabel('Time (s)');
    subplot(numDataFields,1,4), plot(time,Stimulus(stim).DesiredSignal);
    title('Desired Stimulus');
    xlabel('Time (s)');
end