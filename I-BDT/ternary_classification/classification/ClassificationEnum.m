classdef ClassificationEnum
    
    properties (Constant)
        % Possible values
        fixation = 0;
        saccade  = 1;
        pursuit  = 2;
        noise    = 3;
        undef    = 4;
        vor      = 5;
        head     = 6;
        tmp      = 99;
    end
    
    methods
        function ret = str(obj, val)
            if val == obj.fixation;
                ret = 'fixation';
            elseif val == obj.saccade
                ret = 'saccade';
            elseif val == obj.pursuit
                ret = 'pursuit';
            elseif val == obj.noise
                ret = 'noise';
            elseif val == obj.undef
                ret = 'undef';
            elseif val == obj.vor
                ret = 'vor';
            elseif val == obj.head
                ret = 'head';
            else
                ret = 'unknown';
            end
        end
    end
    
end

