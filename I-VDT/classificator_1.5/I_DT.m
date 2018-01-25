function [ noiseless_eye_record ] = I_DT( dispersion_threshold, duration_threshold, noiseless_eye_record )
% I-DT

% Input
% dispersion_threshold: X dispersion threshold, where dispersion is Xmax -
% xMin
% duration_threshold: minimum temporal duration of a fixation
% noiseless_eye_record: records of data with only the classifications we
% will be separating

% Output
% noiseless_eye_record: records of data after classification using I-DT

    % Start I-DT
    index = 0;
    newWindow = true;
    while index < length(noiseless_eye_record)
        index = index + 1;
        if newWindow
            % Set the min and max to the current points position
            min_x = noiseless_eye_record(index).x;
            max_x = noiseless_eye_record(index).x;
            newWindow = false;
            first_index = index;
            end_index = index+duration_threshold;
            if end_index > length(noiseless_eye_record)
                index = length(noiseless_eye_record);
                break;
            end
        end

        
        
        % Check the current window for max and min
        for i=first_index:end_index
            if noiseless_eye_record(i).x > max_x
                max_x = noiseless_eye_record(i).x;
            end
            if noiseless_eye_record(i).x < min_x
                min_x = noiseless_eye_record(i).x;
            end
        end


        if abs(max_x - min_x) > dispersion_threshold
            % If this holds, first point is SP
            noiseless_eye_record(index).xy_movement_EMD = 3;
            newWindow = true;
        else
            % Now set all points inside window to fixations
            for i=first_index:end_index
                noiseless_eye_record(i).xy_movement_EMD = 1;
            end
            
            % Now we can do one point at a time
            while abs(max_x - min_x) <= dispersion_threshold
                noiseless_eye_record(end_index).xy_movement_EMD = 1;

                % Add one point to the window
                if end_index < length(noiseless_eye_record)
                    end_index = end_index + 1;
                else
                    break;
                end
                
                

                % See if that point is greater than max or less than
                % min
                if noiseless_eye_record(end_index).x > max_x
                    max_x = noiseless_eye_record(end_index).x;
                end
                if noiseless_eye_record(end_index).x < min_x
                    min_x = noiseless_eye_record(end_index).x;
                end

            end

            % When this ends, we know that the end index is a SP
            noiseless_eye_record(end_index).xy_movement_EMD = 3;
            newWindow = true;    
            index = end_index;

        end
    end
    
end

