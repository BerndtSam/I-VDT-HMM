classdef eye_records_class <    classificator_enumerations_class & ...
                                handle
    % Basic class for define eye_records array.
    % Main purpose of this class is resolve propertie conflict in
    % superclasses and define some constants
    
    properties (Hidden)
       eye_records;
% Eye_records is two dimensional array that contains all data regarding eye
% movement records. The fields array have the following meanings:
% i,1 - x degree - input data from eye tracker
% i,2 - y degree - input data from eye tracker
% i,3 - velocity speed in degree per second - calculated on the basis of
% two previous fields and sampling rate of eye tracker
% i,4 - type of classification - supposeed to be 1 for fixation, 2 for
% saccade, 3 for pursuit and 4 for noise.
% i,5 - validity of the eye tracker data. Supposed to be 1 for valid data
% and 0 for invalid data.
% i,6 - time mark of any kind. Usually it just a counter
    end

    methods
% Access interface to class properties
        function result = get.eye_records(obj)
            result = obj.eye_records;
        end

        function set.eye_records(obj, value)
            obj.eye_records = value;
        end
    end

end

