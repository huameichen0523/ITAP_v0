
function [seg_centers, res] = traceSegment(trace, var)

    [trace] = fitTrace(trace, var);
    % segmentation using y as target   
    [res_x_based, coef_x_based] = findSegmentation(trace, var.C);
    trace_fliplr = fliplr(trace);
    flip_lr = true;
    % segmentation using x as target 
    [res_y_based, coef_y_based] = findSegmentation(trace_fliplr, var.C);
    
    if size(res_y_based, 2) > size(res_x_based, 2)
        flip_lr = false;
        res1 = res_x_based;
        coef1 = coef_x_based;
    else
        trace = trace_fliplr;
        res1 = res_y_based;
        coef1 = coef_y_based;
    end
    % segmentation start from leftmost 
    [res_flipud, coef_flipud] = findSegmentation(flipud(trace), var.C);    
    res_flipud = fliplr(size(trace, 1) + 1 - res_flipud);
    cat_position = size(res1, 2);
    % merge segmentation start from leftmost and rightmost by picking 
    % the one with less segments
    if res_flipud(1, max(end - 1, 1)) <= res1(1, cat_position)
        for cat_position = size(res1, 2) - 1 : -1 : 1
            if res1(1, cat_position) < res_flipud(1, end - 1)
                break;
            end
        end         
    end
    res = [res1(1, 1 : cat_position), res_flipud(1, max(end - 1, 1): end)];
%     coef = [[coef1(1 : res(1, end - 1), 1 : res(1, end - 1)), ...
%         coef_flipud(1 : res(1, end - 1), (res(1, end - 1) + 1) : res(1, end))]; ...
%         coef_flipud(res(1, end - 1) + 1 : end, :)];
    coef = coef1;
    centers = trace;
    % generate new trace using segmentation points
    start = 1;
    seg_line = [];
    section = [];
    segment = [];
    for i = 2 : size(res, 2)
        ab = coef{start, res(i)};
        if isnan(ab(1)) || isnan(ab(2)) || isinf(ab(1)) || isinf(ab(2))
            y = centers(start:res(i), 2);
        else
            y = ab(1) * centers(start:res(i), 1) + ab(2);
        end
        seg_line = [seg_line; [centers(start:res(i), 1), y]];
        if start == res(i)
            start = start - 1;
        end
        section = [section; [centers(start, 1), y(1), centers(res(i), 1), y(end)]];
        segment = [segment; (i - 1)*ones(res(1, i) - res(1, i - 1), 1)];
        start = res(i) + 1;
    end
    
    seg_centers = seg_line(res, :);    
    if flip_lr
        seg_centers = fliplr(seg_centers);
        seg_line = fliplr(seg_line);
        trace = fliplr(trace);
    end
%     var.draw_segment = 0;
%     if var.draw_segment
%         figure(1);
%         drawSegmentation(seg_centers, seg_line, segment, trace, var);
%        'here';
%     end

end

function [ res, coef ] = findSegmentation( data, C )
    n = size(data, 1);
    e = zeros(n, n);
    m = zeros(n, 1);
    coef = cell(n, n);
    % calculate fitting error eij for all i, j
    for j = 1 : n
        for i = 1 : j
            x = data(i : j, 1);
            y = data(i : j, 2);
            x_mean = mean(x);
            y_mean = mean(y);
            a = (mean(x.*y) - x_mean*y_mean)/(mean(x.^2) - x_mean*x_mean);
            b = y_mean - a * x_mean; 
            coef{i, j} = [a, b];
            % error of straight fitting line y' = ax + b
            e(i, j) = sum((y - a*x - b).^2);
            if isnan(e(i, j))
                e(i, j) = 10000;
            end             
        end
    end
    tmp = zeros(n, 1);
    idx = zeros(n, 1);
    % initial the cost function m(j)
    for j = 1 : n
        for i = 1 : j
            if (i == 1)
                % C is the penalty to add new segment points
                tmp(i, 1) = (e(i,j) + C);
            else
                tmp(i, 1) = (e(i,j) + C + m(i - 1, 1));
            end
        end
        [m(j), idx(j)] = min(tmp(1 : j, 1));
    end
    res = [];
    res = findSegmentPoints( data, C, e, j, m, res);
    res = fliplr(res);
end
% recursively to find each segmentation points by dynamic programming
function [ res ] = findSegmentPoints( data, C, e, j, m, res) 
    tmp = zeros(j, 1);
    if j == 0
        return;
    else
        for i = 1 : j
            if (i == 1)
                tmp(i, 1) = (e(i,j) + C);
            else
                tmp(i, 1) = (e(i,j) + C + m(i - 1, 1));
            end
        end
        [~, idx] = min(tmp(1 : j, 1));
        res(end + 1) = idx;
        res = findSegmentPoints( data, C, e, idx - 1, m, res);
    end
end

function drawSegmentation(seg_centers, seg_line, segment, trace, var)

    img = imread([var.img_path, '/', num2str(216), '.jpg']);
    %img = imread([var.img_path, '/', num2str(trace2(end, 3)), '.jpg']);
    centers = trace;
    trace_length = size(trace, 1);    
    circles = [centers, 3 * ones(trace_length, 1)];
    im_show = insertShape(img, 'Circle', circles, 'LineWidth', var.line_width, 'Color', 'green');
    
    circles = [seg_centers, 3 * ones(size(seg_centers, 1), 1)];
    im_show = insertShape(im_show, 'Circle', circles, 'LineWidth', var.line_width, 'Color', 'magenta');
    trace_lines = [seg_line(1 : end - 1, :), seg_line(2 : end, :)];
    color_name = colormap(lines);
    c = color_name(mod(segment, 7) + 1, :) *255;
    im_show = insertShape(im_show, 'Line', trace_lines, 'LineWidth', var.line_width, 'Color', c);
    imshow(im_show);
end
