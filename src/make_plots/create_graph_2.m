% Make sure the script was called with the right number of arguments
if nargin != 3
    error("Usage: octave make_plott.m <input_file> <variable_name> <output_file> \n all variables of form <variable_name>* will be used");
end

% Get the input and output file names from command-line arguments
input_file = argv(){1};
variable_name = argv(){2};
output_file = argv(){3};
%input_file = "measurment_dynamic___2025_03_12.txt";
%output_file = "out.svg";
% Open the file for reading
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
        key = matches{i}{1};  % e.g. 'A1', 'height_photoresistor'
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

% Create a figure to plot
figure;

% Loop through each field in the structure and plot
keys = fieldnames(data);
numKeys = length(keys);

% Plot each key-value pair on the same graph
hold on;
grid on;
for i = 1:numKeys
        if strncmp (keys{i},variable_name , 1)
        plot(data.(keys{i}), 'DisplayName', keys{i});
        end
end

% Add legend, title, labels
legend;
title('Sensor Values');
xlabel('Index');
ylabel('Value');

% Save the plot as an SVG file
print(output_file, '-dsvg');

disp(['Plot saved to: ' output_file]);

