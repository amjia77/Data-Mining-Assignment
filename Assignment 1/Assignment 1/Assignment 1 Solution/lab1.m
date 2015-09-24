clc
clear all

%% Read the Excel file
%Numbers variable contains all the numeric data in the Excel file
%Text contains only the text values
%AllData saves all the data numeric and text in cell format
%[Numbers,Text,allData]=xlsread('Book1.xls')

[Numbers,Text,allData]=xlsread('appmon_1.xls');

%%Initialization%

%%Find the column of the attribute, the following function will return the column
%number that contains the selected attribute
Column_number_mouseclicks= find(strcmp(allData(1,:),'mouseclicks'));
Column_number_keystrokes= find(strcmp(allData(1,:),'keystrokes'));
Column_number_mSec_from_start= find(strcmp(allData(1,:),'mSec from start'));
Column_number_focus_app_name= find(strcmp(allData(1,:),'focus_app_name'));
Column_number_focus_app_title= find(strcmp(allData(1,:),'focus_app_title'));
Column_number_opened_windows= find(strcmp(allData(1,:),'opened_windows'));
Column_number_mousemoves= find(strcmp(allData(1,:),'mousemoves'));
Column_number_start_time= find(strcmp(allData(1,:),'Start time'));


%Find the number of entries
total_number_of_rows= length(allData);

%Find the Start time in the excel sheet. The following function will return a double number representing the start time in MATLAB
Start_time = allData{2,Column_number_start_time};


% Add columns to accomodate new extracted features.
% Add Actual time feature
allData{1,Column_number_start_time+1}='Actual time';
allData{1,Column_number_start_time+2}='Window Switch';
allData{1,Column_number_start_time+3}='Number of opened Windows';
allData{1,Column_number_start_time+4}= 'Discretization of mousemoves';

%Save their column number
Column_number_Actual_time= find(strcmp(allData(1,:),'Actual time'));
Column_number_Window_Switch= find(strcmp(allData(1,:),'Window Switch'));

Column_number_number_opened_windows= find(strcmp(allData(1,:),'Number of opened Windows'));
Column_number_mousemoves2= find(strcmp(allData(1,:),'Discretization of mousemoves'));

%For each entry perform the requested 1-6 steps.

for i=2: total_number_of_rows % the entries starts at row 2. Row 1 is the title of each column.

 %1% If mouseclicks[i] > 200 it is an outlier and should be set to 0
    if(allData{i,Column_number_mouseclicks}>200)
        allData{i,Column_number_mouseclicks}= 0;
    end
     
 %2% If keystrokes[i] > 100 it is an outlier and should be set to 0
    if(allData{i,Column_number_keystrokes}>100)
        allData{i,Column_number_keystrokes}= 0;
    end
     
         
 %3% Extract the actual time at row i knowing that the experiment
    %started at 08:07:50 AM
    %The start time in Matlab can be read by (Start_time = allData{2,Column_number_start_time}) as a number of type double that
    %represents the fraction of the day and can be converted later to a desired
    %format 'HH:MM:SS AM or PM'
    % For instance 
    % the number 0 represents the time '12:00:00 AM'
    % the number 0.3388 represents the time '08:07:50 AM' according to the
    % following computations:
    % number of seconds equivalent to '08:07:50 AM'= 8*3600+ 7*60+50= 29270 sec
    % the number of seconds in 24 hours = 24*3600 = 86400 seconds
    % Thus, the ratio or the fraction of the day representing the time '08:07:50 AM' is equal to 29270/86400 = 0.3388  the number that was read by MATLAB from EXCEL. 
    % Accordingly the number of seconds from Start can be represented as a
    % fraction of the day and added to the above number (0.3388) representing
    % the start time.
    %The number will be then converted into the time format.
    
    duration_from_start= allData{i,Column_number_mSec_from_start};
    duration_from_start_fraction= duration_from_start/ 1000/(24*3600);
    Actual_time= Start_time + duration_from_start_fraction;
    allData{i,Column_number_Actual_time}=datestr(Actual_time,14); %format 'HH:MM:SS AM or PM'
    
    
    
 %4% Extract a Window Switch feature that is set to 1 is set to 1 whenever
    %focus_app_name[i]!= focus_app_name[i-1] and focus_app_title[i]!=
    %focus_app_title[i-1], and that is set to 0 otherwise.  
 
    %Assume the first row has a window switch=1; 
    if (i==2)
        allData{i,Column_number_Window_Switch}=1;
    else
        if( ~strcmp(allData(i, Column_number_focus_app_name), allData(i-1, Column_number_focus_app_name)) && ~strcmp(allData(i, Column_number_focus_app_title), allData(i-1, Column_number_focus_app_title)))
            allData{i,Column_number_Window_Switch}=1;
        else
            allData{i,Column_number_Window_Switch}=0;
        end
    end
    
    
 %5% Extract the number of opened windows, by parsing opened_windows[i]
    % The opened_window feature is a set if opened windows delimited by "|"
    % Thus, the number of opened windows will be equal to the number of "|" 

    allData{i,Column_number_number_opened_windows}= length(findstr(allData{i,Column_number_opened_windows},'|'));

 %6% Extract a (discretization) categorization of mousemoves[i] according to the following categories:
    %a.	No Move, if value is equal to 0 
    %b.	Slow, if value is greater than 0 and less than 36
    %c.	Moderate, if value is greater or equal to 36 and less than 55
    %d.	Fast, if value is greater or equal to 55

    % a. No moves, value equal 0
    if(allData{i,Column_number_mousemoves}==0) 
        allData{i,Column_number_mousemoves2}='No Move';
    end
    
    %b.	Slow, if value is greater than 0 and less than 36
    if(allData{i,Column_number_mousemoves}>0 && allData{i,Column_number_mousemoves}<36) 
        allData{i,Column_number_mousemoves2}='Slow';
    end
    
    %c.	Moderate, if value is greater or equal to 36 and less than 55
    if(allData{i,Column_number_mousemoves}>=36 && allData{i,Column_number_mousemoves}<55) 
        allData{i,Column_number_mousemoves2}='Moderate';
    end
    
    %d.	Fast, if value is greater or equal to 55
    if(allData{i,Column_number_mousemoves}>=55) 
        allData{i,Column_number_mousemoves2}='Fast';
    end
     
end
    

%% 7 %% Write new Excel file
Needed_Columns=[Column_number_mouseclicks, Column_number_keystrokes, Column_number_Actual_time, Column_number_Window_Switch, Column_number_number_opened_windows, Column_number_mousemoves2];

xlswrite('appmon_1_out.xls',allData(:,Needed_Columns))


