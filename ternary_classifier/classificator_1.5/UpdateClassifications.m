function [ eye_record ] = UpdateClassifications( noiseless_eye_record, eye_record, non_classifications )
% Put classifications back into the eye record

% Input
% noiseless_eye_record: Updated classifications to put back into the
% eye_record
% eye_record: Final classification matrix
% non_classifications: Array of items in the eye_record not to classify in
% this iteration

% Output
% eye_record: Final classification matrix with newly inputted
% classifications
    noiseless_eye_record_index = 0; 
    for eye_record_index = 1:length(eye_record) 
        if(~ismember(eye_record(eye_record_index).xy_movement_EMD, non_classifications))
           noiseless_eye_record_index = noiseless_eye_record_index + 1; 
           eye_record(eye_record_index).xy_movement_EMD = noiseless_eye_record(noiseless_eye_record_index).xy_movement_EMD;  
        end
    end
end

