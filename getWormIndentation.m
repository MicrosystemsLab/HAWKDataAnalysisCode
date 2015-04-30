% F = kx


stim = 1;

duration = 0.1*1.5; %s
pointsPerSecond = 1000;
actuatorSensitivity = 26.04; %um/V

%Get the points of interest:
numStimPoints = duration*pointsPerSecond;
stimStartIndex = Stimulus(stim).StimulusTiming.stimOnFPGAIndex-20;
stimPoints = [stimStartIndex:stimStartIndex+numStimPoints];

%Need softbalance value to subtract off piezo signal to get deflection:
softBalanceValue = Stimulus(stim).StimulusTiming.stimulusAnalysis.preApproachPoints.average;
%Get cantilever information:
% Cantilever Sensitivity = um/V
cantileverSensitivity = TrackingData.CantileverProperties.Sensitivity;
% Cantilever Stiffness = N/m
cantileverStiffness = TrackingData.CantileverProperties.Stiffness;

%Cantilever deflection = sensitivity * piezo signal = um
cantileverDeflection = (Stimulus(stim).FPGAData.PiezoSignal(stimPoints)-softBalanceValue) .* cantileverSensitivity;
cantileverForce = cantileverDeflection .* cantileverStiffness ./ 1e6; %um .* N/m * m/um = N

%convert actuator position to um based on sensitivity:
actuatorPosition = Stimulus(stim).FPGAData.ActuatorPosition(stimPoints) .* actuatorSensitivity; %V * um/V
%Need position of actuator at the point when the worm and cantilever come
%in contact:
actuatorZeroPosition = actuatorPosition(find(diff(sign(cantileverDeflection))==2,1)+1);

%Indentation: 
%change in actuator position (in downwards direction): x0-xa
%change in cantilever tip position (upwards direction): +xc
%xs = x0 - xa + xc
wormIndentation = actuatorZeroPosition-actuatorPosition+cantileverDeflection; %um
wormStiffness = cantileverForce./wormIndentation .*1e6 ; % N / um * um/m = N/m

subplot(311),plot([0:1/pointsPerSecond:duration],cantileverDeflection);
subplot(312),plot([0:1/pointsPerSecond:duration],actuatorPosition-actuatorZeroPosition);
subplot(313),plot([0:1/pointsPerSecond:duration],wormIndentation,'b');