

function [experimentData, stimulusData] = getDataForExcel(TrackingData, StimulusData, Stimulus,numStims, experimentTitle)
   titles = DataSet3ColumnHeaders();
%    titles = IndentationOnlyTitles();
%    titles = TargetingOnlyTitles();

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
    try Row(1, strmatch('Cantilever ID',titles,'exact')) = {TrackingData.CantileverProperties.SerialNumber}; end	
    try Row(1, strmatch('Frequency (kHz)',titles,'exact')) = {TrackingData.CantileverProperties.ResonantFrequency}; end		
    try Row(1, strmatch('Stiffness (N/m)',titles,'exact')) = {TrackingData.CantileverProperties.Stiffness}; end		
    try Row(1, strmatch('Sensitivity (um/V)',titles,'exact')) =	{TrackingData.CantileverProperties.Sensitivity}; end	
    try Row(1, strmatch('P Parameter',titles,'exact')) = {TrackingData.CantileverProperties.PParameter}; end	
    try Row(1, strmatch('I Parameter',titles,'exact')) = {TrackingData.CantileverProperties.IParameter}; end		
    try Row(1, strmatch('D Parameter',titles,'exact')) = {TrackingData.CantileverProperties.DParameter}; end		
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
        try Row(stim, strmatch('Stimulus Approach On Time',titles,'exact')-firstColumn+1) = Stimulus(stim).StimulusTiming.approachStartTime; end
        try Row(stim, strmatch('Stimulus Start Time',titles,'exact')-firstColumn+1) =	Stimulus(stim).StimulusTiming.stimOnStartTime; end
        try Row(stim, strmatch('Stimulus End Time',titles,'exact')-firstColumn+1) = Stimulus(stim).StimulusTiming.stimEndTime; end
        
        %Body Morphology:
        try Row(stim, strmatch('Average Body length (um)',titles,'exact')-firstColumn+1) = Stimulus(stim).BodyMorphology.averageBodyLength; end
        try Row(stim, strmatch('STD Body Length (um)',titles,'exact')-firstColumn+1) = Stimulus(stim).BodyMorphology.stdBodyLength; end
        try Row(stim, strmatch('Average Body Width (um)',titles,'exact')-firstColumn+1) =	Stimulus(stim).BodyMorphology.averageBodyWidth; end
        try Row(stim, strmatch('STD Body Width (um)',titles,'exact')-firstColumn+1) =	Stimulus(stim).BodyMorphology.stdBodyWidth; end
        try Row(stim, strmatch('Filtered Average Body length (um)',titles,'exact')-firstColumn+1) = Stimulus(stim).BodyMorphology.averageBodyLengthGoodFrames; end
        try Row(stim, strmatch('Filtered STD Body Length (um)',titles,'exact')-firstColumn+1) = Stimulus(stim).BodyMorphology.stdBodyLengthGoodFrames; end
        try Row(stim, strmatch('Filtered Average Body Width (um)',titles,'exact')-firstColumn+1) = Stimulus(stim).BodyMorphology.averageBodyWidthGoodFrames; end
        try Row(stim, strmatch('Filtered STD Body Width (um)',titles,'exact')-firstColumn+1) = Stimulus(stim).BodyMorphology.stdBodyWidthGoodFrames; end
        
        %Targeting info:
        try Row(stim, strmatch('Target Location (%)',titles,'exact')-firstColumn+1) =	TrackingData.TargetLocation; end
        try Row(stim, strmatch('Distance from Target (um)',titles,'exact')-firstColumn+1) = Stimulus(stim).SpatialResolution.distanceFromTarget; end
        try Row(stim, strmatch('Percent Down Body Hit (%)',titles,'exact')-firstColumn+1) = Stimulus(stim).SpatialResolution.percentDownBodyHit; end
        try Row(stim, strmatch('Distance from Skeleton (um)',titles,'exact')-firstColumn+1) =	Stimulus(stim).SpatialResolution.distanceFromSkeleton; end
        try Row(stim, strmatch('Percent Across Body Hit (%)',titles,'exact')-firstColumn+1) =	Stimulus(stim).SpatialResolution.percentAcrossBodyHit; end
        
        %Stimulus Statistics:
        try Row(stim, strmatch('Stimulus Magnitude (nN)',titles,'exact')-firstColumn+1) = StimulusData.Magnitude; end
        try Row(stim, strmatch('Stimulus Duration (t)',titles,'exact')-firstColumn+1) = StimulusData.ContactTime; end
        try Row(stim, strmatch('Stimulus Zero Pulse Length (t)', titles,'exact')-firstColumn+1) = StimulusData.ZeroPulseDuration; end
        try Row(stim, strmatch('Soft Balance Value (V)',titles,'exact')-firstColumn+1) = Stimulus(stim).StimulusTiming.stimulusAnalysis.preApproachPoints.average; end
        try Row(stim, strmatch('Approach Duration (s)',titles,'exact')-firstColumn+1) = Stimulus(stim).StimulusTiming.stimulusAnalysis.approachPoints.duration;	end
        try Row(stim, strmatch('Stimulus FPGA Start Time (s)',titles,'exact')-firstColumn+1) = 0.001 * Stimulus(stim).StimulusTiming.stimOnFPGAIndex; end
        try Row(stim, strmatch('Stimulus RMS Error',titles,'exact')-firstColumn+1) =	Stimulus(stim).StimulusTiming.stimulusAnalysis.stimulusPoints.rmsError; end
        try Row(stim, strmatch('Stimulus Rise Time (s)',titles,'exact')-firstColumn+1) =	Stimulus(stim).StimulusTiming.stimulusAnalysis.stimulusPoints.response.RiseTime; end
        try Row(stim, strmatch('Stimulus Settling Time (s)',titles,'exact')-firstColumn+1) =	Stimulus(stim).StimulusTiming.stimulusAnalysis.stimulusPoints.response.SettlingTime; end
        try Row(stim, strmatch('Stimulus Value (V)',titles,'exact')-firstColumn+1) =	(Stimulus(stim).StimulusTiming.stimulusAnalysis.stimulusPoints.response.SettlingMin +Stimulus(stim).StimulusTiming.stimulusAnalysis.stimulusPoints.response.SettlingMax)/2;  end
        try Row(stim, strmatch('Zero Pulse Duration (s)',titles,'exact')-firstColumn+1) =	 Stimulus(stim).StimulusTiming.stimulusAnalysis.zeroPulsePoints.duration; end
        try Row(stim, strmatch('Zero Pulse Average (V)',titles,'exact')-firstColumn+1) =	Stimulus(stim).StimulusTiming.stimulusAnalysis.zeroPulsePoints.average; end
        try Row(stim, strmatch('Zero Pulse RMS Error',titles,'exact')-firstColumn+1) =  Stimulus(stim).StimulusTiming.stimulusAnalysis.zeroPulsePoints.rmsError; end	
        try Row(stim, strmatch('Zero Pulse Min',titles,'exact')-firstColumn+1) =  Stimulus(stim).StimulusTiming.stimulusAnalysis.zeroPulsePoints.min; end
        try Row(stim, strmatch('Zero Pulse Min Time',titles,'exact')-firstColumn+1) =  Stimulus(stim).StimulusTiming.stimulusAnalysis.zeroPulsePoints.minTime; end
        try Row(stim, strmatch('Pull off Voltage (V)',titles,'exact')-firstColumn+1) = Stimulus(stim).StimulusTiming.stimulusAnalysis.postPulsePoints.min; end
        
        try Row(stim, strmatch('Reported Force (nN)',titles,'exact')-firstColumn+1)= Stimulus(stim).AppliedStimulus.forceApplied; end	
        try Row(stim, strmatch('Reported Cantilever Deflection (um)',titles,'exact')-firstColumn+1) = Stimulus(stim).AppliedStimulus.cantileverDeflection;end	
        try Row(stim, strmatch('Reported Indentation (um)',titles,'exact')-firstColumn+1) = Stimulus(stim).AppliedStimulus.indentation;end	
        
        %Frame, Trial, Response Scoring:
        try Row(stim, strmatch('Number of Bad Frames',titles,'exact')-firstColumn+1) = length(Stimulus(stim).FrameScoring.BadFrames); end
        try Row(stim, strmatch('Trial Success Scoring',titles,'exact')-firstColumn+1) = Stimulus(stim).TrialScoring.trialSuccessScoring(1)*100+ Stimulus(stim).TrialScoring.trialSuccessScoring(2)*10+ Stimulus(stim).TrialScoring.trialSuccessScoring(3); end
        try Row(stim, strmatch('Trial Success?',titles,'exact')-firstColumn+1) = Stimulus(stim).TrialScoring.trialSuccess; end
        try 
            if strcmp(Stimulus(stim).Response.Type, 'reversal')
                Row(stim, strmatch('Response Type',titles,'exact')-firstColumn+1) = 1;
            elseif (strcmp(Stimulus(stim).Response.Type , 'speedup'))
                Row(stim, strmatch('Response Type',titles,'exact')-firstColumn+1) = 2;
            elseif (strcmp(Stimulus(stim).Response.Type ,'pause'))
                Row(stim, strmatch('Response Type',titles,'exact')-firstColumn+1) = 3;
            else    
                Row(stim, strmatch('Response Type',titles,'exact')-firstColumn+1) = 4;  
            end
        end          
        try Row(stim, strmatch('Response Latency (s)',titles,'exact')-firstColumn+1) = Stimulus(stim).Response.Latency; end
        try Row(stim, strmatch('Pre Stimulus Average Speed (um/s)',titles,'exact')-firstColumn+1) = Stimulus(stim).Response.preStimSpeed; end
        try Row(stim, strmatch('Post Stimulus Average Speed (um/s)',titles,'exact')-firstColumn+1) = Stimulus(stim).Response.postStimSpeed;end
        try Row(stim, strmatch('Post Stimulus Average Speed 2 (um/s)',titles,'exact')-firstColumn+1) = Stimulus(stim).Response.postStimSpeed2;end
        try Row(stim, strmatch('Pre Stim Amplitude (um)',titles,'exact')-firstColumn+1)	= Stimulus(stim).Trajectory.amplitudePreStimAve;end
        try Row(stim, strmatch('Pre Stim Wavelength (um/cycle)',titles,'exact')-firstColumn+1)	= Stimulus(stim).Trajectory.wavelengthPreStimAve;end
        try Row(stim, strmatch('Post Stim Amplitude (um)'	,titles,'exact')-firstColumn+1) = Stimulus(stim).Trajectory.amplitudePostStimAve;end
        try Row(stim, strmatch('Post Stim Wavelength (um/cycle)',titles,'exact')-firstColumn+1) = Stimulus(stim).Trajectory.wavelengthPostStimAve;end
        try Row(stim, strmatch('Max Response Speed (um/s)',titles,'exact')-firstColumn+1) = Stimulus(stim).Response.maxSpeed;end
        try Row(stim, strmatch('Max Response Acceleration (um/s^2)',titles,'exact')-firstColumn+1) = Stimulus(stim).Response.maxAcceleration;end
        if strcmp(Stimulus(stim).Response.Type2 , 'speedup')
             try Row(stim, strmatch('Response Type 2',titles,'exact')-firstColumn+1) = 2;end
        else
            try Row(stim, strmatch('Response Type 2',titles,'exact')-firstColumn+1) = 4;end
        end
        try Row(stim, strmatch('Max Response Acceleration 2 (um/s^2)',titles,'exact')-firstColumn+1) = Stimulus(stim).Response.maxAcceleration2;end
         if strcmp(Stimulus(stim).Response.Type3 , 'speedup')
             try Row(stim, strmatch('Response Type 3',titles,'exact')-firstColumn+1) = 2;end
        else
            try Row(stim, strmatch('Response Type 3',titles,'exact')-firstColumn+1) = 4;end
         end
         if strcmp(Stimulus(stim).Response.Type4 , 'speedup')
             try Row(stim, strmatch('Response Type 4',titles,'exact')-firstColumn+1) = 2;end
        else
            try Row(stim, strmatch('Response Type 4',titles,'exact')-firstColumn+1) = 4;end
         end
        try Row(stim, strmatch('Reversal Acceleration',titles,'exact')-firstColumn+1) = Stimulus(stim).Response.reversalAcceleration;end
        
        try Row(stim, strmatch('Reversal Duration Flag',titles,'exact')-firstColumn+1) = Stimulus(stim).Response.durationEndFlag; end
        try Row(stim, strmatch('Reversal Duration',titles,'exact')-firstColumn+1) = Stimulus(stim).Response.duration; end
        try Row(stim, strmatch('Pre Reversal Speed',titles,'exact')-firstColumn+1) = Stimulus(stim).Response.reversalSpeed.before; end
        try Row(stim, strmatch('Post Reversal Speed',titles,'exact')-firstColumn+1) = Stimulus(stim).Response.reversalSpeed.after; end
        try Row(stim, strmatch('Reversal On Frame',titles,'exact')-firstColumn+1) = Stimulus(stim).Response.ReversalOnFrame; end
        try Row(stim, strmatch('Reversal Off Frame',titles,'exact')-firstColumn+1) = Stimulus(stim).Response.ReversalOffFrame; end
        
%         try Row(stim, strmatch('Pre Stim Fit a',titles,'exact')-firstColumn+1) =	Stimulus(stim).CurvatureAnalysis.PreStimulusCurvatureFit.fit.a; end
%         try Row(stim, strmatch('Pre Stim Fit b',titles,'exact')-firstColumn+1) =	Stimulus(stim).CurvatureAnalysis.PreStimulusCurvatureFit.fit.b; end
%         try Row(stim, strmatch('Pre Stim Fit c',titles,'exact')-firstColumn+1) =	Stimulus(stim).CurvatureAnalysis.PreStimulusCurvatureFit.fit.c; end
%         try Row(stim, strmatch('Pre Stim Fit d',titles,'exact')-firstColumn+1) =	Stimulus(stim).CurvatureAnalysis.PreStimulusCurvatureFit.fit.d; end
%         try Row(stim, strmatch('Pre Stim Fit goodness (rmse)',titles,'exact')-firstColumn+1) = Stimulus(stim).CurvatureAnalysis.PreStimulusCurvatureFit.goodness.rmse; end
%         try Row(stim, strmatch('Post Stim Fit a',titles,'exact')-firstColumn+1) =	Stimulus(stim).CurvatureAnalysis.PostStimulusCurvatureFit.fit.a; end
%         try Row(stim, strmatch('Post Stim Fit b',titles,'exact')-firstColumn+1) =	Stimulus(stim).CurvatureAnalysis.PostStimulusCurvatureFit.fit.b; end
%         try Row(stim, strmatch('Post Stim Fit c',titles,'exact')-firstColumn+1) =	Stimulus(stim).CurvatureAnalysis.PostStimulusCurvatureFit.fit.c; end
%         try Row(stim, strmatch('Post Stim Fit d',titles,'exact')-firstColumn+1) =	Stimulus(stim).CurvatureAnalysis.PostStimulusCurvatureFit.fit.d; end
%         try Row(stim, strmatch('Post Stim Fit goodness (rmse)',titles,'exact')-firstColumn+1) = Stimulus(stim).CurvatureAnalysis.PostStimulusCurvatureFit.goodness.rmse;  end
%         try Row(stim, strmatch('Reported Force (nN)',titles,'exact')-firstColumn+1)	= Stimulus(stim).AppliedStimulus.forceApplied; end
%         try Row(stim, strmatch('Reported Cantilever Deflection (um)',titles,'exact')-firstColumn+1)	= Stimulus(stim).AppliedStimulus.cantileverDeflection;end
%         try Row(stim, strmatch('Reported Indentation (um)'	,titles,'exact')-firstColumn+1)  = Stimulus(stim).AppliedStimulus.indentation;end
        
    end
    stimulusData = Row;
end