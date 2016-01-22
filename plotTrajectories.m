goodFrames = Stimulus(stim).FrameScoring.GoodFrames;

preStimFrames = goodFrames(ismember(goodFrames,Stimulus(stim).FramesByStimulus.PreStimFrames));
postStimFrames = goodFrames(ismember(goodFrames,Stimulus(stim).FramesByStimulus.PostStimFrames));
duringStimFrames = goodFrames(ismember(goodFrames,Stimulus(stim).FramesByStimulus.DuringStimFrames));

plot(Stimulus(stim).Trajectory.centroidPosition.x(preStimFrames), Stimulus(stim).Trajectory.centroidPosition.y(preStimFrames), 'r-', 'LineWidth',2);  
hold on
plot(Stimulus(stim).Trajectory.meanPosition.x(preStimFrames), Stimulus(stim).Trajectory.meanPosition.y(preStimFrames), 'r:', 'LineWidth',2);  
%during stim:
hold on
plot(Stimulus(stim).Trajectory.centroidPosition.x(duringStimFrames), Stimulus(stim).Trajectory.centroidPosition.y(duringStimFrames), 'b-', 'LineWidth',2); 
plot(Stimulus(stim).Trajectory.meanPosition.x(duringStimFrames), Stimulus(stim).Trajectory.meanPosition.y(duringStimFrames), 'b:', 'LineWidth',2); 
%post stim:
hold on
plot(Stimulus(stim).Trajectory.centroidPosition.x(postStimFrames), Stimulus(stim).Trajectory.centroidPosition.y(postStimFrames), 'k-', 'LineWidth',2); 
plot(Stimulus(stim).Trajectory.meanPosition.x(postStimFrames), Stimulus(stim).Trajectory.meanPosition.y(postStimFrames), 'k:', 'LineWidth',2); 
%first position:
hold on
plot(Stimulus(stim).Trajectory.centroidPosition.x(preStimFrames(1)), Stimulus(stim).Trajectory.centroidPosition.y(preStimFrames(1)), 'ro', 'MarkerSize',14);
%last position:
hold on
plot(Stimulus(stim).Trajectory.centroidPosition.x(postStimFrames(end)), Stimulus(stim).Trajectory.centroidPosition.y(postStimFrames(end)), 'kx', 'MarkerSize',14);

axis([-3000 300 -645-3300/2 -645+3300/2])
axis('equal')
