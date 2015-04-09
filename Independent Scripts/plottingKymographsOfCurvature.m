figure(1);
for stim = 1:numStims
    clear stimulusStatus
    
    
    imageData = curvaturePlot(Stimulus(stim).curvature', 50, 0.035, -0.035);
    stimulusStatus(:,:,1) = 255-255.*[Stimulus(stim).StimulusActivity; ...
        Stimulus(stim).StimulusActivity;...
        Stimulus(stim).StimulusActivity]; 
    stimulusStatus(:,:,2) = 255-1.*[Stimulus(stim).StimulusActivity; ...
        Stimulus(stim).StimulusActivity;...
        Stimulus(stim).StimulusActivity]; 
    stimulusStatus(:,:,3) = 255-156.*[Stimulus(stim).StimulusActivity; ...
        Stimulus(stim).StimulusActivity;...
        Stimulus(stim).StimulusActivity]; 
    imageToShow = [imageData.img; stimulusStatus];
    subplot(3,2,stim), imshow( imageToShow);
    if (Stimulus(stim).Response.Latency>0)
        titleString = {['Computer Determined Response = ' Stimulus(stim).Response.Type],...
            ['Latency = ' num2str(Stimulus(stim).Response.Latency) ' s']};
    else
        titleString = ['Computer Determined Response = ' Stimulus(stim).Response.Type];
    end
    
    title(titleString, 'FontSize', 20);
%     if stim == 6
        xlabel('Frame','FontSize',16)
%     end
    ylabel('Curvature','FontSize',16)
    
end