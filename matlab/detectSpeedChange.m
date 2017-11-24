
function [accelering, slowdowning] = detectSpeedChange(velocity_scaler, var)
% may consider to smooth velocity_scaler first
    velocity_scaler_remove0 = velocity_scaler;
    velocity_scaler_remove0(velocity_scaler == 0, :) ...
        = 1.0 / (100000 * var.stay_threshold);
    acceleration_scaler = velocity_scaler(2 : end, :) ...
        - velocity_scaler(1 : end - 1, :);
    acceleration_ratio = acceleration_scaler ./ velocity_scaler_remove0(2 : end, :);    
    accelering  = [false(2, 1); acceleration_ratio > var.speed_change_threshold];
    accelering = [false; accelering(1 : end - 1, :)] & accelering ...
        | [accelering(2 : end, :); false] & accelering;
    slowdowning = [false(2, 1); acceleration_ratio < -var.speed_change_threshold];
    slowdowning = [false; slowdowning(1 : end - 1, :)] & slowdowning ...
        | [slowdowning(2 : end, :); false] & slowdowning;
end
