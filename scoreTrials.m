


% function Stimulus = scoreTrials(Stimulus, numStims)
    HAWKProcessingConstants;
    for stim = 1:numStims
        % Count number of dropped frames
        numberOfDroppedFramesDuringStim(stim) =  sum(ismember(Stimulus(stim).FramesByStimulus.DuringStimFrames,Stimulus(stim).droppedFrames));
        %Find frames above residue limit
        
        % count number of frames above residue limit
        
        %find frames that have 
        for i = 1:length(skeleton)
            lengthOfSkeleton = length(skeleton(i).x);
            
            [x0, y0] = intersections(skeleton(i).x(1:floor(0.9*lengthOfSkeleton)), skeleton(i).y(1:floor(0.9*lengthOfSkeleton)));
            numberOfIntersections(i) = length(x0);
        end
        
    end
% end


%%
for stim = 1:numStims
    
    skeleton = Stimulus(stim).Skeleton;
    clear numberOfIntersections;
    for i = 1:length(skeleton)
            lengthOfSkeleton = length(skeleton(i).x);
            
            [x0, y0] = intersections(skeleton(i).x(1:floor(0.9*lengthOfSkeleton)), skeleton(i).y(1:floor(0.9*lengthOfSkeleton)));
            numberOfIntersections(i) = length(x0);
    end
    ind = find(numberOfIntersections>0);
    
    subplot(2,3,stim)
          
    % Phase shift plot:
    semilogy(Stimulus(stim).phaseShift.residual)
   
    %Dropped frames based on length calculation
    droppedFrames = zeros(length(Stimulus(stim).numFrames));
    droppedFrames(Stimulus(stim).droppedFrames) = 0.1;
    semilogy(droppedFrames,'rx');
    
    %Show frames during stimulus:
    semilogy(Stimulus(stim).FramesByStimulus.DuringStimFrames,0.75.*ones(size(Stimulus(stim).FramesByStimulus.DuringStimFrames)),'gx')
    
    %frames that have the skeleton cross itself:
    semilogy(ind,ones(size(ind))*0.25,'mx')
    
    %Plot manually scored frames:
    semilogy(Stimulus(stim).manuallyScoredBadFrames-Stimulus(stim).ProcessedFrameNumber(1)+1, 0.9*ones(size(Stimulus(stim).manuallyScoredBadFrames)),'bo')
    semilogy(Stimulus(stim).manuallyScoredOmegaTurns-Stimulus(stim).ProcessedFrameNumber(1)+1, 0.9*ones(size(Stimulus(stim).manuallyScoredOmegaTurns)),'ro')
    
    %Look at width of worm:
    wideWorms = find(Stimulus(stim).BodyMorphology.widthAtTarget>150);
    semilogy(wideWorms, ones(size(wideWorms))*0.6,'gx')
    
    
    axis([0 300 10^-6 10^0])
    title(['Stimulus: ' num2str(stim)])
end