
%%%% Function: Calculate Curvature Parameters
%  This function fits a sine wave to the curvature trace before and after
%  the stimulus. It fits the track to the function: (ax+b)sin(cx+d). The
%  function returns the fits and the goodness of each fit inside the
%  "Stimulus" structure.
% 
%  param {Stimulus} struct,  contains experiment data organized by
%  stimulus
%  param {numStims} int, the number of stimulus in this experiment.
%
%  returns {Stimulus} struct,  contains experiment data organized by
%  stimulus including the curvature fits before and after stimulus.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%%%%%
function Stimulus = calculateCurvatureParameters(Stimulus,numStims)

    HAWKProcessingConstants
    %Iterate through each stimulus:
    for stim = 1:numStims
        
        %Create "track" 
        x= 1:NUMCURVPTS;
        prePhaseShiftPoints = x(20:40);
        preCurvaturePoints = Stimulus(stim).CurvatureAnalysis.curvature(20:40,1);


        endFrame = Stimulus(stim).numFrames-1;


        stimOnFrame =  find(Stimulus(stim).timeData(:,8)>Stimulus(stim).StimulusTiming.stimOnStartTime,1)-1;

        for frame = 2:stimOnFrame-1

            prePhaseShiftPoints = [prePhaseShiftPoints x(20:40)];
            preCurvaturePoints = [preCurvaturePoints; Stimulus(stim).CurvatureAnalysis.curvature(20:40,frame)];
            x = x + Stimulus(stim).CurvatureAnalysis.phaseShift.ps(frame+1); 

        end
        postPhaseShiftPoints = x(20:40);
        postCurvaturePoints = Stimulus(stim).CurvatureAnalysis.curvature(20:40,stimOnFrame);
        for frame = stimOnFrame+1:endFrame
            postPhaseShiftPoints = [postPhaseShiftPoints x(20:40)];
            postCurvaturePoints = [postCurvaturePoints; Stimulus(stim).CurvatureAnalysis.curvature(20:40,frame)];
            if frame<endFrame
                x = x + Stimulus(stim).CurvatureAnalysis.phaseShift.ps(frame+1); 
            end
        end
        
        
        
         f = fittype('(a*x+b).*sin(c.*x+d)');
        
        [sortedPrePhaseShiftPoints, ind] = sort(prePhaseShiftPoints);
        sortedPreCurvaturePoints = preCurvaturePoints(ind);
        ind = find(~isnan(sortedPrePhaseShiftPoints)==1);
        if ~isempty(ind)
            sortedPrePhaseShiftPoints = sortedPrePhaseShiftPoints(ind);
            sortedPreCurvaturePoints = sortedPreCurvaturePoints(ind);
            guessPre = getZeroCrossings(sortedPrePhaseShiftPoints, sortedPreCurvaturePoints);
            [preFit preFitGoodness] = fit(sortedPrePhaseShiftPoints',sortedPreCurvaturePoints,f, 'StartPoint',[1 max(sortedPreCurvaturePoints) 2*pi*(1/guessPre) 0]);
            Stimulus(stim).CurvatureAnalysis.PreStimulusCurvatureFit.fit = preFit;
            Stimulus(stim).CurvatureAnalysis.PreStimulusCurvatureFit.goodness = preFitGoodness;
%             figure(stim);
%             subplot(211)
%             plot(sortedPrePhaseShiftPoints, sortedPreCurvaturePoints)
%             hold on
%             plot(preFit,'r')
        end
        
        
        [sortedPostPhaseShiftPoints, ind] = sort(postPhaseShiftPoints);
        sortedPostCurvaturePoints = postCurvaturePoints(ind);
        ind = find(~isnan(sortedPostPhaseShiftPoints)==1);
        if ~isempty(ind)
            sortedPostPhaseShiftPoints = sortedPostPhaseShiftPoints(ind);
            sortedPostCurvaturePoints = sortedPostCurvaturePoints(ind);
            guessPost = getZeroCrossings(sortedPostPhaseShiftPoints, sortedPostCurvaturePoints);    
            [postFit postFitGoodness] = fit(sortedPostPhaseShiftPoints',sortedPostCurvaturePoints,f, 'StartPoint',[1 max(sortedPostCurvaturePoints) 2*pi*(1/guessPost) 0]);
            Stimulus(stim).CurvatureAnalysis.PostStimulusCurvatureFit.fit = postFit;
            Stimulus(stim).CurvatureAnalysis.PostStimulusCurvatureFit.goodness = postFitGoodness;
%             figure(stim);
%             subplot(212)
%             plot(sortedPostPhaseShiftPoints, sortedPostCurvaturePoints);
%             hold on
%             plot(postFit,'r')
        end
    end
    
end