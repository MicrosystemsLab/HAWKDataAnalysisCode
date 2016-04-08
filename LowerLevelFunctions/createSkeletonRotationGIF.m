%%%% Function: createSkeletonRotationGIF
%  This function creates a stack of images displayed via a GIF comprised of
%  the rotated skeleton. There are two plots for each image. The first is
%  the original skeleton and the second is the rotated skeleton.
%
%  param {Stimulus} struct,  contains experiment data organized by
%  stimulus
%  param {numStims} int, the number of stimulus in this experiment.
%  param {director} string, the location for the GIF to be stored
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%%%%%

function createSkeletonRotationGIF(Stimulus, numStims, directory)

    for stim = 1:numStims
        experimentTitle = getExperimentTitle(directory);
        filename = strcat(experimentTitle,'_SkeletonRotation_Stimulus_',num2str(stim),'.gif');
        
        
        for frame = 1:Stimulus(stim).numFrames
            figure(stim);
            subplot(211), plot(Stimulus(stim).SkeletonSmooth(frame).x, Stimulus(stim).SkeletonSmooth(frame).y, 'b', ...
                 Stimulus(stim).SkeletonSmooth(frame).x(1), Stimulus(stim).SkeletonSmooth(frame).y(1), 'rx')
            axis('equal');
            title(strcat('Smoothed Skeleton, Frame ', num2str(frame)));
            subplot(212), plot(Stimulus(stim).Trajectory.RotatedSkeleton(frame).x, Stimulus(stim).Trajectory.RotatedSkeleton(frame).y, 'b', ...
                 Stimulus(stim).Trajectory.RotatedSkeleton(frame).x(1), Stimulus(stim).Trajectory.RotatedSkeleton(frame).y(1), 'rx')
            axis('equal');
            title('Rotated Skeleton');
            frame2write = getframe(1);
            im = frame2im(frame2write);
            [A,map] = rgb2ind(im,256); 
            if frame == 1
                imwrite(A,map,fullfile(directory,filename),'gif','LoopCount',Inf,'DelayTime',1);
            else
                imwrite(A,map,fullfile(directory,filename),'gif','WriteMode','append','DelayTime',1);
            end
        end
        
        

    end
    close all


end