
% function Stimulus = calculateCurvatureParameters(Stimulus,numStims)

    HAWKProcessingConstants
    for stim = 1:numStims

        x= 1:NUMCURVPTS;
        prePhaseShiftPoints = x(20:40);
        preCurvaturePoints = Stimulus(stim).curvature(20:40,1);


        endFrame = Stimulus(stim).numFrames-1;


        stimOnFrame =  find(Stimulus(stim).timeData(:,8)>Stimulus(stim).StimulusTiming.stimOnStartTime,1)-1;

        for frame = 2:stimOnFrame-1

            prePhaseShiftPoints = [prePhaseShiftPoints x(20:40)];
            preCurvaturePoints = [preCurvaturePoints; Stimulus(stim).curvature(20:40,frame)];
            x = x + Stimulus(stim).phaseShift.ps(frame+1); 

        end
        postPhaseShiftPoints = x(20:40);
        postCurvaturePoints = Stimulus(stim).curvature(20:40,stimOnFrame);
        for frame = stimOnFrame+1:endFrame
            postPhaseShiftPoints = [postPhaseShiftPoints x(20:40)];
            postCurvaturePoints = [postCurvaturePoints; Stimulus(stim).curvature(20:40,frame)];
            if frame<endFrame
                x = x + Stimulus(stim).phaseShift.ps(frame+1); 
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
            figure(stim);
            subplot(211)
            plot(sortedPrePhaseShiftPoints, sortedPreCurvaturePoints)
            hold on
            plot(preFit,'r')
        end
        
        
        [sortedPostPhaseShiftPoints, ind] = sort(postPhaseShiftPoints);
        sortedPostCurvaturePoints = postCurvaturePoints(ind);
        ind = find(~isnan(sortedPostPhaseShiftPoints)==1);
        if ~isempty(ind)
            sortedPostPhaseShiftPoints = sortedPostPhaseShiftPoints(ind);
            sortedPostCurvaturePoints = sortedPostCurvaturePoints(ind);
            guessPost = getZeroCrossings(sortedPostPhaseShiftPoints, sortedPostCurvaturePoints);    
            [postFit postFitGoodness] = fit(sortedPostPhaseShiftPoints',sortedPostCurvaturePoints,f, 'StartPoint',[1 max(sortedPostCurvaturePoints) 2*pi*(1/guessPost) 0]);
            figure(stim);
            subplot(212)
            plot(sortedPostPhaseShiftPoints, sortedPostCurvaturePoints);
            hold on
            plot(postFit,'r')
        end
    end
    
% end