function [ difference ] = CalculateDispersion( noiseless_eye_record, classification, start_index, duration_threshold, dispersion_threshold )
%CALCULATEDISPERSION Summary of this function goes here
%   Detailed explanation goes here
    min_x = 1000;
    max_x = -1000;
    for i=start_index:start_index+duration_threshold
        if i > length(noiseless_eye_record)
            if max_x == -1000
                max_x = 0;
            end
            if min_x == 1000
                min_x = 0;
            end
            break;
        end
%         if noiseless_eye_record(i).xy_movement_EMD ~= classification
%             if max_x == -1000
%                 max_x = 0;
%             end
%             if min_x == 1000
%                 min_x = 0;
%             end
%             break;
%         end
        if noiseless_eye_record(i).x > max_x
            max_x = noiseless_eye_record(i).x;
        end
        if noiseless_eye_record(i).x < min_x
            min_x = noiseless_eye_record(i).x;
        end
        
        if abs(max_x - min_x) > dispersion_threshold && classification == 1
            if max_x == -1000
                max_x = 0;
            end
            if min_x == 1000
                min_x = 0;
            end
            break;
        end
    end
    difference = abs(max_x - min_x);
end

