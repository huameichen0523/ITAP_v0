
function [ activity ] = getActivity(trace, var)
    
    %trace = trace_info(:, 4 : 5);
    trace_length = size(trace, 1);
    invalid_trace = (trace(:, 1) == 0) & (trace(:, 1) == 0);
    invalid_activity = [false; invalid_trace(1 : end - 1, 1) | invalid_trace(2 : end, 1)]; 
    activity = var.UNKOWN * ones(trace_length, 1);
    % velocity
    if (trace_length > 1)
        velocity = trace(2 : end, :) - trace(1 : end - 1, :);
        velocity_scaler = sqrt(sum(velocity.^2, 2));
    else
        return
    end
    
    % stay
    [stay] = detectStay(velocity_scaler, var);
    stay = stay & ~invalid_activity;
    activity(stay, :) = var.STAY;
    
    if size(velocity, 1) > 1
        % speed change
        [accelering, slowdowning] = detectSpeedChange(velocity_scaler, var);
        activity(accelering, :) = var.ACCELERATE;
        activity(slowdowning, :) = var.SLOWDOWN;
        
        % turning        
        [left_turning, right_turning] = detectTurning(trace, var);
        activity(left_turning, :) = var.LEFT_TURN;
        activity(right_turning, :) = var.RIGHT_TURN;
        
        activity(stay, :) = var.STAY;
        
        % entry or exsit
        [entry, exit] = detectEntryExit(activity, var);
        activity(entry, :) = var.ENTRY;
        activity(exit, :) = var.EXIT;
    end
end
