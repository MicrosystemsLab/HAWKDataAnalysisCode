clear all; close all; clc;

%path to Matlab YAML folder
addpath(genpath('YAMLMatlab_0'));

%file to parse name (must be structured correctly)
yaml_file = 'FILE_NAME.yaml';

%parse
YamlStruct = ReadYaml(yaml_file);

%write file to .mat
mat_file = 'FILE_NAME.mat';
save(mat_file, 'YamlStruct');

%load(mat_file) reloads the struct