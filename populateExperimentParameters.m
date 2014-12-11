function Row = populateExperimentParameters( experimentTitle, TrackingData, titles)
    
    
    
    Row(1, strmatch('Experiment Name',titles,'exact')) = {experimentTitle};
    Row(1, strmatch('Date',titles,'exact')) = {TrackingData.ExperimentTime(1:10)};
    Row(1, strmatch('Experiment Title',titles,'exact')) = {TrackingData.ExperimentTitle};
    Row(1, strmatch('Time Stamp',titles,'exact')) = {TrackingData.ExperimentTime};
    Row(1, strmatch('Experiment Mode',titles,'exact')) = {TrackingData.ExperimentMode};
    Row(1, strmatch('Slide No.', titles, 'exact')) = {TrackingData.SlideNumber};
    Row(1, strmatch('Experiment No.', titles, 'exact')) = {TrackingData.ExperimentOnThisSlideNumber};
    Row(1, strmatch('Pre Stim Recording Time (s)', titles, 'exact')) = {TrackingData.Pre0x2DStimulusRecordTime};
    Row(1, strmatch('Post Stim Recording Time (s)', titles, 'exact')) = {TrackingData.Post0x2DStimulusRecordTime};
    Row(1, strmatch('Target Location (%)', titles, 'exact')) = {TrackingData.TargetLocation};
    Row(1, strmatch('Stimulus Number', titles, 'exact')) = {TrackingData.NumberOfStimulus};
    %Worm info:
    Row(1, strmatch('Strain',titles,'exact')) = {TrackingData.WormProperties.WormStrain};
    Row(1, strmatch('Treatments',titles,'exact')) = {TrackingData.WormProperties.WormTreatments};
    Row(1, strmatch('Gender',titles,'exact')) = {TrackingData.WormProperties.WormGender};
    Row(1, strmatch('Age',titles,'exact')) = {TrackingData.WormProperties.WormAge};
    Row(1, strmatch('Percent Agar',titles,'exact')) = {TrackingData.WormProperties.PercentAgar};
    Row(1, strmatch('Food Status',titles,'exact')) = {TrackingData.WormProperties.FoodStatus};
    %Cantilever Info:
    Row(1, strmatch('Cantilever ID',titles,'exact')) = {TrackingData.CantileverProperties.SerialNumber};
    Row(1, strmatch('Frequency (kHz)',titles,'exact')) = {TrackingData.CantileverProperties.ResonantFrequency};
    Row(1, strmatch('Stiffness (N/m)',titles,'exact')) = {TrackingData.CantileverProperties.Stiffness};
    Row(1, strmatch('Sensitivity (um/V)',titles,'exact')) = {TrackingData.CantileverProperties.Sensitivity};
    Row(1, strmatch('P Parameter',titles,'exact')) = {TrackingData.CantileverProperties.PParameter};
    Row(1, strmatch('I Parameter',titles,'exact')) = {TrackingData.CantileverProperties.IParameter};
    Row(1, strmatch('D Parameter',titles,'exact')) = {TrackingData.CantileverProperties.DParameter};
    %Ambient Parameters:
    Row(1, strmatch('Temp',titles,'exact')) = {TrackingData.AmbientParameters.Temperature};
    Row(1, strmatch('Humidity',titles,'exact')) = {TrackingData.AmbientParameters.Humidity};
    %Stimulus Magnitude:
    
    
end