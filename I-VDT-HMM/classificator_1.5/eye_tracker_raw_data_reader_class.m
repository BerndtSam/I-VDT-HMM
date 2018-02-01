classdef eye_tracker_raw_data_reader_class <    eye_records_class & ...                 % Eye tracker data definition
                                                classificator_enumerations_class & ...  % Basic enumerations definitions
                                                handle
    % This class purposed for reading eye tracker data.
    % I assume that data file in ASCII format. This file is strucutred and
    % containing formatted lines with eye tracker data readings. Each line
    % is a several numbers that delimeted by spaces or tabs etc. Possibly
    % at the beginning of the file we have several header lines. We
    % shouldn't read them, just skip.
    %
    % For reading data you have to do
    % 1. Setup full input_data name in input_data_name property by calling
    % set.input_data_name method
    % 2. Setup field for x coordinate in x_field property by calling
    % set.x_field method
    % 3. Setup field for y coordinate in y_field property by calling
    % set.y_field method
    % 4. (Optionally) If eye trackers data contains field for data validity
    % you should setup v_field property by calling set.v_field method
    % 5. Setup the number of header lines in header_count property by
    % calling set.header_count method.
    % Call read_data function for reading data.
    % After this function check out error_code property. If it is not 0
    % then there was some error during data reading.
    
    %LAST MODIFIED: on 11/10/15 by John McAlmon
    %Fixed a syntax error relating to the textscan function.
    
    properties (Hidden)
% Publicly accessible properties
        error_code;             % It's an error code. If this is 0 then all ok.
                                % Otherwise there was a critical error and 
                                % we haven't gain any data.
        error_message;          % This is a message string that can contain
                                % error messages regarding I/O issues. If
                                % error_code 0 than this should be empty.
        input_data_name;        % Full name of input data file
        x_field;                % Number of field that contain x coordinate
        y_field;                % Number of field that contain y coordinate
        v_field=0;              % Number of field that contain data validity
        header_count;           % Number of header lines that we should skip
        fields_count;           % Number of data fields in the input file
    end
    
    methods
% Main function
        function read_data(obj)
            if (obj.debug_mode ~= 0)
                fprintf(strcat('Begin data reading in :',datestr(now),'\n'));
            end
% Reset all class variables
            obj.error_code =    0;
            obj.error_message = '';
% Try to open designated input file
            [fd, obj.error_message ] = fopen(obj.input_data_name,'r');
            if(fd == -1)
                obj.error_code = 1;
            else
% !!! TODO !!! I have a bad feeling about the code below. It looks for me
% that its performance will be low for the real data files.

% Input file was successfully opened. We are ready for data reading.
% Skipping header_count header lines
                while(obj.header_count>0)
                    fgetl(fd);
                    obj.error_message = ferror(fd);
                    if(~ isempty(obj.error_message) )
                        obj.error_code=2;
                        break;
                    end
                    obj.header_count=obj.header_count-1;
                end
% Reading data from data file and placing them in the eye_records array.
% Now we are reading data from data file and placing them in the array. If
% we encounter any error except end-of-file we should stop reading.
                if( obj.error_code == 0)
                    format_string = '%f';
                    for i=2:obj.fields_count
                        format_string = strcat(format_string,' %f');
                    end
                    
                    all_data = textscan(fd,format_string,'Delimiter',' :','MultipleDelimsAsOne',1);
                    obj.eye_records = zeros( length(all_data{1}),6);
                    obj.eye_records( :, obj.X_COORD) = all_data{obj.x_field};
                    obj.eye_records( :, obj.Y_COORD) = all_data{obj.y_field};
                    obj.eye_records( :, obj.VELOCITY) = NaN( length(obj.eye_records),1 );
                    obj.eye_records( :, obj.MOV_TYPE) = NaN( length(obj.eye_records),1 );
                    if( obj.v_field > 0 )
                        obj.eye_records( :, obj.VALIDITY) = all_data{obj.v_field};
                    else
                        obj.eye_records( :, obj.VALIDITY) = zeros( length(obj.eye_records),1 );
                    end
% Mark all invalid data as noise
                    obj.eye_records( (obj.eye_records(:,obj.VALIDITY)>0),obj.MOV_TYPE ) = obj.NOISE_TYPE;
% Reset x coordinate to 0 for all noise
                    obj.eye_records( (obj.eye_records(:,obj.MOV_TYPE) == obj.NOISE_TYPE),obj.X_COORD ) = 0;
% Reset y coordinate to 0 for all noise
                    obj.eye_records( (obj.eye_records(:,obj.MOV_TYPE) == obj.NOISE_TYPE),obj.Y_COORD ) = 0;
% Mark all noise data as invalid
                    obj.eye_records( (obj.eye_records(:,obj.MOV_TYPE) == obj.NOISE_TYPE),obj.VALIDITY ) = obj.DATA_INVALID;
% Mark all non-noise data as valid
                    obj.eye_records( (obj.eye_records(:,obj.MOV_TYPE) ~= obj.NOISE_TYPE),obj.VALIDITY ) = obj.DATA_VALID;
                    obj.eye_records( :,obj.T_COORD ) = 1:1:length(obj.eye_records);
                end
                
% Now we can close input data file
                if(fclose(fd) ~= 0)
                    obj.error_code = 10000;
                    obj.error_message = 'Error during file closing. This may lead to denial file access in the future.';
                end
            end
            if (obj.debug_mode ~= 0)
               fprintf(strcat('Finish data reading in :',datestr(now),'\n'));
            end
        end
        
% Access interface to publicly accessible properties
        function result = get.error_code(obj)
            result = obj.error_code;
        end

        function result = get.error_message(obj)
            result = obj.error_message;
        end

        function set.input_data_name(obj,value)
            obj.input_data_name = value;
        end

        function set.x_field(obj,value)
            obj.x_field = value;
        end

        function set.y_field(obj,value)
            obj.y_field = value;
        end

        function set.v_field(obj, value)
            obj.v_field = value;
        end

        function set.header_count(obj,value)
            obj.header_count = value;
        end
        
        function set.fields_count(obj, value)
            obj.fields_count = value;
        end
    end

end
