function [ eye_location_in_VA ] = DegreesOfVisualAngle( height, vert_pixels, distance, input_location )
%DEGREESOFVISUALANGLE Summary of this function goes here
%   Detailed explanation goes here
    
    eye_location_in_VA = input_location * radtodeg(atan((0.5*height)/distance)) / (0.5*vert_pixels);

end

