function Stimulus = determineMovementType(Stimulus, numStims)

% for stim = 1:numStims
%     numGoodFrames = length(Stimulus(stim).goodFrames);
%     forwardCounter = 1;
%     backwardCounter = 1;
%     smallerCounter = 1;
%     biggerCounter = 1;
%     for frame = gap+1:numGoodFrames
%        currentFrame = Stimulus(stim).goodFrames(frame);
%        previousFrame = Stimulus(stim).goodFrames(frame-gap);
%        distanceRefHead = distanceCalc(Stimulus(stim).centroidPosition.x(currentFrame), Stimulus(stim).centroidPosition.y(currentFrame), Stimulus(stim).headPosition.x(currentFrame), Stimulus(stim).headPosition.y(currentFrame));
%        distanceRefPrevHead = distanceCalc(Stimulus(stim).centroidPosition.x(currentFrame), Stimulus(stim).centroidPosition.y(currentFrame), Stimulus(stim).headPosition.x(previousFrame), Stimulus(stim).headPosition.y(previousFrame));
%        distanceRefTail = distanceCalc(Stimulus(stim).centroidPosition.x(currentFrame), Stimulus(stim).centroidPosition.y(currentFrame), Stimulus(stim).tailPosition.x(currentFrame), Stimulus(stim).tailPosition.y(currentFrame));
%        distanceRefPrevTail = distanceCalc(Stimulus(stim).centroidPosition.x(currentFrame), Stimulus(stim).centroidPosition.y(currentFrame), Stimulus(stim).tailPosition.x(previousFrame), Stimulus(stim).tailPosition.y(previousFrame));
%         % check if moving forward
%         if ((distanceRefPrevHead > distanceRefHead) && (distanceRefPrevTail < distanceRefTail))
%             Stimulus(stim).forwardFrames(forwardCounter) = currentFrame;
%             plot([currentFrame currentFrame],[stim stim+0.5], markers{1},'LineWidth',2);
%             forwardCounter = forwardCounter + 1;
%             % check if moving backward
%         elseif ((distanceRefPrevHead < distanceRefHead) && (distanceRefPrevTail > distanceRefTail))
%             Stimulus(stim).backwardFrames(backwardCounter) = currentFrame;
%             plot([currentFrame currentFrame],[stim stim+0.5], markers{2},'LineWidth',2);
%             backwardCounter = backwardCounter + 1;
% %         elseif ((distanceRefPrevHead < distanceRefHead) && (distanceRefPrevTail < distanceRefTail))
% %             Stimulus(stim).unknownMovementFrames(otherCounter) = currentFrame;
% %             plot([currentFrame currentFrame],[stim stim+0.5], markers{3},'LineWidth',2);
% %             smallerCounter = smallerCounter + 1;
% %         elseif ((distanceRefPrevHead > distanceRefHead) && (distanceRefPrevTail > distanceRefTail))
% %              Stimulus(stim).unknownMovementFrames(otherCounter) = currentFrame;
% %             plot([currentFrame currentFrame],[stim stim+0.5], markers{4},'LineWidth',2);
% %             smallerCounter = smallerCounter + 1;
%         else
%             Stimulus(stim).unknownMovementFrames(smallerCounter) = currentFrame;
%             plot([currentFrame currentFrame],[stim stim+0.5], markers{3},'LineWidth',2);
%             smallerCounter = smallerCounter + 1;
%         end
%         hold on
%        
%     end

end



% %% Determine Forward, Backward, other movement
% markers ={'r-','b-','k-','y-','g-'};
% gap = 10;
% figure;
% for stim = 1:numStims
%     numGoodFrames = length(Stimulus(stim).goodFrames);
%     forwardCounter = 1;
%     backwardCounter = 1;
%     smallerCounter = 1;
%     biggerCounter = 1;
%     for frame = gap+1:numGoodFrames
%        currentFrame = Stimulus(stim).goodFrames(frame);
%        previousFrame = Stimulus(stim).goodFrames(frame-gap);
%        distanceRefHead = distanceCalc(Stimulus(stim).centroidPosition.x(currentFrame), Stimulus(stim).centroidPosition.y(currentFrame), Stimulus(stim).headPosition.x(currentFrame), Stimulus(stim).headPosition.y(currentFrame));
%        distanceRefPrevHead = distanceCalc(Stimulus(stim).centroidPosition.x(currentFrame), Stimulus(stim).centroidPosition.y(currentFrame), Stimulus(stim).headPosition.x(previousFrame), Stimulus(stim).headPosition.y(previousFrame));
%        distanceRefTail = distanceCalc(Stimulus(stim).centroidPosition.x(currentFrame), Stimulus(stim).centroidPosition.y(currentFrame), Stimulus(stim).tailPosition.x(currentFrame), Stimulus(stim).tailPosition.y(currentFrame));
%        distanceRefPrevTail = distanceCalc(Stimulus(stim).centroidPosition.x(currentFrame), Stimulus(stim).centroidPosition.y(currentFrame), Stimulus(stim).tailPosition.x(previousFrame), Stimulus(stim).tailPosition.y(previousFrame));
%         % check if moving forward
%         if ((distanceRefPrevHead > distanceRefHead) && (distanceRefPrevTail < distanceRefTail))
%             Stimulus(stim).forwardFrames(forwardCounter) = currentFrame;
%             plot([currentFrame currentFrame],[stim stim+0.5], markers{1},'LineWidth',2);
%             forwardCounter = forwardCounter + 1;
%             % check if moving backward
%         elseif ((distanceRefPrevHead < distanceRefHead) && (distanceRefPrevTail > distanceRefTail))
%             Stimulus(stim).backwardFrames(backwardCounter) = currentFrame;
%             plot([currentFrame currentFrame],[stim stim+0.5], markers{2},'LineWidth',2);
%             backwardCounter = backwardCounter + 1;
% %         elseif ((distanceRefPrevHead < distanceRefHead) && (distanceRefPrevTail < distanceRefTail))
% %             Stimulus(stim).unknownMovementFrames(otherCounter) = currentFrame;
% %             plot([currentFrame currentFrame],[stim stim+0.5], markers{3},'LineWidth',2);
% %             smallerCounter = smallerCounter + 1;
% %         elseif ((distanceRefPrevHead > distanceRefHead) && (distanceRefPrevTail > distanceRefTail))
% %              Stimulus(stim).unknownMovementFrames(otherCounter) = currentFrame;
% %             plot([currentFrame currentFrame],[stim stim+0.5], markers{4},'LineWidth',2);
% %             smallerCounter = smallerCounter + 1;
%         else
%             Stimulus(stim).unknownMovementFrames(smallerCounter) = currentFrame;
%             plot([currentFrame currentFrame],[stim stim+0.5], markers{3},'LineWidth',2);
%             smallerCounter = smallerCounter + 1;
%         end
%         hold on
%        
%     end
%     
%     
%    %plot omega turns
%     if (isfield(Stimulus(stim),'omegaTurnFrames'))
%         for i = 1:length(Stimulus(stim).omegaTurnFrames)
%             plot([Stimulus(stim).omegaTurnFrames(i) Stimulus(stim).omegaTurnFrames(i)], [stim stim+0.5], markers{5},'LineWidth', 2);
%         end
%     end
%     
%     
%     plot(stim+Stimulus(stim).headTailToggle*0.4-0.45, 'r-','LineWidth',2)
%     plot(stim+Stimulus(stim).StimulusActivity*0.4-0.45, 'b-', 'LineWidth',2)
%     
%     hold on;
%   
%    
% 
% end
%  xlabel('Frame Number','FontSize', 20);
%  ylabel('Stimulus','FontSize', 20);