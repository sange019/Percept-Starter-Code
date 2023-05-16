%% READ ME:
% 
% Written by Zachary Sanger, M.S.
% University of Minnesota 
% Biomedical Engineering Department
% May 16th, 2023

% INPUTS: This code requires a path which defines the location for whatever folder your data
% is stored. Filename can be changed to a structure if you plan to load
% multiple ".json" files.

% OUTPUTS: This code will output "datastruct" which is a MATLAB workable data structure of the entire report from
% the patient. The code will also output raw time data vectors for the left
% and right hemisphere of in clinic recordings. At home power time stamps and 10 minute averaged power vectors for each hemisphere will also be created.
% 
% PURPOSE: This code is a starter tool for someone beginning to analyze
% Medtronic Percept data.  This tool will help one extract workable data in
% the time domain from in-clinic and at home time domain recordings of LFP.
%
% IF YOU FEEL THERE ARE ERRORS, please reach out at sange019@umn.edu!
% please cite if you use the code
% 
% For informal use only, please double check your code for validity and proper implementation for your data:

%% Main Execute Function

clear;clc;close;

%reminder: pathways for MAC and Windows use different slashes.
% pathname='\Folder\Folder'; %data folder pathway Windows
% pathname='/Folder/Folder'; %data folder pathway MAC
% filename='[FILE].json'; %'.json' file (include extension)

comptype = 'MAC'; %'MAC' or 'PC'
datastruct = percept_loaddata(pathname,filename,comptype); %load raw data structure

%Within DataStruct 
% - Short Term/In Clinic Data is stored as BrainSenseTimeDomain
% - Long Term/At Home Data is stored as DiagnosticData

if(isfield(datastruct, 'BrainSenseTimeDomain')) %Is there any in clinic data in this file?

dataL = []; %declare variable for concatenation
dataR = []; %declare variable for concatenation
    for i = 1:2:height(datastruct.BrainSenseTimeDomain) %count and concatenate through all data chunks when recording was...
        % started and stopped either manually or automatically like a stimulation frequency change.
        % NOTE: It has been found that time delays may exist between start
        % and stops, accounting for these latencies may be important for
        % your analysis.
        dataL = [dataL;datastruct.BrainSenseTimeDomain(i).TimeDomainData]; %left is odd rows
        dataR = [dataR;datastruct.BrainSenseTimeDomain(i+1).TimeDomainData]; %right is even rows
    end   

fs = 250; %PERCEPT sampling rate is 250Hz - 250 samples per second
t = linspace(0,length(dataL)/fs,length(dataL)); %time vector: length in samples of the data/sampling rate

    figure
    plot(t,dataL); hold on %left hemisphere plot
    plot(t,dataR); hold off %right hemisphere plot
    title('Left & Right Hemisphere LFP Raw Data')
    ylabel('Voltage')
    xlabel('Time (seconds)')
    legend('Left','Right')
end

if(isfield(datastruct.DiagnosticData, 'LFPTrendLogs')) %Is there any at home data in this file?

    [LFPL, LFPR, DateTime] = percept_athomedata(datastruct) %function to extract at home LFP Power from datastruct

    % ------------NOTE--------------
    %DateTime value is in Greenwich time so you will need to adjust according to your
    %time zone.
    
    figure
    plot(DateTime,LFPL); hold on %left hemisphere plot
    plot(DateTime,LFPR); hold off %right hemisphere plot
    title('Left & Right At Home Power Raw Data')
    ylabel('Power')
    xlabel('Timestamp')
    legend('Left','Right')
end

