% Make sure the script was called with the right number of arguments
clear;
clearAllMemoizedCaches;
clearvars;


if nargin != 4
    %print("Usage: octave make_plott.m <input_file> <variable_name> <output_file> \n all variables of form <variable_name>* will be used");
    input_file = "./output_files/data.mat";
    signal_name="A3";
    variable_names= {strcat(signal_name,"__measurment_dynamic_fixed___2025_03_12_1130"),
                     strcat(signal_name,"__measurment_dynamic_fixed___2025_03_12_1205"),
                     strcat(signal_name,"__measurment_dynamic_fixed___2025_03_12_1400"),
                     strcat(signal_name,"__measurment_dynamic_fixed___2025_03_12_1500"),
                     strcat(signal_name,"__measurment_dynamic_fixed___2025_03_12_1510")};

       output_file = strcat("./output_files/",signal_name,"__dynamic_fixed__cropped.svg");
    %datapoints = [56, 98, 142, 190, 271;
    %              65, 106, 150, 175, 222;
    %              1, 79, 108, 135, 172;
    %              4, 69,105, 124, 144;
    %              5, 35, 63, 90, 115];
    datapoints = [56, 98, 142, 188, 240;
                  65, 106, 150, 175, 222;
                  1, 79, 108, 135, 145;
                  4, 69,105, 124, 144;
                  5, 35, 63, 90, 115];

    %datapoints = [10, 30, 50, 70, 90;
    %              10, 30, 50, 70, 90;
    %              10, 30, 50, 70, 90;
    %              10, 30, 50, 70, 90;
    %              10, 30, 50, 70, 90];

    datapoints=datapoints.*10; % multiply to scale to 100ms
    datapoints=datapoints-10; %get the state a bit before
    datapoints(datapoints < 1) = 1;
    chunkSize=20*10;
    output_folder = "./output_files/";
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
    % Plot each key-value pair on the same graph
    hold on;
    grid on;
    set(gca, "linewidth", 1, "fontsize", 20)

    for i = 1:length(keys)
      %disp(keys{i});

      for j = 1:length(variable_names)
        disp(length(variable_names{j}));
        disp(keys{i});
        strncmp (variable_names(j) ,keys{i}, length(variable_names{j}))
        if strncmp (variable_names(j) ,keys{i}, length(variable_names{j}))
          _temporary=[];
          %disp(i);
          for k = 1:length(datapoints(j,:))
            _temporary = [_temporary ; data.(keys{i})(datapoints(j,k):datapoints(j,k)+chunkSize)];
            %disp(k);
          endfor

          %if strncmp (keys{i},"A" , 1)
          time = 0:0.1:(length(_temporary)-1)*0.1;
            dispName= keys{i};
            dispName= strcat(dispName(1:3),dispName(length(dispName)-4:length(dispName)));
            %latex does not like _
            dispName= strrep (dispName, "_", "-");
            plot(time,_temporary, 'DisplayName', dispName);
          %end
        endif
      endfor
    end

    % Add legend, title, labels
    legend('Location', 'southoutside', 'Interpreter', 'none','NumColumns', 2);
    title( strcat("cropped data of",' photoresistor ','-',signal_name));
    xlabel('time[S]');
    ylabel('Value');
    ylim([0,400]);

    % Save the plot as an SVG file
    yticks(0:50:400);
    xticks(0:chunkSize/10:400);
    xtickangle (45);
    %print(strcat(output_folder,name,".svg"), '-dsvg');
    print( output_file, '-dsvg');
    %disp(['Plot saved to: ' output_file]);
    %disp('Click on any data point to get the coordinates. Press Enter when done.');

% Use ginput to get mouse clicks
%[x_click, y_click] = ginput;

% Display the clicked points
%disp('You clicked on the following points:');
%disp([x_click, y_click]);


