classdef ClassificationClass < handle

    properties (Constant)       
        debug = true;
    end
    
    properties
        count;
        value;
        setter;
        ts;
    end
    
    methods
        
        function obj = ClassificationClass(count)
            obj.count = count;
            obj.value(1:count) = ClassificationEnum.undef;
            obj.ts(1:count) = 0;
            if obj.debug
                obj.setter = cell(1,count);
            end
        end
        
        function set(obj, who, value)
            obj.value(who) = value;
            
            if ~obj.debug
                return
            end
            
            if length(dbstack) > 1
                [ST,I] = dbstack(1);
            else
                ST(1).name = 'script';
                ST(1).line = 0;
            end
            
            if length(who) == 1
                % Single
                obj.setter{who} = sprintf('%s:%.0f', ST(1).name, ST(1).line);
                return
            end
            
            if length(who) == length(obj.value)
                % Everyone that's true
                for i = 1:length(who)
                    if who(i)
                        obj.setter{i} = sprintf('%s:%.0f', ST(1).name, ST(1).line);
                    end
                end
                return
            end
            
            % Range
            for i = min(who) : max(who)
                obj.setter{i} = sprintf('%s:%.0f', ST(1).name, ST(1).line);
            end    
        end
        
        function r = get(obj, who)
            r = obj.value == who;
        end
        
    end
end

