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

%% FORMAT and Extract At home data within JSON Report

function [LFPL, LFPR, DateTime] = percept_athomedata(datastruct)

LFPL = [];
LFPR = [];
fields = fieldnames(datastruct.DiagnosticData.LFPTrendLogs.HemisphereLocationDef_Left); %define the fields due to format of this structure
NDays = length(fields); %length in days of long term recording based on "fields" which are basically date strings
count=1; %begin for loop counter

for i=1:NDays %count through days
    eval(['NSamp = length(datastruct.DiagnosticData.LFPTrendLogs.HemisphereLocationDef_Right.',fields{i},');']);
    for j=NSamp:-1:1 %steps through IN REVERSE within each day data structure regardless of dimensions.
        eval(['LFPLAmp = datastruct.DiagnosticData.LFPTrendLogs.HemisphereLocationDef_Left.',fields{i},'(',num2str(j),')','.LFP;']); %Left LFP Power measurement
        eval(['LFPRAmp = datastruct.DiagnosticData.LFPTrendLogs.HemisphereLocationDef_Right.',fields{i},'(',num2str(j),')','.LFP;']); %Right LFP Power measurement
        eval(['ThisDateTime = datastruct.DiagnosticData.LFPTrendLogs.HemisphereLocationDef_Right.',fields{i},'(',num2str(j),')','.DateTime;']); %DateTime
        
        %Decode Date String to Define Date and Time Components
        yr = str2num(ThisDateTime(1:4));
        mo = str2num(ThisDateTime(6:7));
        da = str2num(ThisDateTime(9:10));
        hr = str2num(ThisDateTime(12:13));
        mn = str2num(ThisDateTime(15:16));
        se = str2num(ThisDateTime(18:19));
        Time = datetime(yr, mo, da, hr, mn, se);
        PosixTime = convertTo(Time,'posix');
        time(count)=PosixTime;

        DateTime(count,1) = Time; %create vector of dates and times to match up LFP power
        LFPL(count) = LFPLAmp; %Left LFP Power
        LFPR(count) = LFPRAmp; %Right LFP Power
        count = count+1; %increase counter
    end
end