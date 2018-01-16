function [ eye_location_in_pxl ] = DVAtopxl( height, vert_pixels, distance, horiz_pixels, x_or_y, input_location )
%Convert degrees of visual angle to pxl
    % Calculate eye location in pxl from center of screen
    eye_location_in_pxl = input_location / (radtodeg(atan((0.5*height)/distance)) / (0.5*vert_pixels));
    
    % Take eye location relative to center of screen and convert it to
    % bottom left side of screen
    if x_or_y == 'x'
        eye_location_in_pxl = floor(eye_location_in_pxl + (0.5*horiz_pixels));
    else
        eye_location_in_pxl = floor(eye_location_in_pxl + (0.5*vert_pixels));
    end
end

