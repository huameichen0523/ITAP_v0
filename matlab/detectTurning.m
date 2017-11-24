
function [left_turning, right_turning] = detectTurning(trace, var)
    
    %trace = trace_info(:, 4 : 5);
    [seg_centers, res] = traceSegment(trace,  var);
    velocity = seg_centers(2 : end, :) - seg_centers(1 : end - 1, :);
    velocity_scaler = sqrt(sum(velocity.^2, 2));
    velocity_orient = bsxfun(@rdivide, velocity, velocity_scaler);
    v2 = velocity_orient(2 : end, :);
    v1 = velocity_orient(1 : end - 1, :);
    turning_angle = atan2d(v1(:, 1).*v2(:, 2) - v1(:, 2).*v2(:, 1), ...% atan2d(sin(thita),cos(thita))
        v1(:, 1).*v2(:, 1) + v1(:, 2).*v2(:, 2)); % in [-180, +180];
    turning_angle_points = zeros(size(trace, 1), 1);
    for i = 2 : size(seg_centers, 1) - 1
        if abs(turning_angle(i - 1)) < var.turning_threshold
            continue;
        end
        turning_angle_points(max(res(i) - 3, 1) : min(res(i) + 3, end), 1) ...
        = turning_angle(i - 1);
    end
    left_turning = turning_angle_points < -var.turning_threshold ;
    right_turning = turning_angle_points > var.turning_threshold ;
end
