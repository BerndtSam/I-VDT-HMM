classdef classificator_datafile_output_class <  eye_movements_records_class & ...       % Basic eye tracker data definitions
                                                classificator_enumerations_class & ...  % Basic enumerations definitions
                                                classificator_time_rate_class & ...     % Time step and sample rate deinitions and methods
                                                handle
    % This class is designed to output classified eye movement lists to
    % designated output files.
    % All you have to do is to provide filenames for output files. If
    % corresponding file name is empty then this file will not be created.
    % You can provide file names manually by setting up corresponding
    % property (saccade_records_output_filename) one by one.
    % Also you can setup common basename in basename_output_filename and
    % common extension in basename_output_extension and after execution
    % setup_output_filename all output filenames will be setting up to
    % common basename + siffux + common extension . Suffix is
    % _saccades_list for saccades, _fixation_list for fixations,
    % _noise_list for noise, and _pursuit_list for pursuit.

    properties (Hidden)
        saccade_records_output_filename = '';       % Full name for saccade data output file
        fixation_records_output_filename = '';      % Full name for fixation data output file
        noise_records_output_filename = '';         % Full name for noise data output file
        pursuit_records_output_filename = '';       % Full name for pursuit data output file
        basename_output_filename = '';              % This is full basename for output files
        basename_output_extension = '';             % This is common extension for output files
    end

    methods
% Some important functions
% This one set up all output names acording common base name and extension
        function setup_output_names(obj)
            obj.saccade_records_output_filename =   strcat(obj.basename_output_filename,'_saccades_list',obj.basename_output_extension);
            obj.fixation_records_output_filename =  strcat(obj.basename_output_filename,'_fixation_list',obj.basename_output_extension);
            obj.noise_records_output_filename =     strcat(obj.basename_output_filename,'_noise_list',obj.basename_output_extension);
            obj.pursuit_records_output_filename =   strcat(obj.basename_output_filename,'_pursuit_list',obj.basename_output_extension);
        end

% This function write all data to datafiles
        function write_datafiles(obj)
            if( obj.debug_mode ~= 0)
                fprintf(strcat('Begin output results in :',datestr(now),'\n'));
            end
            obj.calculate_delta_t();
% i = 1 mean that we work with saccades
% i = 2 mean that we work with fixations
% i = 3 mean that we work with noise
% i = 4 mean that we work with pursuits
            tmp_headers ={  'saccade number; onset time ms; amplitude degree; duration ms; onset coord X; onset coord Y; offset coord X; offset coord Y; [(coord_x, coord_y, sample_number); ...]\n',...
                            'fixation number; onset time ms; x coordinate; y coordinate; duration ms; [(coord_x, coord_y, sample_number); ...]\n',...
                            'noise number; onset time ms; duration ms\n',...
                            'saccade number; onset time ms; velocity degree/sec; duration ms; onset coord X; onset coord Y; offset coord X; offset coord Y; [(coord_x, coord_y, sample_number); ...]\n'};
            tmp_filenames = {obj.saccade_records_output_filename,obj.fixation_records_output_filename,obj.noise_records_output_filename, obj.pursuit_records_output_filename};
            tmp_lists = {obj.saccade_records, obj.fixation_records, obj.noise_records, obj.pursuit_records};
% For every list from our set
            for i=1:4
% That sheduled to output
                if ( ~isempty( char(tmp_filenames{i}) ) )
% We try to open output file
                    fd = fopen( char(tmp_filenames{i}) , 'wt');
                    if(fd ~= -1)
% If succeed then output header in it
                        fprintf(fd, char( tmp_headers{i} ));
                        current_list = tmp_lists{i};
                        for j=1:length(current_list)
                            current_records = current_list{j};
% Preparing necessary part for every kind of list
                            switch i
                                case 1
                                    saccade_amplitude_x =   max( current_records( :,obj.X_COORD ) ) - ...
                                                            min( current_records( :,obj.X_COORD ) );
                                    saccade_amplitude_y =   max( current_records( :,obj.Y_COORD ) ) - ...
                                                            min( current_records( :,obj.Y_COORD ) );
                                    onset_time_ms = current_records( 1,3) * obj.delta_t_sec * 1000;
                                    saccade_amplitude = sqrt ( saccade_amplitude_x^2 + saccade_amplitude_y^2);
                                    saccade_duration_ms = ( current_records(end,3) - current_records(1,3) ) * obj.delta_t_sec * 1000;
                                    onset_coord_x =     current_records( 1,obj.X_COORD );
                                    onset_coord_y =     current_records( 1,obj.Y_COORD );
                                    offset_coord_x =    current_records( end,obj.X_COORD );
                                    offset_coord_y =    current_records( end,obj.Y_COORD );
                                    fprintf(fd,'%i; %f; %f; %f; %f; %f; %f; %f',j, onset_time_ms,...
                                        saccade_amplitude, saccade_duration_ms, ...
                                        onset_coord_x, onset_coord_y, ...
                                        offset_coord_x, offset_coord_y);
                                case 2
                                    onset_time_ms = current_records( 1,3) * obj.delta_t_sec * 1000;
                                    fixation_coordinate_x = mean( current_records( :,obj.X_COORD) );
                                    fixation_coordinate_y = mean( current_records( :,obj.Y_COORD) );
                                    fixation_duration_ms = ( current_records( end,3) - current_records(1,3) ) * obj.delta_t_sec * 1000;
                                    fprintf(fd,'%i; %f; %f; %f; %f',j, onset_time_ms, ...
                                        fixation_coordinate_x, fixation_coordinate_y, fixation_duration_ms);
                                case 3
                                    noise_time_start = current_records( 1,3) * obj.delta_t_sec * 1000;
                                    noise_duration_ms = ( current_records( end,3) - current_records(1,3) ) * obj.delta_t_sec * 1000;
                                    fprintf(fd,'%i; %f; %f',j,...
                                        noise_time_start, noise_duration_ms);
                                case 4
                                    onset_time_ms = current_records( 1,3) * obj.delta_t_sec * 1000;
                                    smooth_pursuit_ms = ( current_records(end,3) - current_records(1,3) ) * obj.delta_t_sec * 1000;
                                    onset_coord_x =     current_records( 1,obj.X_COORD );
                                    onset_coord_y =     current_records( 1,obj.Y_COORD );
                                    offset_coord_x =    current_records( end,obj.X_COORD );
                                    offset_coord_y =    current_records( end,obj.Y_COORD );
                                    smooth_pursuit_velocity = sqrt( (onset_coord_x-offset_coord_x)^2 +...
                                                                    (onset_coord_y-offset_coord_y)^2 )/smooth_pursuit_ms;
                                    fprintf(fd,'%i; %f; %f; %f; %f; %f; %f; %f',j, onset_time_ms,...
                                        smooth_pursuit_velocity, smooth_pursuit_ms, ...
                                        onset_coord_x, onset_coord_y, ...
                                        offset_coord_x, offset_coord_y);
                            end

% Output eye trajectory
                            if( i ~= 3)
                                for k=1:size(current_records,1)
                                    fprintf(fd,'; (%f, %f, %i)',current_records(k,1), current_records(k,2), current_records(k,3) );
                                end
                            end
                            fprintf(fd,'\n');
                        end
                        fclose(fd);
                    end
                end
            end
            
            if( obj.debug_mode ~= 0)                
                fprintf(strcat('Complete output results in :',datestr(now),'\n'));
            end
        end

% Public access interface to class properties
        function set.saccade_records_output_filename(obj, value)
            obj.saccade_records_output_filename = value;
        end

        function set.fixation_records_output_filename(obj, value)
            obj.fixation_records_output_filename = value;
        end

        function set.noise_records_output_filename(obj, value)
            obj.noise_records_output_filename = value;
        end

        function set.pursuit_records_output_filename(obj, value)
            obj.pursuit_records_output_filename = value;
        end

        function set.basename_output_filename( obj, value)
            obj.basename_output_filename = value;
        end

        function set.basename_output_extension( obj, value)
            obj.basename_output_extension = value;
        end
    end
    
end
