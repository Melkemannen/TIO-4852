% Make sure the script was called with the right number of arguments
clear;
clearAllMemoizedCaches;
clearvars;


if nargin != 4
    %print("Usage: octave make_plott.m <input_file> <variable_name> <output_file> \n all variables of form <variable_name>* will be used");
    input_file = "./output_files/data.mat";
    %variable_name= "ultrasonic__measurment_dynamic_fixed___2025_03_12_1510";
    %variable="ultrasonic";
    variable="A1";
    variable_name=strcat(variable,"__measurment_dynamic_fixed___2025_03_26");
    output_file = strcat("./output_files/",variable_name,".svg");
    struct_name = "concatinated_data";
    output_folder="./output_files/";

else

        % Get the input and output file names from command-line arguments
input_file = argv(){1};
variable_name = argv(){2};
output_file = argv(){3};
struct_name = argv(){4};
endif
%             from to
datapoints = [1 , 50 ;
              89, 150;
              287, 365;
              471, 529;
              655, 727;
              %850, 904;
              %1027, 1070;
              ]
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
    set(gca, "linewidth", 1, "fontsize", 20)
    num_of_variables=0;
    meanPlot={};

    for i = 1:numKeys
      time = 0:0.1:(length(data.(keys{i}))-1)*0.1;
      if strncmp (variable_name ,keys{i}, length(variable_name));
            num_of_variables=num_of_variables+1;
            dispName= keys{i};
            dispName= dispName(length(variable_name)+1:length(dispName));
            dispName= strrep (dispName, "_", "-");
            plot(time,data.(keys{i}), 'DisplayName', dispName);
            data_variable=data.(keys{i});
            mean_values_array={};
            for j = 1:length(datapoints);
              mean_range=datapoints(j,1): datapoints(j,2);
              mean_value=mean(data_variable(mean_range));
              %string=strcat(dispName,"mean value is:",num2str(mean_value, '%.2f'));
              string=num2str(mean_value, '%.2f');
              mean_values_array{j} = (mean_value);
              disp(string);
            endfor
            meanPlot{num_of_variables}=mean_values_array;


      end
    end
        legend_handle= legend('Location', 'southoutside', 'Interpreter', 'none','NumColumns', 4);
    legend_handles_lines = findobj(legend_handle, 'Type', 'line');
set(legend_handles_lines, 'LineWidth', 20);
   % title(strcat(variable_name,'. photoresistors scaled by a factor 20'));
   plotName= variable;
   %plotName= "sonar";
    titleName= strcat("timedata of sensor-",plotName);
    title(titleName);
    xlabel('time [S]');
    ylabel('Resistance[Ohm]');

    % Save the plot as an SVG file
    %yticks(0:50:500);
    xticks(5:20:140);
    xtickangle (45);
    %print(strcat(output_folder,name,".svg"), '-dsvg');
    print( output_file, '-dsvg');



    figure;
    hold on;
    num_of_lines=length(meanPlot);
    j=0;
    numKeys
    for i = 1:numKeys
      time = 0:0.1:(length(data.(keys{i}))-1)*0.1;
      if strncmp (variable_name ,keys{i}, length(variable_name));
        j=j+1;
            num_of_variables=num_of_variables+1;
            dispName= keys{i};
            dispName= dispName(length(variable_name)+1:length(dispName));
            dispName= strrep (dispName, "_", "-");
            meanPlot{j}(1,:)
            plot([0,10,30,50,70],cell2mat(meanPlot{j}), 'DisplayName', dispName);




      end
    end
    %matrix_mean=cell2mat(meanPlot)
    meanPlot
    for i = 1:length(meanPlot{1})
      first_elements = [];
      for j = 1:length(meanPlot)
  % Extract the first element of each sub-element
    first_elements(end + 1) = meanPlot{j}{i};  % Access first element in each sub-cell
  end
      %first_elements
      std_value = std(first_elements);

      disp(std_value);
    end


    % Add legend, title, labels
    legend_handle= legend('Location', 'southoutside', 'Interpreter', 'none','NumColumns', 4);
    legend_handles_lines = findobj(legend_handle, 'Type', 'line');
set(legend_handles_lines, 'LineWidth', 20);
   % title(strcat(variable_name,'. photoresistors scaled by a factor 20'));
    titleName= strcat("mean value-",plotName);
    title(titleName);
    xlabel('time [S]');
    ylabel('Resistance[Ohm]');
   grid on;
    % Save the plot as an SVG file
    %yticks(0:50:500);
    xticks(10:20:100);
    xtickangle (45);
    strcat(output_folder,variable,"_mean_value.svg")
    print(strcat(output_folder,variable,"_mean_value.svg"), '-dsvg');
     %disp(['Plot saved to: ' output_file]);
    disp('Click on any data point to get the coordinates. Press Enter when done.');

% Use ginput to get mouse clicks
[x_click, y_click] = ginput;

% Display the clicked points
disp('You clicked on the following points:\n X   ,   Y');
disp([x_click, y_click]);


