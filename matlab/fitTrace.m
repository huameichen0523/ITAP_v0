
function [trace] = fitTrace(trace, var)

    invalid_trace = (trace(:, 1) == 0) & (trace(:, 1) == 0);    
    step_position = diff(1.0 * invalid_trace);
    start_idx = find(step_position == 1);
    end_idx = find(step_position == -1);
    if ~isempty(start_idx)
        for i = 1 : size(start_idx, 1)
            trace(start_idx(i) : end_idx(i) + 1, 1) ...
                = linspace(trace(start_idx(i), 1), trace(end_idx(i) + 1, 1), ...
                end_idx(i) - start_idx(i) + 2);
            trace(start_idx(i) : end_idx(i) + 1, 2) ...
                = linspace(trace(start_idx(i), 2), trace(end_idx(i) + 1, 2), ...
                end_idx(i) - start_idx(i) + 2);
        end
    end
    if var.use_sp_line_fit
        trace = spcrv(trace', var.smooth_points, size(trace, 1))';
    end
end
