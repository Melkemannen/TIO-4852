% Make sure the script was called with the right number of arguments
clear;
clearAllMemoizedCaches;
clearvars;


if nargin != 4
    %print("Usage: octave make_plott.m <input_file> <variable_name> <output_file> \n all variables of form <variable_name>* will be used");
    input_file = "./output_files/data.mat";
    variable_name= "A3__measurment_dynamic_fixed";
    output_file = "./output_files/photo_combined.svg";
    struct_name = "concatinated_data";

else
        % Get the input and output file names from command-line arguments
input_file = argv(){1};
variable_name = argv(){2};
output_file = argv(){3};
struct_name = argv(){4};
endif
load(input_file);

eval([ 'data' '=' struct_name ';']);  % Assign the original struct to the new name

% Optionally, delete the old struct if you want to "rename" it
clear old_struct;

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
      if strncmp (variable_name ,keys{i}, length(variable_name))
          if strncmp (keys{i},"A" , 1)
            plot(time,data.(keys{i})./20, 'DisplayName', keys{i});
          end
          if strncmp (keys{i},"ultra" , 1)
            plot(time,data.(keys{i}),'DisplayName', (keys{i}));
          end
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

