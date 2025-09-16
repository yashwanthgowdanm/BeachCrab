% CrabRobot.m

classdef CrabRobot < handle
    properties
        x;
        y;
        heading;
        gridWidth;
        gridHeight;
        normalSpeed;
        leapSpeed;
        turnRate;
        sensorRange;
        isTurning;
        turningDirection;
        isLeaping;
        leapRange;
        metallicWasteCount;
        nonMetallicWasteCount;
    end

    methods
        function obj = CrabRobot(gridWidth, gridHeight)
            obj.gridWidth = gridWidth;
            obj.gridHeight = gridHeight;
            obj.x = randi([1, gridWidth]);
            obj.y = randi([1, gridHeight]);
            obj.heading = rand() * 360;
            obj.normalSpeed = 1;
            obj.leapSpeed = 5; % Significantly faster speed for leaping
            obj.turnRate = 10;
            obj.sensorRange = 5;
            obj.isTurning = false;
            obj.turningDirection = 0;
            obj.isLeaping = false;
            obj.leapRange = 25; % Check a wider area for leaping
            obj.metallicWasteCount = 0;
            obj.nonMetallicWasteCount = 0;
        end

        function senseEnvironment(obj, map)
            % Check for obstacles and waste in the sensor range
            xmin_sense = max(1, round(obj.x) - obj.sensorRange);
            xmax_sense = min(obj.gridWidth, round(obj.x) + obj.sensorRange);
            ymin_sense = max(1, round(obj.y) - obj.sensorRange);
            ymax_sense = min(obj.gridHeight, round(obj.y) + obj.sensorRange);

            sensor_area = map(ymin_sense:ymax_sense, xmin_sense:xmax_sense);

            if any(sensor_area(:) == 3) % Obstacle detected
                obj.isTurning = true;
                obj.isLeaping = false; % Stop leaping
                obj.turningDirection = 1; % Start turning
            elseif any(sensor_area(:) == 1) || any(sensor_area(:) == 2) % Waste detected
                obj.isTurning = false;
                obj.isLeaping = false; % Stop leaping
                % Find and move towards the nearest waste
                [row, col] = find(sensor_area == 1 | sensor_area == 2);
                if ~isempty(row)
                    targetX = xmin_sense + col(1) - 1;
                    targetY = ymin_sense + row(1) - 1;
                    angleToTarget = atan2d(targetY - obj.y, targetX - obj.x);
                    obj.heading = angleToTarget;
                end
            else
                % No immediate threats, check for leap-walk opportunity
                xmin_leap = max(1, round(obj.x) - obj.leapRange);
                xmax_leap = min(obj.gridWidth, round(obj.x) + obj.leapRange);
                ymin_leap = max(1, round(obj.y) - obj.leapRange);
                ymax_leap = min(obj.gridHeight, round(obj.y) + obj.leapRange);
                
                leap_area = map(ymin_leap:ymax_leap, xmin_leap:xmax_leap);
                
                if ~any(leap_area(:) > 0) % Path is clear for a leap
                    obj.isLeaping = true;
                else
                    obj.isLeaping = false;
                end
                obj.isTurning = false;
            end
        end

        function navigate(obj)
            currentSpeed = obj.normalSpeed;
            if obj.isLeaping
                currentSpeed = obj.leapSpeed;
            end

            if obj.isTurning
                obj.heading = obj.heading + obj.turningDirection * obj.turnRate;
            else
                % Simple random walk with a bias when not turning
                obj.heading = obj.heading + (rand() - 0.5) * 5;
            end

            % Update position
            obj.x = obj.x + currentSpeed * cosd(obj.heading);
            obj.y = obj.y + currentSpeed * sind(obj.heading);

            % Boundary checks
            obj.x = max(1, min(obj.gridWidth, obj.x));
            obj.y = max(1, min(obj.gridHeight, obj.y));
        end

        function [newMap, collected] = collectWaste(obj, map)
            collected = false;
            roundedX = round(obj.x);
            roundedY = round(obj.y);
            
            % Ensure rounded coordinates are within map bounds
            if roundedX >= 1 && roundedX <= obj.gridWidth && roundedY >= 1 && roundedY <= obj.gridHeight
                if map(roundedY, roundedX) == 1 % Metallic
                    obj.metallicWasteCount = obj.metallicWasteCount + 1;
                    map(roundedY, roundedX) = 0;
                    collected = true;
                elseif map(roundedY, roundedX) == 2 % Non-metallic
                    obj.nonMetallicWasteCount = obj.nonMetallicWasteCount + 1;
                    map(roundedY, roundedX) = 0;
                    collected = true;
                end
            end
            newMap = map;
        end
    end
end