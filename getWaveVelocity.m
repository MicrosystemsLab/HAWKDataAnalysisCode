%% Function: get wave velocity



% get direction vector. 
% define direction vector as the line that goes through the centroid, and
% is parallel to the line that connects the head and tail.



%Head tail vector = 
frame = 1;
stim = 2;
trajectory = Stimulus(stim).Trajectory;
vector = [trajectory.headPosition.x' - trajectory.tailPosition.x', ...
    trajectory.headPosition.y' - trajectory.tailPosition.y'];
angle = unwrap(atan2(-vector(:,2),vector(:,1)))*180/pi;

%%

%angle vector between means:
df = diff([trajectory.meanPosition.x', trajectory.meanPosition.y'],1,1);
angleChange = unwrap(atan2(-df(:,2), df(:,1)))*180/pi;
