clear all
close all


DestinationFolder = '/Volumes/home/HAWK Data/Force Response Data';
addpath('/Users/emazzochette/Documents/MicrosystemsResearch/HAWK/HAWKDataAnalysisCode/HAWKDataAnalysisCode/20130227_xlwrite');
[NUM,TXT,RAW]=xlsread('/Users/emazzochette/Documents/MicrosystemsResearch/HAWK/Experiments/ManualBehaviorScoring.xls','Video Naming Key');


files = TXT(2:260,3);

for file = 1:length(files)
    name = char(files(file));
    if (length(name)>0)
        code(file) = {strcat( num2str(dec2hex(str2num(name(19:20)))),...
        num2str(dec2hex(str2num(name(13:14)))),... 
        num2str(dec2hex(str2num(name(9:10)))),... 
        num2str(dec2hex(str2num(name(16:17)))))};
        sourceVideoFileName = strcat(fullfile(DestinationFolder,char(files(file))),'/',char(files(file)),'_video.avi');
        destinationVideoFileName = strcat('/Users/emazzochette/Desktop/ManualBehaviorVideos/',code{file},'.avi');
        copyfile(sourceVideoFileName,destinationVideoFileName);
    end
end

