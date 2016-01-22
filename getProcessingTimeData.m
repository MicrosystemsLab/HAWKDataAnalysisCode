
function TimingData = getProcessingTimeData(allText)

    nameIndex= strfind(allText,'name');
    ncallsIndex = strfind(allText,'ncalls');
    totalTimeIndex = strfind(allText,'totaltime');
    maxTimeIndex = strfind(allText,'maxtime');
    minTimeIndex = strfind(allText,'mintime');
    avgTimeIndex = strfind(allText,'avg time');
    numblownticsIndex = strfind(allText,'numblowntics');


    numfields = length(nameIndex);

    for fieldInd = 1:numfields

        superfield = allText(nameIndex(fieldInd)+6:ncallsIndex(fieldInd)-1);
        field = superfield(1:find(isletter(superfield) == 0,1,'first')-1);

        nCalls = str2double(allText(ncallsIndex(fieldInd)+8 : totalTimeIndex(fieldInd)-1));
        totalTime = str2double(allText(totalTimeIndex(fieldInd)+ 11: maxTimeIndex(fieldInd)-1));
        maxTime = str2double(allText(maxTimeIndex(fieldInd)+ 9 : minTimeIndex(fieldInd)-1));
        minTime = str2double(allText(minTimeIndex(fieldInd)+ 9 : avgTimeIndex(fieldInd)-1));
        avgTime = str2double(allText(avgTimeIndex(fieldInd)+ 10 : numblownticsIndex(fieldInd)-1));

        TimingData.([field]).nCalls = nCalls;
        TimingData.([field]).totalTime = totalTime;
        TimingData.([field]).maxTime = maxTime;
        TimingData.([field]).minTime = minTime;
        TimingData.([field]).avgTime = avgTime;
    end

end