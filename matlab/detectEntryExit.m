
function [entry, exit] = detectEntryExit(activity, var)

    activity_length = size(activity, 1);
    % exit
    exit = false(activity_length, 1);
    end_idx = floor(max(activity_length * (1 - var.exit_seq_length), ...
        activity_length - var.start_end_seq_len));
    end_seq = activity( end_idx : end, 1);
    % find last turning
    turning_position = find((end_seq == var.LEFT_TURN) ...
        | (end_seq == var.RIGHT_TURN) );
    if ~isempty(turning_position)
        exit(floor(min(turning_position) + end_idx - 1) : end, 1) = true;
    end
    % entry
    entry = false(size(activity, 1), 1);
    start_idx = floor(min(activity_length * var.exit_seq_length, var.start_end_seq_len));
    start_seq = activity(1 : start_idx, 1);
    % find first turning
    turning_position = find((start_seq == var.LEFT_TURN) ...
        | (start_seq == var.RIGHT_TURN) );
    if ~isempty(turning_position)
        entry(1 : max(turning_position), 1) = true;
    end
end
