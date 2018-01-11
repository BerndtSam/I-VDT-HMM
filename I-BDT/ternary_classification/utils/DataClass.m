classdef DataClass < handle
    
    properties (Constant)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Data protocol index description
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Time Stamp
        tsIdx = 2;        
        % Eye Valid
        evIdx = 10;       
        % X pupil coordinate
        xIdx = 11;        
        % Y pupil coordinate
        yIdx = 12;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Config
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        unjitter = true;
    end
    
    properties (Access = public)
        c       	% Class
        idx     	% Frame index
        t       	% Timestamp
        ev      	% Eye valid
        x       	% X pupil signal
        y       	% Y pupil signal
        dt      	% Delta t
        dx      	% Delta x
        dy      	% Delta y
        vx      	% Velocity x
        vy      	% Velocity y
        ds      	% Displacement
        v      		% Velocity (pixels / ms)
        ox          % Original X pupil signal
        oy          % Original Y pupil signal
        
        reference   % Debug stuff :-)
        
        
        % single values
        fps
    end
    
    methods
        
        function obj = DataClass(entries)
            
            % Offset the timestamp for improved visualization
            tsOffset = entries(1,obj.tsIdx);
            
            % Get protocol data and initialize
            [rows, columns] = size(entries);
            for i=1:rows
                eye_valid = entries(i,obj.evIdx);
                ts = entries(i,obj.tsIdx) - tsOffset;
                if eye_valid
                    x = entries(i, obj.xIdx);
                    y = entries(i, obj.yIdx);
                else
                    if i == 1
                        x = 0;
                        y = 0;
                    else
                        x = obj.x(i-1);
                        y = obj.y(i-1);
                    end
                end
                
                obj.idx(i)  = i - 1;
                obj.t(i)  = ts;
                obj.ev(i) = eye_valid;
                obj.x(i)  = x;
                obj.y(i)  = y;
            end
            
            % Save original signal and unjitter
            obj.ox = obj.x;
            obj.oy = obj.y;
            if obj.unjitter
                obj.x = unjitter(obj.x);
                obj.y = unjitter(obj.y);            
                [ obj.x , obj.y ] = removeOneSampleSpike(obj.x, obj.y);
            end
            
            % Class init
            obj.c = ClassificationClass(rows);         
            
            % Time derived data
            obj.dt = [ 0 diff(obj.t) ];
            obj.fps = double(int32(1/mean(obj.dt(2:end)) * 1000));
            
            % Per Axis derived data
            obj.dx = [ 0 diff(obj.x) ];
            obj.dy = [ 0 diff(obj.y) ];
            obj.vx = obj.dx ./ obj.dt;
            obj.vy = obj.dy ./ obj.dt;
            
            % Combined derived data
            obj.ds = sqrt(obj.dx.^2 + obj.dy.^2);
            obj.v = obj.ds ./ obj.dt;

        end
        
    end
    
end
