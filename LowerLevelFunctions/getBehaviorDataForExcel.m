%%%% Function: get behavior data for excel
%  Constructs the matrix necessary for exporting the behavior data to an
%  excel spreadsheet.
%
%  param {TrackingData} struct, contains information about the experiment
%  param {StimulusData} struct, contains the user input information about
%  the desired stimulus.
%  param {Stimulus} struct, contains experiment data organized by stimulus
%  param {numStims} int, the number of stimulus in this experiment.
%  param {experimentTitle}, the title of the experiment as input by the
%  user
%
%  returns {experimentData} struct, contains all the information global to
%  all stimulus in the experiment. 
%  returns {stimulusData} struct, contains stimulus specific information
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%

function [experimentData, stimulusData] = getBehaviorDataForExcel(TrackingData, StimulusData, Stimulus,numStims, experimentTitle)
%    titles = DataSet3ColumnHeaders();
%    titles = IndentationOnlyTitles();
%    titles = TargetingOnlyTitles();
titles = getBehaviorTitles();

    %ExperimentParameters:
    try Row(1, strmatch('Date',titles,'exact')) = {TrackingData.ExperimentTime(1:10)}; end
    try Row(1, strmatch('Experiment Name',titles,'exact')) = {experimentTitle}; end
    try Row(1, strmatch('Experiment Title',titles,'exact')) = {TrackingData.ExperimentTitle}; end		
    try Row(1, strmatch('Time Stamp',titles,'exact')) =	{TrackingData.ExperimentTime}; end
    try Row(1, strmatch('Slide No.',titles,'exact')) = {num2str(TrackingData.SlideNumber)}; end
    try Row(1, strmatch('Experiment No.',titles,'exact')) =	{num2str(TrackingData.ExperimentOnThisSlideNumber)}; end
    try Row(1, strmatch('Strain',titles,'exact')) =	{TrackingData.WormProperties.WormStrain}; end
    try Row(1, strmatch('Treatments',titles,'exact')) =	{TrackingData.WormProperties.WormTreatments}; end
    try Row(1, strmatch('Gender',titles,'exact')) =	{TrackingData.WormProperties.WormGender}; end
    try Row(1, strmatch('Age',titles,'exact')) = {TrackingData.WormProperties.WormAge}; end
    try Row(1, strmatch('Percent Agar',titles,'exact')) = {TrackingData.WormProperties.PercentAgar}; end
    try Row(1, strmatch('Food Status',titles,'exact')) = {TrackingData.WormProperties.FoodStatus}; end	
    try Row(1, strmatch('Temp',titles,'exact')) =  {TrackingData.AmbientParameters.Temperature}; end
    try Row(1, strmatch('Humidity',titles,'exact')) = {TrackingData.AmbientParameters.Humidity}; end
    try Row(1, strmatch('Experiment Mode',titles,'exact')) = {TrackingData.ExperimentMode}; end
    try Row(1, strmatch('Experiment Comments',titles,'exact')) = {TrackingData.OtherExperimentInfo}; end
    try Row(1, strmatch('Post Experiment Comments',titles,'exact')) = {TrackingData.PostExperimentNotes}; end	
    try Row(1, strmatch('Pre Stim Recording Time (s)',titles,'exact')) = {TrackingData.Pre0x2DStimulusRecordTime}; end	
    try Row(1, strmatch('Post Stim Recording Time (s)',titles,'exact')) = {TrackingData.Post0x2DStimulusRecordTime}; end
    
    experimentData = Row;
    clear Row;
    
    
    
    firstColumn = strmatch('Stimulus Number',titles,'exact');
    for stim = 1:numStims
      
        try Row(stim, strmatch('Stimulus Number',titles,'exact')-firstColumn+1) =	stim; end
        try Row(stim, strmatch('Stimulus First Frame Time',titles,'exact')-firstColumn+1) = Stimulus(stim).firstFrameTime; end	
        try Row(stim, strmatch('Stimulus Start Time',titles,'exact')-firstColumn+1) =	Stimulus(stim).StimulusTiming.stimAppliedTime; end
        try Row(stim, strmatch('Stimulus End Time',titles,'exact')-firstColumn+1) = Stimulus(stim).StimulusTiming.stimEndTime; end
        %Body Morphology
        try Row(stim, strmatch('Average Body length (um)',titles,'exact')-firstColumn+1) = Stimulus(stim).BodyMorphology.averageBodyLength; end
        try Row(stim, strmatch('STD Body Length (um)',titles,'exact')-firstColumn+1) = Stimulus(stim).BodyMorphology.stdBodyLength; end
        try Row(stim, strmatch('Average Body Width (um)',titles,'exact')-firstColumn+1) =	Stimulus(stim).BodyMorphology.averageBodyWidth; end
        try Row(stim, strmatch('STD Body Width (um)',titles,'exact')-firstColumn+1) =	Stimulus(stim).BodyMorphology.stdBodyWidth; end
        try Row(stim, strmatch('Filtered Average Body length (um)',titles,'exact')-firstColumn+1) = Stimulus(stim).BodyMorphology.averageBodyLengthGoodFrames; end
        try Row(stim, strmatch('Filtered STD Body Length (um)',titles,'exact')-firstColumn+1) = Stimulus(stim).BodyMorphology.stdBodyLengthGoodFrames; end
        try Row(stim, strmatch('Filtered Average Body Width (um)',titles,'exact')-firstColumn+1) = Stimulus(stim).BodyMorphology.averageBodyWidthGoodFrames; end
        try Row(stim, strmatch('Filtered STD Body Width (um)',titles,'exact')-firstColumn+1) = Stimulus(stim).BodyMorphology.stdBodyWidthGoodFrames; end
        %try Row(stim, strmatch('Target Location (%)',titles,'exact')-firstColumn+1) =	TrackingData.TargetLocation; end
        %Targeting
        try Row(stim, strmatch('Distance from Target (um)',titles,'exact')-firstColumn+1) = Stimulus(stim).SpatialResolution.distanceFromTargetMean; end
        try Row(stim, strmatch('Percent Down Body Hit (%)',titles,'exact')-firstColumn+1) = Stimulus(stim).SpatialResolution.percentDownBodyHitMean; end
        try Row(stim, strmatch('Distance from Skeleton (um)',titles,'exact')-firstColumn+1) =	Stimulus(stim).SpatialResolution.distanceFromSkeletonMean; end
        try Row(stim, strmatch('Percent Across Body Hit (%)',titles,'exact')-firstColumn+1) =	Stimulus(stim).SpatialResolution.percentAcrossBodyHitMean; end
        
        try Row(stim, strmatch('Number of Bad Frames',titles,'exact')-firstColumn+1) = length(Stimulus(stim).FrameScoring.BadFrames); end
        
        try Row(stim, strmatch('Average Track Velocity', titles,'exact') -firstColumn+1) = Stimulus(stim).CurvatureAnalysis.velocityAverage; end
        try Row(stim, strmatch('STD Track Velocity', titles,'exact') -firstColumn+1) = Stimulus(stim).CurvatureAnalysis.velocitySTD; end
        try Row(stim, strmatch('Average Track Acceleration', titles,'exact') -firstColumn+1) = Stimulus(stim).CurvatureAnalysis.accelerationAverage; end
        try Row(stim, strmatch('STD Track Acceleration', titles,'exact') -firstColumn+1) = Stimulus(stim).CurvatureAnalysis.accelerationSTD; end
        try Row(stim, strmatch('Average Mean Position Velocity', titles,'exact') -firstColumn+1) = nanmean(Stimulus(stim).Trajectory.speed(Stimulus(stim).FramesByStimulus.DuringStimFrames)); end
        
        try Row(stim, strmatch('Average Amplitude (um)',titles,'exact')-firstColumn+1)	= nanmean(Stimulus(stim).Trajectory.amplitude(Stimulus(stim).FramesByStimulus.DuringStimFrames)); end
        try Row(stim, strmatch('Average Wavelength (um/cycle)',titles,'exact')-firstColumn+1)	= nanmean(Stimulus(stim).Trajectory.wavelength(Stimulus(stim).FramesByStimulus.DuringStimFrames)); end
    
    end
    stimulusData = Row;
end