%% READ ME:
% 
% Written by Zachary Sanger, M.S.
% University of Minnesota 
% Biomedical Engineering Department
% May 16th, 2023.

% IF YOU FEEL THERE ARE ERRORS, please reach out at sange019@umn.edu!
% please cite if you use the code
% 
% For informal use only, please double check your code for validity and proper implementation for your data:

%% Load .json Data Report in MATLAB

function [datastruct] = percept_loaddata(pathname,filename,comptype)

if(strcmp(comptype,'MAC'))
    slash = '/';
else
    slash = '\';
end

json = fileread([pathname,slash,filename]); %read in file
datastruct = jsondecode(json); %decode json formatted file

end
