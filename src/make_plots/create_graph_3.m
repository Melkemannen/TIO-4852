% Make sure the script was called with the right number of arguments
clear;
clearAllMemoizedCaches;
clearvars;


if nargin != 3
    %print("Usage: octave make_plott.m <input_file> <variable_name> <output_file> \n all variables of form <variable_name>* will be used");
    input_folder = "./input_files/";
    output_folder = "./output_files/";

else
        % Get the input and output file names from command-line arguments
input_file = argv(){1};
variable_name = argv(){2};
output_file = argv(){3};
endif

% Get the input and output file names from command-line arguments

% Get the input and output file names from command-line arguments

%input_file = "measurment_dynamic___2025_03_12.txt";
%output_file = "out.svg";
% Open the file for reading
files= dir(fullfile(input_folder, '*.txt'));
concatinated_data= struct();
for i = 1:length(files)
    [~, name, ~] = fileparts(files(i).name);
    disp(name);
    % Get the full path to the file
    input_file = fullfile(input_folder, files(i).name);
    fid = fopen(input_file, 'r');
    if fid == -1
        error("Could not open input file: %s", input_file);
    end

    % Initialize a structure to store data for each key
    data = struct();

    % Loop through each line of the file
    while !feof(fid)
        line = fgetl(fid);  % Read each line

        % Regular expression to match the key-value pairs
        [matches, fields] = regexp(line, '([A-Za-z0-9_]+):([0-9\.]+)', 'tokens', 'match');

        % Loop through the matched key-value pairs
        for i = 1:length(matches)
            %key = matches{i}{1};
            key = strcat(matches{i}{1},"__",name);
            value = str2double(matches{i}{2});  % Convert the value to numeric

            % Store the values in the structure (create fields dynamically)
            if isfield(data, key)
                data.(key) = [data.(key); value];  % Append to existing data
            else
                data.(key) = value;  % Create new field for the key
            end
        end
    end

    % Close the file after reading
    fclose(fid);


    %clearvars

    % Create a figure to plot
    figure;

    % Loop through each field in the structure and plot
    keys = fieldnames(data);
    numKeys = length(keys);

    % Plot each key-value pair on the same graph
    hold on;
    grid on;
    set(gca, "linewidth", 4, "fontsize", 20)
    for i = 1:numKeys
      disp(keys{i});
      time = 0:0.1:(length(data.(keys{i}))-1)*0.1;
          if strncmp (keys{i},"A" , 1)
            plot(time,data.(keys{i})./20, 'DisplayName', keys{i});
          end
          if strncmp (keys{i},"ultra" , 1)
            plot(time,data.(keys{i}),'DisplayName', (keys{i}));
          end
    end

    % Add legend, title, labels
    legend;
    title('Sensor Values. photoresistors scaled by a factor 20');
    xlabel('time[S]');
    ylabel('Value');

    fields2 = fieldnames(data);
    for i = 1:length(fields2)
      concatinated_data.(fields2{i}) = data.(fields2{i});  % Add fields from struct2
    end
    % Save the plot as an SVG file

    print(strcat(output_folder,name,".svg"), '-dsvg');

    %disp(['Plot saved to: ' output_file]);
end
 save(strcat(output_folder,'data.mat'),'concatinated_data');
