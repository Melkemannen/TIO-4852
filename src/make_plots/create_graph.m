% Open the file for reading
fid = fopen('data.txt', 'r');

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

% Now plot the data
figure;

% Loop through each field in the structure and plot
keys = fieldnames(data);
numKeys = length(keys);

% Plot each key-value pair on the same graph
hold on;
for i = 1:numKeys
    plot(data.(keys{i}), '-o', 'DisplayName', keys{i});
end

% Add legend, title, labels
legend;
title('Sensor Values');
xlabel('Index');
ylabel('Value');

