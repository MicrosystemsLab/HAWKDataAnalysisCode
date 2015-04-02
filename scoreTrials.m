


% function Stimulus = scoreTrials(Stimulus, numStims)
    HAWKProcessingConstants;
    for stim = 1:numStims
        % Count number of dropped frames
        numberOfDroppedFramesDuringStim(stim) =  sum(ismember(Stimulus(stim).FramesByStimulus.DuringStimFrames,Stimulus(stim).droppedFrames));
        %Find frames above residue limit
        
        % count number of frames above residue limit
        
    end
% end


%%
for stim = 1:numStims
    subplot(2,3,stim)
    semilogy(Stimulus(stim).phaseShift.residual)
    hold on
    droppedFrames = zeros(length(Stimulus(stim).numFrames));
    droppedFrames(Stimulus(stim).droppedFrames) = 0.1;
    semilogy(droppedFrames,'rx');
    
    semilogy(Stimulus(stim).FramesByStimulus.DuringStimFrames,0.5.*ones(size(Stimulus(stim).FramesByStimulus.DuringStimFrames)),'gx')
    axis([0 300 10^-6 10^0])
    title(['Stimulus: ' num2str(stim)])
end