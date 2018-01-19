classdef scores_computation_bdt_class < classificator_enumerations_class & ...  % Basic enumerations definitions
                                    eye_records_class & ...                 % Basic eye tracker data definitions
                                    eye_movements_records_class & ...       % Basic lists definitions
                                    classificator_time_rate_class & ...     % Time step and sample rate definitions
                                    handle
    %This class contains basic methods and definitions for scores
    %computatioss
    
    %LAST MODIFIED: on 11/10/15 by John McAlmon
    %Fixed a syntax error relating to the textscan function.
    
    properties
% This properties store number of selected stimulus program. If it was not
% selected explicity then default stimulus will be used.
% 1 - stimulus that was used in the Technical Report Texas State University
%     San Marcos TXSTATE-CS-TR-2009-16. 
% 2 - stimulus that was used during June 2010 recording session for
%     horizontal saccades
% 3 - stimulus that was used during June 2010 recording session for
%     vertical saccades
% 4 - stimulus that was used during April 2011 recording session for
%     horizontal saccades
% 5 - stimulus that was used during April 2011 recording session for
%     vertical saccades
% 6 - stimulus that was used during June 2009 recording session for smooth
%     pursuits with speed 20 deg/sec
% 7 - stimulus that was used during June 2009 recording session for smooth
%     pursuits with speed 40 deg/sec
% 8 - stimulus that was used during June 2009 recording session for smooth
%     pursuits with speed 60 deg/sec
        selected_stimulus = 0;
    end
    
    properties (Hidden)
        stimulus_records;   % Two dimension array that hold down stimulus data.
                            % (i,1) - x coordinate
                            % (i,2) - y coordinate
                            % (i,3) - t coordinate
                            % (i,4) - eye movement type
        FQnS;               % This is the Fixation Quantitative Scrore
        FQlS;               % This is the Fixation Qualitative Score
        SQnS;               % This is the Saccade Quantitative Score
        AFD;                % Average fixation duration
        ANF;                % Average number of fixations - in our case just a number of fixations
        ASA;                % Average saccade amplitude
        ANS;                % Average number of saccade - in our case just a number of saccades
        PQnS;               % Pursuit Quantitaive Score
        APS;                % Average Pursuit Speed
        PFMS;               % Pursuit-fixation misclassification score - how much pursuits samples were classified as fixations
        FPMS;               % Fixation-Pursuit misclassification score - how much fixation samples were classified as pursuits
        PSMS;               % Pursuit-saccade misclassification score - how much pursuits samples were classified as saccades
        SPMS;               % Saccade-Pursuit misclassification score - how much saccade samples were classified as pursuits
        UQnS;               % Unclassified Quantitative Score - how much samples wasn't classified
        PQlS_P;             % Pursuit Qualitative Score (Position)
        PQlS_V;             % Pursuit Qualitative Score (Velocity)
        MisFix;
        AFN;
    end
    
    methods
% Draw a plot
        function draw_graphics(obj,draw_mode,plot_name)
            figure('Name',strcat('Plot for :',plot_name),'NumberTitle','off')
% Preparing a titile for figure
% 2D plots
            if( draw_mode == 1 || draw_mode == 2)
                if( draw_mode == 1 ), draw_coord = obj.X_COORD; elseif( draw_mode == 2), draw_coord = obj.Y_COORD; end

                hold on;
                grid on;
                xlabel('Sample sequential number');
                if( draw_mode == 1),  ylabel('X degree'); else ylabel('Y degree'); end

                plot(0,'--k');  % Stimuli
                plot(0,'--c');  % Eye tracker
                plot(0,'-y');   % Noise
                plot(0,'-b');   % Saccade
                plot(0,'-r');   % Fixation
                plot(0,'-k');   % Centroid
                plot(0,'g-');   % Pursuit

% Draw the stimulus
                if( ~isempty(obj.stimulus_records) ), plot(obj.stimulus_records(:,obj.X_COORD),'--k'); end;
% Draw our eye tracker data
                plot(obj.eye_records(:,draw_coord),'--c');

% Now draw classified data in 2D - time and x or y
                for i=1:length(obj.noise_records), plot(obj.noise_records{i}(:,3),obj.noise_records{i}(:,draw_coord),'-y'); end
                for i=1:length(obj.saccade_records), plot(obj.saccade_records{i}(:,3),obj.saccade_records{i}(:,draw_coord),'-b'); end

                for i=1:length(obj.fixation_records)
                    plot(obj.fixation_records{i}(:,3),obj.fixation_records{i}(:,draw_coord),'-r');
% Now we have to draw centroid of this saccade
                    centroid_coord = repmat(mean( obj.fixation_records{i}(:,draw_coord)) , length(obj.fixation_records{i}), 1);
                    plot(obj.fixation_records{i}(:,3),centroid_coord,'-k');
                end

                for i=1:length(obj.pursuit_records), plot(obj.pursuit_records{i}(:,3),obj.pursuit_records{i}(:,draw_coord),'g-');end

                legend('stimulus','eye tracker','noise','saccade','fixation','centroid', 'pursuit');
            elseif( draw_mode == 3 || draw_mode == 4 )

                axis square;
                plot3(0,0,0,'--k'), hold on;
                plot3(0,0,0,'--c');
                plot3(0,0,0,'-y');
                plot3(0,0,0,'-b');
                plot3(0,0,0,'-r');
                plot3(0,0,0,'-k');
                plot3(0,0,0,'--m');
                plot3(0,0,0,'g-');
                
                xlabel('Sample sequential number');
                if( draw_mode == 3), ylabel('Y degree'); else ylabel('Y degree / velocity'); end
                zlabel('X degree');

% Draw the stimulus
                if( ~isempty(obj.stimulus_records)), plot3(  obj.stimulus_records( :,3 ), obj.stimulus_records( :,obj.Y_COORD ), obj.stimulus_records( :,obj.X_COORD ), '--k'); end;
% Draw our eye tracker data
                plot3(  obj.eye_records( :,obj.DATA_FIELDS ), obj.eye_records( :,obj.Y_COORD ), obj.eye_records( :,obj.X_COORD ), '--c');
% Now draw classified data in 3D - time and x or y
% Noise records
                for i=1:length(obj.noise_records), plot3(  obj.noise_records{i}( :,3 ), obj.noise_records{i}( :,obj.Y_COORD ), obj.noise_records{i}( :,obj.X_COORD ), '-y'); end
% Saccade
                for i=1:length(obj.saccade_records), plot3(  obj.saccade_records{i}( :,3 ), obj.saccade_records{i}( :,obj.Y_COORD ), obj.saccade_records{i}( :,obj.X_COORD ), '-b'); end
% Fixation
                for i=1:length(obj.fixation_records)
                    plot3(  obj.fixation_records{i}( :,3 ), obj.fixation_records{i}( :,obj.Y_COORD ), obj.fixation_records{i}( :,obj.X_COORD ), '-r');
% Now we have to draw centroid of this saccade
                    centroid_x = zeros( length( obj.fixation_records{i} ),1);
                    centroid_x(:) = mean( obj.fixation_records{i}( :,obj.X_COORD) );
            
                    centroid_y = zeros( length( obj.fixation_records{i} ),1);
                    centroid_y(:) = mean( obj.fixation_records{i}( :,obj.Y_COORD) );
                    plot3(  obj.fixation_records{i}(:,3), centroid_y, centroid_x, '-k');
                end

                for i=1:length(obj.pursuit_records), plot3(  obj.pursuit_records{i}( :,3 ), obj.pursuit_records{i}( :,obj.Y_COORD ), obj.pursuit_records{i}( :,obj.X_COORD ), 'g-'); end

                if( draw_mode == 4 )
                    tmp_array = zeros( length(obj.eye_records),1 );
                    tmp_array(:) = 0;
                    plot3(  obj.eye_records( :,obj.DATA_FIELDS ), obj.eye_records( :,obj.VELOCITY ), tmp_array, '--m');

                    legend('stimulus','eye tracker','noise','saccade','fixation','centroid','velocity', 'pursuits');
                else
                    legend('stimulus','eye tracker','noise','saccade','fixation','centroid','pursuits');
                end

                hold off;

            end
        end
        
% This function intended to measure the scores for present stimulus
% recordings. These estimates can help to estimate the proper values for
% scores for actual eye records.
        function [ AFD ASA ANS APS ] = get_scores_for_stimulus(obj)
            AFD = 0; fixation_count = 0;
            ASA = 0; ANS = 0;
            APS = 0; pursuit_count = 0;
            obj.calculate_delta_t();

            i=1;
            while( i< length(obj.stimulus_records) )
% For fixations we have to calculate only Average Fixation Duration
                if( obj.stimulus_records( i, 4 ) == obj.FIXATION_TYPE )
                    fixation_count = fixation_count + 1;
                    while( i < length( obj.stimulus_records) && obj.stimulus_records( i, 4) == obj.FIXATION_TYPE )
                        AFD = AFD + obj.delta_t_sec;
                        i = i+1;
                    end
% For saccades we have to estimate Number of Saccades and Average Saccade
% Amplitude
                elseif( obj.stimulus_records( i, 4) == obj.SACCADE_TYPE )
                    ANS = ANS + 1;
                    min_x = obj.stimulus_records( i, 1 ); 
                    min_y = obj.stimulus_records( i, 2 );
                    max_x = obj.stimulus_records( i, 1 );
                    max_y = obj.stimulus_records( i, 2 );
                    while( i < length( obj.stimulus_records ) && obj.stimulus_records(i, 4) == obj.SACCADE_TYPE )
                        if( min_x > obj.stimulus_records( i, 1 ) ), min_x = obj.stimulus_records( i, 1 ); end
                        if( max_x < obj.stimulus_records( i, 1 ) ), max_x = obj.stimulus_records( i, 1 ); end
                        if( min_y > obj.stimulus_records( i, 2 ) ), min_y = obj.stimulus_records( i, 2 ); end
                        if( max_y < obj.stimulus_records( i, 2 ) ), max_y = obj.stimulus_records( i, 2 ); end
                        i = i+1;
                    end
                    ASA = ASA + sqrt( (max_x - min_x)^2 + (max_y - min_y)^2 );
% For pursuit we have to estimate only Average Pursuit Speed
                elseif( obj.stimulus_records( i, 4 ) == obj.PURSUIT_TYPE )
                    pursuit_count = pursuit_count + 1;    
                    current_distance = 0;
                    current_time = 0;
                    while( i < length( obj.stimulus_records ) && obj.stimulus_records( i, 4 ) == obj.PURSUIT_TYPE )
                        current_distance = current_distance +...
                                            (   (obj.stimulus_records( i, 1 ) - obj.stimulus_records( i-1, 1 ))^2 +...
                                                (obj.stimulus_records( i, 2 ) - obj.stimulus_records( i-1, 2 ))^2);
                        current_time = current_time + obj.delta_t_sec;
                        i = i+1;
                    end
                    if( current_time > 0 ), APS = APS + current_distance / current_time; end;
                else i=i+1;
                end
            end

            if( fixation_count > 0), AFD = AFD / fixation_count; end
            if( ANS > 0 ), ASA = ASA / ANS; end
            if( pursuit_count > 0), APS = APS / pursuit_count; end
        end

% This function intended to read the stimulus data from the input dataset.
% For example, it can be used to read stimulus data from the same file as
% eye tracker data
        function read_stimulus_data(obj, filename, x_coord, y_coord, header_lines, fields_count)
            fd = fopen( filename, 'rt' );
            if( fd~= -1 )
                while( header_lines ), fgetl(fd); header_lines = header_lines - 1; end;
                format_string = '%f';
                for i=2:fields_count, format_string = strcat(format_string,' %f');end
                all_data = textscan(fd,format_string,'Delimiter',' :','MultipleDelimsAsOne',1);
                obj.stimulus_records = zeros( length(all_data{1}), 4);
                obj.stimulus_records( :, 1 ) = all_data{ x_coord };
                obj.stimulus_records( :, 2 ) = all_data{ y_coord };
                obj.stimulus_records( :, 3 ) = 1:size( obj.stimulus_records, 1 );
                for i=2:size( obj.stimulus_records, 1 )
                    jump = sqrt(    ( obj.stimulus_records( i, 1) - obj.stimulus_records( i-1, 1) )^2 +...
                                    ( obj.stimulus_records( i, 2) - obj.stimulus_records( i-1, 2) )^2 );
                    if( jump == 0 ), obj.stimulus_records( i-1:i, 4 ) = obj.FIXATION_TYPE;
                    else obj.stimulus_records( i-1:i, 4 ) = obj.PURSUIT_TYPE;
                    end
                end
                for i=2:size( obj.stimulus_records, 1 )
                    jump = sqrt(    ( obj.stimulus_records( i, 1) - obj.stimulus_records( i-1, 1) )^2 +...
                                    ( obj.stimulus_records( i, 2) - obj.stimulus_records( i-1, 2) )^2 );
                    if( jump > 3 ), obj.stimulus_records( i-1:i, 4 ) = obj.SACCADE_TYPE; end
                end
                obj.stimulus_records( 1, 4 ) = obj.stimulus_records( 2, 4 );
                fclose( fd );
            end
        end
        
% Generator of stimulus #1. Detailed description given in the Technical
% Report Texas State University - San Marcos TXSTATE-CS-TR-2009-16.
        function generate_stimulus_CS_TR_2009_16(obj)
            obj.stimulus_records = zeros(1800,4);
% Generating initial position 0 - 120 (0;0);
            obj.stimulus_records(1:120,1) = 0;
            obj.stimulus_records(1:120,2) = 0;
            obj.stimulus_records(1:120,3) = 1:120;
            obj.stimulus_records(1:120,4) = obj.FIXATION_TYPE;
% Generating jumps
            current_stimulus_position = -10;
            for i=120:120:1680
                obj.stimulus_records(i:i+119,1) = current_stimulus_position;
                obj.stimulus_records(i:i+119,2) = 0;
                obj.stimulus_records(i:i+119,3) = i:i+119;
                obj.stimulus_records(i:i+119,4) = obj.FIXATION_TYPE;
                current_stimulus_position = -current_stimulus_position;
            end
% Adding saccades
            for i=1:1799
                if( obj.stimulus_records(i,1) ~= obj.stimulus_records(i+1,1) )
                    obj.stimulus_records( i,4 ) =   obj.SACCADE_TYPE;
                    obj.stimulus_records( i+1,4 ) = obj.SACCADE_TYPE;
                end
            end
        end

% Just a moc function for quick call for needed function
        function generate_current_stimulus_1000Hz(obj)
            switch obj.selected_stimulus
                case 1
                    obj.generate_stimulus_1000();
                case 2
                    obj.generate_stimulus_RS_June_2010_H();
                case 3
                    obj.generate_stimulus_RS_June_2010_V();
                case 4
                    obj.generate_stimulus_RS_April_2011_H();
                case 5
                    obj.generate_stimulus_RS_April_2011_V();
                case 6
                    obj.generate_stimulus_PR_2009_20();
                case 7
                    obj.generate_stimulus_PR_2009_40();
                case 8
                    obj.generate_stimulus_PR_2009_60();
                otherwise
                    obj.generate_stimulus_RS_June_2010_V();
            end
        end

% Generator of stimulus #2. Detailed description given in the Technical
% Report Texas State University - San Marcos TXSTATE-CS-TR-2009-16.
        function generate_stimulus_1000(obj)
            obj.stimulus_records = zeros(51096,3);
% Generating initial position 0 - 1000 (0;0);
            obj.stimulus_records(1:1000,1) = 0;
            obj.stimulus_records(1:1000,2) = 0;
            obj.stimulus_records(1:1000,3) = 1:1000;
            obj.stimulus_records(1:1000,4) = obj.FIXATION_TYPE;
% Generating jumps
            current_stimulus_position = 10;
            for i=1001:1000:51096
                obj.stimulus_records(i:i+999,1) = current_stimulus_position;
                obj.stimulus_records(i:i+999,2) = 0;
                obj.stimulus_records(i:i+999,3) = i:i+999;
                obj.stimulus_records(i:i+999,4) = obj.FIXATION_TYPE;
                current_stimulus_position = -current_stimulus_position;
            end
            obj.stimulus_records(i:end,1) = -current_stimulus_position;
            obj.stimulus_records(i:end,2) = 0;
            obj.stimulus_records(i:end,3) = i:length(obj.stimulus_records);
            obj.stimulus_records(i:end,4) = obj.FIXATION_TYPE;
            
% Adding saccades
            for i=1000:1000:51000
                obj.stimulus_records( i,4 ) =   obj.SACCADE_TYPE;
                obj.stimulus_records( i+1,4 ) = obj.SACCADE_TYPE;
            end
        end

% Generator of stimulus #3. Generate stimulus suitable for horizontal
% saccades that was recorded during June 2010 recording session.
        function generate_stimulus_RS_June_2010_H( obj )
            obj.stimulus_records = zeros(100000,4);
% Generating initial position - 1000 (0;0)
            obj.stimulus_records( 1:1000, 1 ) = 0;
            obj.stimulus_records( 1:1000, 2 ) = 0;
            obj.stimulus_records( 1:1000, 3 ) = 1:1000;
            obj.stimulus_records( 1:1000, 4 ) = obj.FIXATION_TYPE;
% Generating saccades
            current_mark_position = 10;
            for i=1001:1000:100000
                obj.stimulus_records( i:i+999, 1 ) = current_mark_position;
                obj.stimulus_records( i:i+999, 2 ) = 0;
                obj.stimulus_records( i:i+999, 3 ) = i:i+999;
                obj.stimulus_records( i:i+999, 4 ) = obj.FIXATION_TYPE;
                current_mark_position = -current_mark_position;
            end
            obj.stimulus_records( i:i+999, 1 ) = -current_mark_position;
            obj.stimulus_records( i:i+999, 2 ) = 0;
            obj.stimulus_records( i:i+999, 3 ) = i:length( obj.stimulus_records );
            obj.stimulus_records( i:i+999, 4 ) = obj.FIXATION_TYPE;

            % Adding saccades
            for i=1000:1000:100000
                obj.stimulus_records( i,4 ) =   obj.SACCADE_TYPE;
                obj.stimulus_records( i+1,4 ) = obj.SACCADE_TYPE;
            end
        end

% Generator of stimulus #4. Generate stimulus suitable for vertical
% saccades that was recorded during June 2010 recording session.
        function generate_stimulus_RS_June_2010_V( obj )
            obj.stimulus_records = zeros(100000,4);
% Generating initial position - 1000 (0;0)
            obj.stimulus_records( 1:1000, 1 ) = 0;
            obj.stimulus_records( 1:1000, 2 ) = 0;
            obj.stimulus_records( 1:1000, 3 ) = 1:1000;
            obj.stimulus_records( 1:1000, 4 ) = obj.FIXATION_TYPE;
% Generating saccades
            current_mark_position = 10;
            for i=1001:1000:100000
                obj.stimulus_records( i:i+999, 1 ) = current_mark_position;
                obj.stimulus_records( i:i+999, 2 ) = 0;
                obj.stimulus_records( i:i+999, 3 ) = i:i+999;
                obj.stimulus_records( i:i+999, 4 ) = obj.FIXATION_TYPE;
                current_mark_position = -current_mark_position;
            end
            obj.stimulus_records( i:i+999, 1 ) = -current_mark_position;
            obj.stimulus_records( i:i+999, 2 ) = 0;
            obj.stimulus_records( i:i+999, 3 ) = i:length( obj.stimulus_records );
            obj.stimulus_records( i:i+999, 4 ) = obj.FIXATION_TYPE;

            % Adding saccades
            for i=1000:1000:100000
                obj.stimulus_records( i,4 ) =   obj.SACCADE_TYPE;
                obj.stimulus_records( i+1,4 ) = obj.SACCADE_TYPE;
            end
        end

% Generator of stimulus #5. Generate stimulus suitable for horizontal
% saccades that was recorded during April 2011 recording session.
        function generate_stimulus_RS_April_2011_H( obj )
            obj.stimulus_records = zeros(100000,4);
% Generating initial position - 1000 (0;0)
            obj.stimulus_records( 1:1000, 1 ) = 0;
            obj.stimulus_records( 1:1000, 2 ) = 0;
            obj.stimulus_records( 1:1000, 3 ) = 1:1000;
            obj.stimulus_records( 1:1000, 4 ) = obj.FIXATION_TYPE;
% Generating saccades
            current_mark_position = 15;
            for i=1001:1000:100000
                obj.stimulus_records( i:i+999, 1 ) = current_mark_position;
                obj.stimulus_records( i:i+999, 2 ) = 0;
                obj.stimulus_records( i:i+999, 3 ) = i:i+999;
                obj.stimulus_records( i:i+999, 4 ) = obj.FIXATION_TYPE;
                current_mark_position = -current_mark_position;
            end
            obj.stimulus_records( i:i+999, 1 ) = -current_mark_position;
            obj.stimulus_records( i:i+999, 2 ) = 0;
            obj.stimulus_records( i:i+999, 3 ) = i:length( obj.stimulus_records );
            obj.stimulus_records( i:i+999, 4 ) = obj.FIXATION_TYPE;

            % Adding saccades
            for i=1000:1000:100000
                obj.stimulus_records( i,4 ) =   obj.SACCADE_TYPE;
                obj.stimulus_records( i+1,4 ) = obj.SACCADE_TYPE;
            end
        end

% Generator of stimulus #6. Generate stimulus suitable for vertical
% saccades that was recorded during April 2011 recording session.
        function generate_stimulus_RS_April_2011_V( obj )
            obj.stimulus_records = zeros(100000,4);
% Generating initial position - 1000 (0;0)
            obj.stimulus_records( 1:1000, 1 ) = 0;
            obj.stimulus_records( 1:1000, 2 ) = 0;
            obj.stimulus_records( 1:1000, 3 ) = 1:1000;
            obj.stimulus_records( 1:1000, 4 ) = obj.FIXATION_TYPE;
% Generating saccades
            current_mark_position = 10;
            for i=1001:1000:100000
                obj.stimulus_records( i:i+999, 1 ) = current_mark_position;
                obj.stimulus_records( i:i+999, 2 ) = 0;
                obj.stimulus_records( i:i+999, 3 ) = i:i+999;
                obj.stimulus_records( i:i+999, 4 ) = obj.FIXATION_TYPE;
                current_mark_position = -current_mark_position;
            end
            obj.stimulus_records( i:i+999, 1 ) = -current_mark_position;
            obj.stimulus_records( i:i+999, 2 ) = 0;
            obj.stimulus_records( i:i+999, 3 ) = i:length( obj.stimulus_records );
            obj.stimulus_records( i:i+999, 4 ) = obj.FIXATION_TYPE;

            % Adding saccades
            for i=1000:1000:100000
                obj.stimulus_records( i,4 ) =   obj.SACCADE_TYPE;
                obj.stimulus_records( i+1,4 ) = obj.SACCADE_TYPE;
            end
        end

% Generator of stimulus %7. Generate stimulus suitable for smooth pursuit
% that was recorded during June 2009.
        function generate_stimulus_PR_2009_20( obj)
            FIX_LEN = 170;
            PUR_LEN = 220;
            obj.stimulus_records = zeros(3870,4);

% Generating fixations
            current_mark_position = -9;
            for i=300:FIX_LEN+PUR_LEN:3600
                obj.stimulus_records( i:i+FIX_LEN, 1 ) = current_mark_position;
                obj.stimulus_records( i:i+FIX_LEN, 2 ) = 0;
                obj.stimulus_records( i:i+FIX_LEN, 3 ) = i:i+FIX_LEN;
                obj.stimulus_records( i:i+FIX_LEN, 4 ) = obj.FIXATION_TYPE;
                current_mark_position = -current_mark_position;
            end

% Adding pursuits.
            current_mark_position = 9;
            future_mark_position = -current_mark_position;
            for i=300-PUR_LEN-FIX_LEN:FIX_LEN+PUR_LEN:3500
                start_pos = i+FIX_LEN;
                end_pos = i+FIX_LEN+PUR_LEN;
                delta = (future_mark_position - current_mark_position) / ( end_pos - start_pos );
                for j=start_pos:end_pos
                    obj.stimulus_records( j, 1 ) = current_mark_position+delta*(j-start_pos);
                    obj.stimulus_records( j, 2 ) = 0;
                    obj.stimulus_records( j, 3 ) = j;
                    obj.stimulus_records( j, 4 ) = obj.PURSUIT_TYPE;
                end
                current_mark_position = -current_mark_position;
                future_mark_position = -future_mark_position;
            end

% Generating initital fixation - 210 (0;0)
            obj.stimulus_records( 1:210, 1 ) = 0;
            obj.stimulus_records( 1:210, 2 ) = 0;
            obj.stimulus_records( 1:210, 3 ) = 1:210;
            obj.stimulus_records( 1:210, 4 ) = obj.FIXATION_TYPE;

% Last fixation
            obj.stimulus_records( 3700:3870, 1 ) = 0;
            obj.stimulus_records( 3700:3870, 2 ) = 0;
            obj.stimulus_records( 3700:3870, 3 ) = 3700:3870;
            obj.stimulus_records( 3700:3870, 4 ) = obj.FIXATION_TYPE;
        end
        
        
% Generator of stimulus %8. Generate stimulus suitable for smooth pursuit
% that was recorded during June 2009.
        function generate_stimulus_PR_2009_40( obj)
            FIX_LEN = 155;
            PUR_LEN = 130;
            obj.stimulus_records = zeros(2925,4);

% Generating fixations
            current_mark_position = -9;
            for i=260:FIX_LEN+PUR_LEN:2760
                obj.stimulus_records( i:i+FIX_LEN, 1 ) = current_mark_position;
                obj.stimulus_records( i:i+FIX_LEN, 2 ) = 0;
                obj.stimulus_records( i:i+FIX_LEN, 3 ) = i:i+FIX_LEN;
                obj.stimulus_records( i:i+FIX_LEN, 4 ) = obj.FIXATION_TYPE;
                current_mark_position = -current_mark_position;
            end

% Adding pursuits.
            current_mark_position = 9;
            future_mark_position = -current_mark_position;
            for i=260-PUR_LEN-FIX_LEN:FIX_LEN+PUR_LEN:2760
                start_pos = i+FIX_LEN;
                end_pos = i+FIX_LEN+PUR_LEN;
                delta = (future_mark_position - current_mark_position) / ( end_pos - start_pos );
                for j=start_pos:end_pos
                    obj.stimulus_records( j, 1 ) = current_mark_position+delta*(j-start_pos);
                    obj.stimulus_records( j, 2 ) = 0;
                    obj.stimulus_records( j, 3 ) = j;
                    obj.stimulus_records( j, 4 ) = obj.PURSUIT_TYPE;
                end
                current_mark_position = -current_mark_position;
                future_mark_position = -future_mark_position;
            end

% Generating initital fixation - 210 (0;0)
            obj.stimulus_records( 1:200, 1 ) = 0;
            obj.stimulus_records( 1:200, 2 ) = 0;
            obj.stimulus_records( 1:200, 3 ) = 1:200;
            obj.stimulus_records( 1:200, 4 ) = obj.FIXATION_TYPE;

% Last fixation
            obj.stimulus_records( 2760:2925, 1 ) = 0;
            obj.stimulus_records( 2760:2925, 2 ) = 0;
            obj.stimulus_records( 2760:2925, 3 ) = 2760:2925;
            obj.stimulus_records( 2760:2925, 4 ) = obj.FIXATION_TYPE;
        end
        
        
        
        
% Generator of stimulus %9. Generate stimulus suitable for smooth pursuit
% that was recorded during June 2009.
        function generate_stimulus_PR_2009_60( obj)
            FIX_LEN = 160;
            PUR_LEN = 90;
            obj.stimulus_records = zeros(2625,4);

% Generating fixations
            current_mark_position = -9;
            for i=250:FIX_LEN+PUR_LEN:2450
                obj.stimulus_records( i:i+FIX_LEN, 1 ) = current_mark_position;
                obj.stimulus_records( i:i+FIX_LEN, 2 ) = 0;
                obj.stimulus_records( i:i+FIX_LEN, 3 ) = i:i+FIX_LEN;
                obj.stimulus_records( i:i+FIX_LEN, 4 ) = obj.FIXATION_TYPE;
                current_mark_position = -current_mark_position;
            end

% Adding pursuits.
            current_mark_position = 9;
            future_mark_position = -current_mark_position;
            for i=250-PUR_LEN-FIX_LEN:FIX_LEN+PUR_LEN:2455
                start_pos = i+FIX_LEN;
                end_pos = i+FIX_LEN+PUR_LEN;
                delta = (future_mark_position - current_mark_position) / ( end_pos - start_pos );
                for j=start_pos:end_pos
                    obj.stimulus_records( j, 1 ) = current_mark_position+delta*(j-start_pos);
                    obj.stimulus_records( j, 2 ) = 0;
                    obj.stimulus_records( j, 3 ) = j;
                    obj.stimulus_records( j, 4 ) = obj.PURSUIT_TYPE;
                end
                current_mark_position = -current_mark_position;
                future_mark_position = -future_mark_position;
            end

% Generating initital fixation - 200 (0;0)
            obj.stimulus_records( 1:200, 1 ) = 0;
            obj.stimulus_records( 1:200, 2 ) = 0;
            obj.stimulus_records( 1:200, 3 ) = 1:200;
            obj.stimulus_records( 1:200, 4 ) = obj.FIXATION_TYPE;

% Last fixation
            obj.stimulus_records( 2455:2625, 1 ) = 0;
            obj.stimulus_records( 2455:2625, 2 ) = 0;
            obj.stimulus_records( 2455:2625, 3 ) = 2455:2625;
            obj.stimulus_records( 2455:2625, 4 ) = obj.FIXATION_TYPE;
        end


% Calculating PQlS_P
        function result = get.PQlS_P( obj )
            result = 0;
            count_points = 0;
            for i=1:length( obj.pursuit_records )
                for j=1:size( obj.pursuit_records{i}, 1 )
                    if( obj.pursuit_records{i}(j, 3) <= length( obj.stimulus_records ) )
                        if( obj.stimulus_records( obj.pursuit_records{i}(j, 3), 4 ) == obj.PURSUIT_TYPE )
                            count_points = count_points + 1;
                            result = result + sqrt( ( obj.eye_records( obj.pursuit_records{i}(j,3), obj.X_COORD ) - obj.stimulus_records( obj.pursuit_records{i}(j,3), obj.X_COORD ) )^2 +...
                                                    ( obj.eye_records( obj.pursuit_records{i}(j,3), obj.Y_COORD ) - obj.stimulus_records( obj.pursuit_records{i}(j,3), obj.Y_COORD ) )^2 );
                        end
                    end
                end
            end
            if( count_points ~= 0), result = result / count_points;
            else result = nan;
            end
        end

% Calculating PQlS_V
        function result = get.PQlS_V( obj )
            result = 0;
            count_points = 0;
            obj.calculate_delta_t();
            for i=1:length( obj.pursuit_records )
                for j=1:size( obj.pursuit_records{i}, 1 )-1
                    if( obj.pursuit_records{i}(j+1, 3) <= length( obj.stimulus_records ))
                        if( obj.stimulus_records( obj.pursuit_records{i}(j, 3), 4 ) == obj.PURSUIT_TYPE && ...
                            obj.stimulus_records( obj.pursuit_records{i}(j+1, 3), 4 ) == obj.PURSUIT_TYPE)
                            count_points = count_points + 1;

                            stimulus_speed = sqrt( ( obj.stimulus_records( obj.pursuit_records{i}(j,3), obj.X_COORD ) - obj.stimulus_records( obj.pursuit_records{i}(j+1,3), obj.X_COORD ) )^2 + ...
                                                   ( obj.stimulus_records( obj.pursuit_records{i}(j,3), obj.Y_COORD ) - obj.stimulus_records( obj.pursuit_records{i}(j+1,3), obj.Y_COORD ) )^2 );
                            recorded_speed = sqrt( ( obj.eye_records( obj.pursuit_records{i}(j,3), obj.X_COORD ) - obj.eye_records( obj.pursuit_records{i}(j+1,3), obj.X_COORD ) )^2 + ...
                                                   ( obj.eye_records( obj.pursuit_records{i}(j,3), obj.Y_COORD ) - obj.eye_records( obj.pursuit_records{i}(j+1,3), obj.Y_COORD ) )^2 );

                            result = result + abs( stimulus_speed / obj.delta_t_sec - recorded_speed / obj.delta_t_sec );
                        end
                    end
                end
            end
            if( count_points ~= 0), result = result / count_points;
            else result = nan;
            end
        end
            

% Calculating amount of stimulus fixation points
        function result = get_stimulus_fixation_points(obj)
            result = 0;
            for i=1:length(obj.stimulus_records), if( obj.stimulus_records(i,4) == obj.FIXATION_TYPE), result = result + 1; end; end
        end

% Calculating amount of stimulus fixation points
        function result = get_stimulus_pursuit_points(obj)
            result = 0;
            for i=1:length(obj.stimulus_records), if( obj.stimulus_records(i,4) == obj.PURSUIT_TYPE), result = result + 1; end; end
        end

% Calculate number of samples that wasn't classified at all
       function result = get.UQnS( obj )
           result = 0;
           for i=1:length(obj.eye_records)
               %if( obj.eye_records( i, obj.VALIDITY ) == obj.DATA_VALID && obj.eye_records( i, obj.MOV_TYPE ) == obj.NOISE_TYPE )
               if( obj.eye_records( i, obj.MOV_TYPE ) == obj.NOISE_TYPE )
                   result = result + 1;
               end
           end
           result = result / length( obj.eye_records) * 100;
       end

% Calculate percentage of how much pursuit samples were classified as
% fixations
        function result = get.PFMS( obj )
            result = 0;
            for i=1:length(obj.fixation_records)
                for j=1:size( obj.fixation_records{i}, 1 )
                    if( obj.fixation_records{i}(j,3) <= size( obj.stimulus_records, 1 ) )
                        if( obj.stimulus_records( obj.fixation_records{i}(j,3), 4 ) == obj.PURSUIT_TYPE ), result = result + 1; end;
                    end
                end
            end
            result = 100 * result / obj.get_stimulus_pursuit_points;
        end

% Calculate percentage of how much fixation samples were classified as
% pursuits
        function result = get.FPMS( obj )
            result = 0;
            for i=1:length(obj.pursuit_records)
                for j=1:size( obj.pursuit_records{i}, 1 )
                    if( obj.pursuit_records{i}(j,3) <= size( obj.stimulus_records, 1 ) )
                        if( obj.stimulus_records( obj.pursuit_records{i}(j,3), 4 ) == obj.FIXATION_TYPE ), result = result + 1; end;
                    end
                end
            end
            result = 100 * result / obj.get_stimulus_fixation_points;
        end

        function result = get.MisFix( obj )
            result = obj.FPMS;
        end

% Calculating amount of stimulus fixation points
        function result = get_stimulus_saccade_points(obj)
            result = 0;
            for i=1:length(obj.stimulus_records)
                if( obj.stimulus_records(i,4) == obj.SACCADE_TYPE)
                    result = result + 1;
                end
            end
        end
        
% Calculate percentage of how much saccade samples were classified as
% pursuits
        function result = get.SPMS( obj )
            result = 0;
            total_saccades_points = 0;
            for i=1:length(obj.stimulus_records)-1
% Searching saccades in stimuli signal
                if( obj.stimulus_records(i,4) == obj.SACCADE_TYPE && obj.stimulus_records(i-1,4) ~= obj.SACCADE_TYPE ), saccade_start = i; end;
                if( obj.stimulus_records(i,4) == obj.SACCADE_TYPE && obj.stimulus_records(i+1,4) == obj.SACCADE_TYPE )
% For every saccade that we was able to find
                    saccade_end = i;
% Determine amplitude
                    saccade_amplitude = sqrt(   ( obj.stimulus_records( saccade_start, obj.X_COORD) - obj.stimulus_records( saccade_end, obj.X_COORD) )^2 + ...
                                                ( obj.stimulus_records( saccade_start, obj.Y_COORD) - obj.stimulus_records( saccade_end, obj.Y_COORD) )^2 );
% And onset and offset times
                    %theory_onset = saccade_start + 200;
                    theory_onset = saccade_start - 500;
                    %theory_offset = saccade_start + 200 + 2.2*saccade_amplitude + 21;
                    theory_offset = saccade_start + 500;
% Now we should check every sample inside of saccade time range
                    for j=saccade_end+1:length(obj.eye_records)
                        if( theory_onset <= obj.eye_records( j, obj.T_COORD ) && obj.eye_records( j, obj.T_COORD ) <= theory_offset )
                            total_saccades_points = total_saccades_points + 1;
                            if( obj.eye_records( j, obj.MOV_TYPE ) == obj.PURSUIT_TYPE ), result = result + 1; end
                        end
                    end
                end;
            end
            result = 100 * result / total_saccades_points;
        end

% Calculate percentage of how much pursuit samples were classified as
% saccades
        function result = get.PSMS( obj )
            result = 0;
            for i=1:length(obj.saccade_records)
                for j=1:size( obj.saccade_records{i}, 1 )
                    if( obj.saccade_records{i}(j,3) <= size( obj.stimulus_records, 1 ) )
                        if( obj.stimulus_records( obj.saccade_records{i}(j,3), 4 ) == obj.PURSUIT_TYPE ), result = result + 1; end;
                    end
                end
            end
            result = 100 * result / obj.get_stimulus_pursuit_points;
        end
        
        
% Calculating PQn score. This score show how accurately we detect pursuit
        function result = get.PQnS(obj)
            pursuit_detection_counter = 0;
            for i=1:length( obj.eye_records )
                if( i<length(obj.stimulus_records) )
% We have to add point to detected fixation if corresponding point in
% stimulus is also fixation and this point is belong to correct fixation
% sequence. To ensure this we use average saccade amplitude as a threshold
% value for distance
                    if (    (obj.eye_records(i, obj.MOV_TYPE) == obj.PURSUIT_TYPE &&...
                             obj.stimulus_records(i,4) == obj.PURSUIT_TYPE) )
                        pursuit_detection_counter = pursuit_detection_counter + 1;
                    end
                end
            end
            result = 100 * pursuit_detection_counter / obj.get_stimulus_pursuit_points();
        end

% Calculating Average Pursuit Speed score
        function result = get.APS(obj)
            result = 0;
            obj.calculate_delta_t();
            for i=1:length( obj.pursuit_records )
                current_distance = 0;
                current_time = 0;
                for j = 1:size( obj.pursuit_records{i},1 )-1
                    if( obj.stimulus_records( obj.pursuit_records{i}(j,3), 4) == obj.PURSUIT_TYPE && ...
                        obj.stimulus_records( obj.pursuit_records{i}(j+1,3), 4) == obj.PURSUIT_TYPE )
                        current_distance  = current_distance +...
                                sqrt(   (obj.pursuit_records{i}(j+1,1) - obj.pursuit_records{i}(j,1) )^2 +...
                                        (obj.pursuit_records{i}(j+1,2) - obj.pursuit_records{i}(j,2) )^2 );
                        current_time = current_time + obj.delta_t_sec;
                    end
                end
                if( current_time > 0 ), result = result + current_distance / current_time; end;
            end 
            if( ~isempty( obj.pursuit_records ) ), result = result / length( obj.pursuit_records ); end
        end

% Calculating FQn score
        function result = get.FQnS(obj)
            fixation_detection_counter = 0;
            threshold = 5;
            for i=1:length( obj.eye_records )
                if( i<length(obj.stimulus_records) )
% We have to add point to detected fixation if corresponding point in
% stimulus is also fixation and this point is belong to correct fixation
% sequence. To ensure this we use average saccade amplitude as a threshold
% value for distance
                    if (    (obj.eye_records(i, obj.MOV_TYPE) == obj.FIXATION_TYPE &&...
                             obj.stimulus_records(i,4) == obj.FIXATION_TYPE) && ...
                             ( sqrt (   ( obj.eye_records( i,obj.X_COORD ) - obj.stimulus_records( i,obj.X_COORD ) )^2 +...
                                        ( obj.eye_records( i,obj.Y_COORD ) - obj.stimulus_records( i,obj.Y_COORD ) )^2 ) < threshold ) )
                        fixation_detection_counter = fixation_detection_counter + 1;
                    end
                end
            end
            result = 100 * fixation_detection_counter / obj.get_stimulus_fixation_points();
        end

% Calculating FQl score
        function result = get.FQlS(obj)
            result = 0;
            count_points = 0;
            threshold = 5;
            for i=1:length(obj.fixation_records)
% Searching for coordinates of center of current fixation
                centroid_x = mean( obj.fixation_records{i}(:,obj.X_COORD) );
                centroid_y = mean( obj.fixation_records{i}(:,obj.Y_COORD) );

                for j=1:size(obj.fixation_records{i},1)
% We have to consider current point as detected fixation if corresponding
% point in stimulus is also fixation and this point is belong to correct fixation
% sequence. To ensure this we use average saccade amplitude as a threshold
% value for distance
                    if( obj.fixation_records{i}(j,3) <= length(obj.stimulus_records) )
                        if( ( obj.stimulus_records( obj.fixation_records{i}(j,3) , 4 ) == obj.FIXATION_TYPE ) && ...
                            ( sqrt (   ( obj.eye_records( obj.fixation_records{i}(j,3),obj.X_COORD ) - obj.stimulus_records( obj.fixation_records{i}(j,3),1 ) )^2 +...
                                       ( obj.eye_records( obj.fixation_records{i}(j,3),obj.Y_COORD ) - obj.stimulus_records( obj.fixation_records{i}(j,3),2 ) )^2 ) < threshold ) )
                            count_points = count_points + 1;
                            result = result +...
                                sqrt(   ( centroid_x - obj.stimulus_records( obj.fixation_records{i}(j,3) , obj.X_COORD ) )^2 + ...
                                        ( centroid_y - obj.stimulus_records( obj.fixation_records{i}(j,3) , obj.Y_COORD ) )^2);
                        end
                    end
                end
            end
            if ( count_points ~= 0)
                result = result / count_points;
            else
                result = nan;
            end
        end
        
% Calculating total stimulus saccade amplitude
        function result = get_stimulus_saccade_amplitude(obj)
            total_stimulus_saccade_amplitude = 0;
            i=1;
% Scanning stiumulus records for saccade
            while( i< length(obj.stimulus_records) )
% if saccade detected
                if( obj.stimulus_records(i,4) == obj.SACCADE_TYPE )
% Looking for its end
% And during the search we determine minimal and maximal saccade values
                    minimal_saccade_value_x = obj.stimulus_records(i,obj.X_COORD);
                    maximal_saccade_value_x = obj.stimulus_records(i,obj.X_COORD);
                    minimal_saccade_value_y = obj.stimulus_records(i,obj.Y_COORD);
                    maximal_saccade_value_y = obj.stimulus_records(i,obj.Y_COORD);
                    while( obj.stimulus_records(i,4) == obj.SACCADE_TYPE )
% Search min and max values in x
                        if( minimal_saccade_value_x > obj.stimulus_records(i,obj.X_COORD) )
                            minimal_saccade_value_x = obj.stimulus_records(i,obj.X_COORD);
                        end
                        if( maximal_saccade_value_x < obj.stimulus_records(i,obj.X_COORD) )
                            maximal_saccade_value_x = obj.stimulus_records(i,obj.X_COORD);
                        end
% Search min and max values in y
                        if( minimal_saccade_value_y > obj.stimulus_records(i,obj.Y_COORD) )
                            minimal_saccade_value_y = obj.stimulus_records(i,obj.Y_COORD);
                        end
                        if( maximal_saccade_value_y < obj.stimulus_records(i,obj.Y_COORD) )
                            maximal_saccade_value_y = obj.stimulus_records(i,obj.Y_COORD);
                        end
                        i = i + 1;
                        if (i > length(obj.stimulus_records) )
                            break;
                        end
                    end
                    total_stimulus_saccade_amplitude = ...
                        total_stimulus_saccade_amplitude +...
                        sqrt(   ( minimal_saccade_value_x - maximal_saccade_value_x )^2 +...
                                ( minimal_saccade_value_y - maximal_saccade_value_y )^2 );
                end
                i=i+1;
            end
            result = total_stimulus_saccade_amplitude;
        end

% Calculating total saccade amplitude - old variant for saccades and
% fixations only
        function result = get_detected_saccade_amplitude(obj)
            total_detected_saccade_amplitude = 0;
            for i=1:length(obj.saccade_records)
                minimal_saccade_value_x = min ( obj.saccade_records{i}(:,obj.X_COORD) );
                maximal_saccade_value_x = max ( obj.saccade_records{i}(:,obj.X_COORD) );
                minimal_saccade_value_y = min ( obj.saccade_records{i}(:,obj.Y_COORD) );
                maximal_saccade_value_y = max ( obj.saccade_records{i}(:,obj.Y_COORD) );
                total_detected_saccade_amplitude = ...
                    total_detected_saccade_amplitude + ...
                   sqrt(   ( minimal_saccade_value_x - maximal_saccade_value_x )^2 +...
                           ( minimal_saccade_value_y - maximal_saccade_value_y )^2 );
            end
            result = total_detected_saccade_amplitude;
        end

% Calculating total saccade amplitude - new variant for combined saccades,
% fixations, and SPEMs
        function result = get_detected_saccade_amplitude_v2(obj)
            total_detected_saccade_amplitude = 0;
% First of all we have to determine if the onset position of current
% saccade is inside of allowed time ranges determined as onset+200ms ;
% onset+200ms+2.2 Saccade Amplitude + 21
            for i=1:length(obj.saccade_records)
% Determine saccade onset
                onset_saccade = obj.saccade_records{i}(1,3);
% Determine time ranges. First try to find offset position of saccade in
% stimuli data
                saccade_end = onset_saccade;
                while(saccade_end >=1 && obj.stimulus_records( saccade_end, 4 ) ~= obj.SACCADE_TYPE ),saccade_end = saccade_end - 1;end;
% Now we have to find onset position of saccade to determine its amplitude
                if( saccade_end > 0 )
                    if( obj.stimulus_records( saccade_end, 4 ) == obj.SACCADE_TYPE )
                        saccade_start = saccade_end;
                        while( obj.stimulus_records( saccade_start, 4 ) == obj.SACCADE_TYPE ),saccade_start = saccade_start - 1;end;

                        saccade_amplitude = sqrt(   ( obj.stimulus_records( saccade_start, obj.X_COORD) - obj.stimulus_records( saccade_end, obj.X_COORD) )^2 + ...
                                                    ( obj.stimulus_records( saccade_start, obj.Y_COORD) - obj.stimulus_records( saccade_end, obj.Y_COORD) )^2 );
                        %theory_onset = saccade_start+200;
                        theory_onset = saccade_start - 500;
                        %theory_offset = saccade_start+200+2.2*saccade_amplitude+21;
                        theory_offset = saccade_start+500;

                        if( theory_onset <= onset_saccade && onset_saccade <= theory_offset )
                            minimal_saccade_value_x = min ( obj.saccade_records{i}(:,obj.X_COORD) );
                            maximal_saccade_value_x = max ( obj.saccade_records{i}(:,obj.X_COORD) );
                            minimal_saccade_value_y = min ( obj.saccade_records{i}(:,obj.Y_COORD) );
                            maximal_saccade_value_y = max ( obj.saccade_records{i}(:,obj.Y_COORD) );
                            total_detected_saccade_amplitude = total_detected_saccade_amplitude + ...
                                sqrt(   ( minimal_saccade_value_x - maximal_saccade_value_x )^2 +...
                                        ( minimal_saccade_value_y - maximal_saccade_value_y )^2 );
                        end
                    end
                end
            end
            result = total_detected_saccade_amplitude;
        end

% Calculating SQn score
        function result = get.SQnS(obj)
            result = 100 * obj.get_detected_saccade_amplitude_v2() / obj.get_stimulus_saccade_amplitude();
        end
        
% Calculating Average Fixation Duration
        function result = get.AFD(obj)
            obj.calculate_delta_t();
            result = 0;
            count_fixations = 0;
            for i=1:length(obj.fixation_records)
                count_fixations = count_fixations + 1;
                result = result + length(obj.fixation_records{i}) * obj.delta_t_sec;
            end
            if( count_fixations ~= 0)
                result = result / count_fixations;
            end
        end

% Calculating Average Fixation Number
        function result = get.ANF(obj)
            result = length(obj.fixation_records);
        end
        
        function result = get.AFN(obj)
            result = obj.ANF;
        end

% Calculating Average Saccade Amplitude
        function result = get.ASA(obj)
            result = obj.get_detected_saccade_amplitude() / length(obj.saccade_records);
        end

% Calculating Average Fixation Number
        function result = get.ANS(obj)
            result = length(obj.saccade_records);
        end

% Public access interface to class properties
        function set.stimulus_records(obj, value)
            obj.stimulus_records = value;
        end
    end
    
end
