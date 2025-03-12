% Make sure the script was called with the right number of arguments
%if nargin != 2
%    error("Usage: octave make_plott.m <input_file> <output_file>");
%end

% Get the input and output file names from command-line arguments
%input_file = argv(){1};
%output_file = argv(){2};
input_file = "measurment_dynamic___2025_03_12.txt";
output_file = "out.svg";
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
    [matches, fields] = regexp(line, '([A-Za-z_]+):([0-9\.]+)', 'tokens', 'match');

    % Loop through the matched key-value pairs
    for i = 1:length(matches)
        key = matches{i}{1};  % e.g. 'A1', 'height_photoresistor'
        value = str2double(matches{i}{2});  % Convert the value to numeric

        % Extract the base name (prefix) by removing numbers and special characters
        base_name = regexp(key, '^[A-Za-z]+', 'match', 'once');

        % Store the values in the structure (create fields dynamically based on key)
        if isfield(data, base_name)
            data.(base_name).keys = [data.(base_name).keys, key];  % Append the key name
            data.(base_name).values = [data.(base_name).values, value];  % Append the value
        else
            data.(base_name) = struct('keys', {key}, 'values', value);  % Create new structure for base name
        end
    end
end

% Close the file after reading
fclose(fid);

% Create a figure to plot
figure;

% Loop through each base name in the structure and plot each key separately
base_names = fieldnames(data);
numBaseNames = length(base_names);

% Plot each key within the same base name group
hold on;
for i = 1:numBaseNames
    % For each base name, plot all keys associated with it
    for j = 1:length(data.(base_names{i}).keys)
        % Access the key names and values using regular parentheses
        plot(data.(base_names{i}).values(j), '-o', 'DisplayName', data.(base_names{i}).keys(j));  % Correct indexing
    end
end

% Add legend, title, labels
legend;
title('Sensor Values Grouped by Prefix');
xlabel('Index');
ylabel('Value');

% Save the plot as an SVG file
print(output_file, '-dsvg');

disp(['Plot saved to: ' output_file]);

