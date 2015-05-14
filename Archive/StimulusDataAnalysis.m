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
addpath(genpath('YAMLMatlab_0'));

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
StimulusData = ReadYaml(yaml_file);

%write file to .mat
mat_file = fullfile(yamlDataPathName,strcat(yamlDataFileName(1:length(yamlDataFileName)-5),'_parsedData.mat'));
save(mat_file, 'StimulusData');

%% Plot:

numDataFields = 4;
numStim =  length(fieldnames(StimulusData));