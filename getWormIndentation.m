%%%% Function: get Worm Indentation

%  param {Stimulus} struct,  contains experiment data organized by
%  stimulus
%  param {TrackingData} struct, containt lots of experiment info
%  param {numStims} int, the number of stimulus in this experiment.
%
%  returns {Stimulus}, struct, modified to contain the indentation, the
%  cantilever deflection, and the force applied during this stimulus.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%




function Stimulus = getWormIndentation(Stimulus, TrackingData, StimulusData, numStims)
    HAWKSystemConstants;
    duration = StimulusData.ContactTime*1.5; %s
    pointsPerSecond = 1/(TrackingData.ReportedFPGAParameters.AcquisitionFrequency*0.00001);
  
    for stim = 1:numStims
         %Get the points of interest:
        numStimPoints = duration*pointsPerSecond;
        stimStartIndex = Stimulus(stim).StimulusTiming.stimOnFPGAIndex;
        stimPoints = [stimStartIndex-20:stimStartIndex-20+numStimPoints];

        %Need softbalance value to subtract off piezo signal to get deflection:
        softBalanceValue = Stimulus(stim).StimulusTiming.stimulusAnalysis.preApproachPoints.average;
        %Get cantilever information:
        % Cantilever Sensitivity = um/V
        cantileverSensitivity = TrackingData.CantileverProperties.Sensitivity;
        if strcmp(TrackingData.CantileverProperties.SerialNumber,'EM10A1306')
            cantileverSensitivity = 8.9781;
        end
        % Cantilever Stiffness = N/m
        cantileverStiffness = TrackingData.CantileverProperties.Stiffness;

        %Cantilever deflection = sensitivity * piezo signal = um
        cantileverDeflection = (Stimulus(stim).FPGAData.PiezoSignal(stimPoints)-softBalanceValue) .* cantileverSensitivity;
        cantileverForce = cantileverDeflection .* cantileverStiffness ./ 1e6; %um .* N/m * m/um = N

        %convert actuator position to um based on sensitivity:
        actuatorPosition = Stimulus(stim).FPGAData.ActuatorPosition(stimPoints) .* ACTUATOR_SENSITIVITY; %V * um/V
        %Need position of actuator at the point when the worm and cantilever come
        %in contact:
        actuatorZeroPositionIndices = find(diff(sign(cantileverDeflection(1:30)))==2,3,'first');
        if isempty(actuatorZeroPositionIndices)
            actuatorZeroPositionIndices = 19;
        end
        actuatorZeroPosition = actuatorPosition(actuatorZeroPositionIndices(end)-1);
        %Indentation: 
        %change in actuator position (in downwards direction): x0-xa
        %change in cantilever tip position (upwards direction): +xc
        %xs = xa - x0 - xc
        wormIndentation = actuatorPosition-actuatorZeroPosition-cantileverDeflection; %um
        riseTime = Stimulus(stim).StimulusTiming.stimulusAnalysis.stimulusPoints.response.RiseTime;
        risePoints = ceil(riseTime*pointsPerSecond);
        numStimOnPoints = length(Stimulus(stim).StimulusTiming.stimulusAnalysis.stimulusPoints.data);
        
        Stimulus(stim).AppliedStimulus.indentation = mean(wormIndentation(20+risePoints:20+numStimOnPoints)); %unit: um
        Stimulus(stim).AppliedStimulus.cantileverDeflection = mean(cantileverDeflection(20+risePoints:20+numStimOnPoints)); %unit: um
        Stimulus(stim).AppliedStimulus.forceApplied = mean(cantileverForce(20+risePoints:20+numStimOnPoints))*10^9; %unit: nN
        
        % F = kx
       % wormStiffness = cantileverForce./wormIndentation .*1e6 ; % N / um * um/m = N/m
    end



%     subplot(311),plot([0:1/pointsPerSecond:duration],cantileverDeflection);
%     subplot(312),plot([0:1/pointsPerSecond:duration],actuatorPosition-actuatorZeroPosition);
%     subplot(313),plot([0:1/pointsPerSecond:duration],wormIndentation,'b', 0.001.*[20+risePoints:20+numStimOnPoints], wormIndentation(20+risePoints:20+numStimOnPoints),'r.');

end