
%%%%% Function: score frames
% Sort between good and back frames based on four metrics:
%  1. if the skeleton intersects itself
%  2. body lengths that are too long or too short
%  3. large width measurements
%  4. high residual in the curvature phase shift calculations. 
% 
%  HAWK Processing Constants contains the threshold constants to be used in
%  in this algorithm, including the weight matrix for the different
%  metrics. 
%  For each frame, a score is calculated based on the weighted precense of
%  the above matrix and compared to a threshold. If above the threshold,
%  then the frame is given a bad score. 
% 
%  param {Stimulus} struct,  contains experiment data organized by
%  stimulus
%  param {numStims} int, the number of stimulus in this experiment.
%  
%  returns {Stimulus} struct, returns the same Stimulus with an added list
%  of the computer determined bad frames.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%

function Stimulus = scoreFrames(Stimulus, numStims)
    HAWKProcessingConstants;
    
    
%     weights = zeros(4,numStims);
    for stim = 1:numStims
        metrics = zeros(Stimulus(stim).numFrames,3);
        
        % Find frames where the skeleton intersects itself:
        skeleton = Stimulus(stim).Skeleton;
        clear numberOfIntersections;
        for i = 1:length(skeleton)
            lengthOfSkeleton = length(skeleton(i).x);
            [x0, y0] = intersections(skeleton(i).x(1:floor(0.9*lengthOfSkeleton)), skeleton(i).y(1:floor(0.9*lengthOfSkeleton)));
            numberOfIntersections(i) = length(x0);
        end
        metrics(find(numberOfIntersections>0),1) = 1;

        
        %find dropped frames based on length calculation           
        if ismember('framesOutOfBodyLengthRange',fieldnames(Stimulus(stim).BodyMorphology))
            metrics(Stimulus(stim).BodyMorphology.framesOutOfBodyLengthRange,2) = 1;
        end
            
        % find frames based on large width measurements:
        metrics(find(Stimulus(stim).BodyMorphology.widthAtTarget>WIDTH_AT_TARGET_LIMIT),3) = 1;
      
        scores = metrics*metricWeights;
        Stimulus(stim).FrameScoring.BadFrames = find(scores>=FRAME_SCORE_THRESHOLD);
        Stimulus(stim).FrameScoring.GoodFrames = find(scores<FRAME_SCORE_THRESHOLD);
    end
end


%% %For Debug:
% for stim = 1:numStims
%     
%     skeleton = Stimulus(stim).Skeleton;
%     clear numberOfIntersections;
%     for i = 1:length(skeleton)
%             lengthOfSkeleton = length(skeleton(i).x);
%             
%             [x0, y0] = intersections(skeleton(i).x(1:floor(0.9*lengthOfSkeleton)), skeleton(i).y(1:floor(0.9*lengthOfSkeleton)));
%             numberOfIntersections(i) = length(x0);
%     end
%     ind = find(numberOfIntersections>0);
%     
%     subplot(2,3,stim)
%           
%     % Phase shift plot:
%     semilogy(Stimulus(stim).phaseShift.residual)
%    hold on
%     %Dropped frames based on length calculation
%     droppedFrames = zeros(length(Stimulus(stim).numFrames));
%     droppedFrames(Stimulus(stim).droppedFrames) = 0.1;
%     semilogy(droppedFrames,'rx');
%     
%     %Show frames during stimulus:
%     semilogy(Stimulus(stim).FramesByStimulus.DuringStimFrames,0.75.*ones(size(Stimulus(stim).FramesByStimulus.DuringStimFrames)),'gx')
%     
%     %frames that have the skeleton cross itself:
%     semilogy(ind,ones(size(ind))*0.25,'mx')
%     
%     %Plot manually scored frames:
%     semilogy(Stimulus(stim).manuallyScoredBadFrames-Stimulus(stim).ProcessedFrameNumber(1)+1, 0.9*ones(size(Stimulus(stim).manuallyScoredBadFrames)),'b.')
%     semilogy(Stimulus(stim).manuallyScoredOmegaTurns-Stimulus(stim).ProcessedFrameNumber(1)+1, 0.9*ones(size(Stimulus(stim).manuallyScoredOmegaTurns)),'r.')
%     
%     %Look at width of worm:
%     wideWorms = find(Stimulus(stim).BodyMorphology.widthAtTarget>150);
%     semilogy(wideWorms, ones(size(wideWorms))*0.6,'gx')
%     
%     semilogy(Stimulus(stim).computerScoredBadFrames, ones(size(Stimulus(stim).computerScoredBadFrames)),'g.')
%     
%     axis([0 300 10^-6 10^0])
%     title(['Stimulus: ' num2str(stim)])
% end




