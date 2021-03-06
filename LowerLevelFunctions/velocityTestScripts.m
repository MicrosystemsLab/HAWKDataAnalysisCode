%%%% Scripts for the phase shift/velocity debug: 
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%

figure(2)
colors = {'r','b','k','g','m','y'};
for stim = 1:numStims
    numFrames= length(Stimulus(stim).Trajectory.speed);
    plot(1:numFrames,Stimulus(stim).Trajectory.speed, colors{stim});
    hold on
    
    
end

%% Plot the phase shift 
x = 1:50;
stim = 4;
for frame = 1:220
    
    if sign(Stimulus(stim).phaseShift.ps(frame))>0
        color = 'r';
    else
        color = 'b';
    end
   plot(x(20:40),Stimulus(stim).curvature(20:40,frame), color)
   hold on
   x = x + Stimulus(stim).phaseShift.ps(frame+1); 
end
axis([-Inf Inf -0.04 0.04])
title('Curvature offset by propogating phase shift','FontSize', 20);
xlabel('1/50ths of Body Length','FontSize', 16)
ylabel('Curvature','FontSize',16);

%%

x= 1:50;
prePhaseShiftPoints = x(20:40);
preCurvaturePoints = Stimulus(stim).curvature(20:40,1);

stim = 4;
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

[sortedPrePhaseShiftPoints, ind] = sort(prePhaseShiftPoints);
sortedPreCurvaturePoints = preCurvaturePoints(ind);
ind = find(~isnan(sortedPrePhaseShiftPoints)==1);
sortedPrePhaseShiftPoints = sortedPrePhaseShiftPoints(ind);
sortedPreCurvaturePoints = sortedPreCurvaturePoints(ind);

[sortedPostPhaseShiftPoints, ind] = sort(postPhaseShiftPoints);
sortedPostCurvaturePoints = postCurvaturePoints(ind);
ind = find(~isnan(sortedPostPhaseShiftPoints)==1);
sortedPostPhaseShiftPoints = sortedPostPhaseShiftPoints(ind);
sortedPostCurvaturePoints = sortedPostCurvaturePoints(ind);


guessPre = getZeroCrossings(sortedPrePhaseShiftPoints, sortedPreCurvaturePoints)
guessPost = getZeroCrossings(sortedPostPhaseShiftPoints, sortedPostCurvaturePoints)

f = fittype('(a*x+b).*sin(c.*x+d)');
preFit = fit(sortedPrePhaseShiftPoints',sortedPreCurvaturePoints,f, 'StartPoint',[1 max(sortedPreCurvaturePoints) 2*pi*(guessPre) 0]);
postFit = fit(sortedPostPhaseShiftPoints',sortedPostCurvaturePoints,f, 'StartPoint',[1 max(sortedPostCurvaturePoints) 2*pi*(guessPost) 0]);

figure(1);
plot(sortedPrePhaseShiftPoints, sortedPreCurvaturePoints)
hold on
plot(preFit,'r')
figure(2);
plot(sortedPostPhaseShiftPoints, sortedPostCurvaturePoints);
hold on
plot(postFit,'r')

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






