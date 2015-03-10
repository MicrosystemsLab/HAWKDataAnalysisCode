%%%% Function: Extract Behavior Data From Tracking
%  Sorts data from FPGA and Stimulus by stimulus application for analysis
% 
%  param {FPGAData} struct, contains all the data retrieved from the FPGA
%  param {StimulusData} struct, contains information about the data sent to
%  the FPGA
%  param {Stimulus} struct, contains experiment data organized by the
%  simulus.
%  param {numStims} int, number of stimulus to process
%  
%  returns {Stimulus} struct,  contains experiment data organized by
%  stimulus, modifyed to include the sorted frames.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%


function Stimulus = extractFPGADataFromFPGAData(FPGAData, StimulusData, Stimulus, numStims)

    %Extract the stimulus application data from the FPGA to align with the
    %tracking data:
        for stim = 1:numStims
           for i = 0:size(fieldnames(FPGAData.(['Stimulus',num2str(stim)]).PiezoSignalMagnitudes))-1
               Stimulus(stim).FPGAData.PiezoSignal(i+1) = FPGAData.(['Stimulus',num2str(stim)]).PiezoSignalMagnitudes.(['Point', num2str(i)]);
           end
           for i = 0:size(fieldnames(FPGAData.(['Stimulus',num2str(stim)]).ActuatorPositionMagnitudes))-1
               Stimulus(stim).FPGAData.ActuatorPosition(i+1) = FPGAData.(['Stimulus',num2str(stim)]).ActuatorPositionMagnitudes.(['Point', num2str(i)]);
           end
           for i = 0:size(fieldnames(FPGAData.(['Stimulus',num2str(stim)]).ActuatorCommandMagnitudes))-1
               Stimulus(stim).FPGAData.ActuatorCommand(i+1) = FPGAData.(['Stimulus',num2str(stim)]).ActuatorCommandMagnitudes.(['Point', num2str(i)]);
           end
           for i = 0:size(fieldnames(FPGAData.(['Stimulus',num2str(stim)]).DesiredSignalMagnitudes))-1
               Stimulus(stim).FPGAData.DesiredSignal(i+1) = FPGAData.(['Stimulus',num2str(stim)]).DesiredSignalMagnitudes.(['Point', num2str(i)]);

           end
           for i = 0:size(fieldnames(StimulusData.Voltages))-1
               Stimulus(stim).FPGAData.VoltagesSentToFPGA(i+1) = StimulusData.Voltages.(['Point', num2str(i) ]);
           end
        end
end
    

