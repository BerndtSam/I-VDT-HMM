classdef Gmm
    
    properties (Constant)
        % TODO: for final evaluation, replace by a higher number (e.g., 10)
        replicates = 1;
        regularize = realmin('double');
    end
    
    properties
        gmm;
        ids;
    end
    
    methods
        function obj = Gmm(x, n)
            x(isnan(x)) = [];
            while true
                gmm = fitgmdist(x', n, 'Replicates', obj.replicates, 'Regularize', obj.regularize);
                if length(unique(gmm.mu)) == length(gmm.mu)
                    break
                end
            end
            
            ids = [];
            tmp = gmm.mu;
            for i = 1 : length(tmp)
                [ minVal, idx ] = min(tmp);
                tmp(idx) = NaN;
                ids = [ ids idx ];
            end
            
            obj.gmm = gmm;
            obj.ids = ids;
        end
        
        function ret = mu(obj, id)
            ret = obj.gmm.mu(obj.ids(id));
        end     
        
        function ret = s(obj,id)
            ret = obj.gmm.Sigma(obj.ids(id));
        end
    end
    
end

