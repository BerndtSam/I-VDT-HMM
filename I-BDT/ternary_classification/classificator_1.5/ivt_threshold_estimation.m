DirectoriesList = { 'Input_h27s' ;...
                    'Input_h32s' ;...
                    'Input_h32s_h27s' ;...
                    'Input_v27s' ;...
                    'Input_v32s' ;...
                    'Input_v32s_v27s' };
                
for DirName=1:2
    DirectoryName = DirectoriesList{DirName};
    if( ~exist( strcat(DirectoryName,'.txt'), 'file' ) )
        fd = fopen( strcat(DirectoryName,'.txt'), 'wt' );
        if( fd ~= -1 )
            fprintf(fd,'IVT_Treshold     Directory     FQnS     FQlS     SQnS      AFD      ANF      ASA      ANS\n');
            fclose(fd);
            start = 1;
        end
    else
        fd = fopen( strcat(DirectoryName,'.txt'), 'rt' );
        if( fd ~= -1 )
            start = 0;
            while( ~feof( fd ) ), fgetl(fd); start=start+1; end
            fclose(fd);
        end
    end
    start = start*5;
    fprintf('Begin from IVT threshold %d\n',start);

    matlabpool open local 4;
    for IVT_threshold = start:5:100
        D = DirectoryReader;
        global_data = zeros(7,1);
        parfor i = 1:D.TotalFiles( DirectoryName )
            data = zeros(7,1);
            classificator = classificator_IVT_class;
            classificator.saccade_detection_threshold = IVT_threshold;
            classificator.debug_mode =                  0;
            classificator.input_data_name =             D.InputFileName( DirectoryName, i);
            if( DirName < 4 )
	        classificator.x_field = 8;
	        classificator.y_field = 9;
            else
	        classificator.x_field = 9;
	        classificator.y_field = 8;
            end
            classificator.v_field =                     11;
            classificator.header_count =                1;
            classificator.delta_t_sec =                 0.001;
            classificator.sample_rate =                 1000;
            classificator.fields_count =                14;

            classificator.use_degree_data_filtering_X =  false;
            classificator.use_degree_data_filtering_Y =  false;
            classificator.minimal_allowed_X_degree =     0;
            classificator.maximal_allowed_X_degree =     0;
            classificator.minimal_allowed_Y_degree =     0;
            classificator.maximal_allowed_Y_degree =     0;

            classificator.read_data();
            if( classificator.error_code == 0 )
                classificator.eye_tracker_data_filter_degree_range();
                classificator.classify();
                classificator.eye_tracker_data_filter_degree_range();
                classificator.merge_fixation_time_interval = 75;
                classificator.merge_fixation_distance = 0.5;
                classificator.merge_records();
                if( true )
                    classificator.minimal_saccade_amplitude =    4;
                    classificator.maximal_saccade_amplitude =    180;
                    classificator.minimal_saccade_length =       4;
                    classificator.unfiltered_saccade_records =   classificator.saccade_records;
                    classificator.saccade_filtering();
                    classificator.saccade_records =              classificator.filtered_saccade_records;
                end

                scores_computator = scores_computation_class;
                switch DirName
                    case 1
                        scores_computator.selected_stimulus = 2;
                    case 2
                        scores_computator.selected_stimulus = 4;
                    case 3
                        if( i<55 ),scores_computator.selected_stimulus = 2;
                        else scores_computator.selected_stimulus = 4;
                        end
                    case 4
                        scores_computator.selected_stimulus = 3;
                    case 5
                        scores_computator.selected_stimulus = 5;
                    case 6
                        if( i<55 ),scores_computator.selected_stimulus = 3;
                        else scores_computator.selected_stimulus = 5;
                        end
                end
                scores_computator.generate_current_stimulus_1000Hz();
                scores_computator.eye_records = classificator.eye_records;
                scores_computator.saccade_records = classificator.saccade_records;
                scores_computator.fixation_records = classificator.fixation_records;
                scores_computator.noise_records = classificator.noise_records;
                scores_computator.pursuit_records = classificator.pursuit_records;
                scores_computator.sample_rate = classificator.sample_rate;
                scores_computator.delta_t_sec = classificator.delta_t_sec;

                k = scores_computator.FQnS; if( isnumeric( k ) ),data(1)=k;end;
                k = scores_computator.FQlS; if( isnumeric( k ) ),data(2)=k;end;
                k = scores_computator.SQnS; if( isnumeric( k ) ),data(3)=k;end;
                k = scores_computator.AFD;  if( isnumeric( k ) ),data(4)=k;end;
                k = scores_computator.ANF;  if( isnumeric( k ) ),data(5)=k;end;
                k = scores_computator.ASA;  if( isnumeric( k ) ),data(6)=k;end;
                k = scores_computator.ANS;  if( isnumeric( k ) ),data(7)=k;end;

                global_data = global_data + data;
                fprintf('T = %f, File = %s : %f %f %f %f %f %f %f\n',IVT_threshold, D.GetFileFromInputDirectory( DirectoryName, i), data );
            end
        end
        global_data = global_data / D.TotalFiles( DirectoryName );
        fprintf(' Average scores for T=%d and Dir=%s are %f %f %f %f %f %f %f\n',IVT_threshold,DirectoryName, global_data );
        fd = fopen( strcat(DirectoryName,'.txt'), 'at' );
        if( fd ~=-1 )
            fprintf(fd, '%d %s %f %f %f %f %f %f %f\n',IVT_threshold,DirectoryName,global_data );
            fclose(fd);
        end
    end
    matlabpool close;
end
