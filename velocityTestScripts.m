figure(2)
colors = {'r','b','k','g','m','y'};
for stim = 1:numStims
    numFrames= length(Stimulus(stim).Trajectory.speed);
    plot(1:numFrames,Stimulus(stim).Trajectory.speed, colors{stim});
    hold on
    
    
end

%%
x = 1:50;
for i = 125:135
    
    if sign(ps(i))>0
        color = 'r';
    else
        color = 'b';
    end
   plot(x,curvature_smooth(:,i), color)
   hold on
   x = x + ps(i+1); 
end

%%
figure;
colors = {'r','b','k','g','m','y'};
for stim = 1:6
    
    trackSpeed = velocity(stim).speed.*Stimulus(stim).BodyMorphology.averageBodyLengthGoodFrames;
    numFrames = length(trackSpeed);
    plot(1:numFrames,trackSpeed, colors{stim})
    hold on
end

%% 

for stim = 1:numStims
    skeleton = Stimulus(stim).Skeleton;
    
    [curvature, distanceBetweenPoints]= findCurvature(skeleton, sigma, numcurvpts);
    [ps, ps_residual] = calculateCurvaturePhaseShift(curvature);
    
 subplot(numStims,1,stim)
    plot([1:length(ps_residual)],ps_residual, 'b', [1:length(ps_residual)],ps_residual, 'rx');
     hold on
    plot(Stimulus(stim).droppedFrames, zeros(size(Stimulus(stim).droppedFrames)),'g+');
end






