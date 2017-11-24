
function [stay] = detectStay(velocity_scaler, var) 
% if velocity is less than 5 
% or velocity_reciprocal is greater than 0.2

    velocity_scaler_remove0 = velocity_scaler;
    velocity_scaler_remove0(velocity_scaler == 0, :) ...
        = 1.0 / (100000 * var.stay_threshold);
    velocity_reciprocal = 1.0 ./ velocity_scaler_remove0;
        stay = [false; velocity_reciprocal > var.stay_threshold];
end
