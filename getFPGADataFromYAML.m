%%%% Function: Get FPGA Data From YAML
%  This function extracts the data from the FPGA.yaml file that has
%  data collected by HAWK from the FPGA. It converts the data to a
%  .mat file readble by Matlab.
%
%  params {directory} string, location where the data on the disk 
%  params {experimentTitle} string, name of the experiment
%  returns {Stimulus} struct, a structure of data represting the data from
%  the FPGA.
%
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%
%%%%%


function FPGAData = getFPGADataFromYAML(directory, experimentTitle)
    fpgaDataFilename = strcat(experimentTitle, '_FPGAdata.yaml');
    % Get FPGA Data:
    mat_file = fullfile(directory,strcat(experimentTitle,'_FPGAdata_parsedData.mat'));
    %if the data has already been read from the .yaml file, just load the mat
    %file created last time:
    if (exist(mat_file, 'file')==2)
        load(mat_file);
    else %otherwise, parse through .yaml file:
        %file to parse name (must be structured correctly)
        fpga_file = fullfile(directory, fpgaDataFilename);
        %If necessary, remove the first line of the yaml file.
        fid = fopen(fpga_file);
        firstLine = fgetl(fid);
        if (firstLine(1:9) == '%YAML:1.0')
            buffer = fread(fid,  Inf);
            fclose(fid);
            delete(fpga_file)
            fid = fopen(fpga_file, 'w')  ;   % Open destination file.
            fwrite(fid, buffer) ;                         % Save to file.
            fclose(fid) ;
        else
            fclose(fid);
        end
        %parse
        FPGAData = ReadYaml(fpga_file);
        %write file to .mat
        save(mat_file, 'FPGAData');
    end
end