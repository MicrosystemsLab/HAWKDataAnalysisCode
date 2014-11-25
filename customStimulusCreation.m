%% Import Data:
FilterSpec = {'*.yaml;*.yml','All yaml Files';'*.*','All Files'};
DestinationFolder = '/Users/emazzochette/Desktop';
[yamlDataFileName, yamlDataPathName] = uigetfile(FilterSpec, 'Select yaml data file', DestinationFolder);

%% Convert to .mat file

%path to Matlab YAML folder
addpath(genpath('YAMLMatlab_0'));

%file to parse name (must be structured correctly)
yaml_file = fullfile(yamlDataPathName, yamlDataFileName);

%parse
ExperimentData = ReadYaml(yaml_file);

%% Create Stimulus:

Stimulus.Time = linspace(0,1, 5000);
Stimulus.Magnitudes = zeros(1,5000);
Stimulus.Magnitudes(1000:2000) = 4;
Stimulus.Magnitudes(3000:4000) = 4;


%% Write YAML
WriteYaml(fullfile(yamlDataPathName, 'test.yaml'), Stimulus)

