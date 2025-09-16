% main_simulation.m

% This script simulates an autonomous beach crab that navigates a beach
% environment, detects and collects metallic and non-metallic waste,
% and avoids obstacles. It also generates a results plot and
% displays statistics at the end of the simulation.

% Clear all variables, close all figures, and clear the command window for a fresh start.
clear;
close all;
clc;

%% Environment Setup
% Define the size of the simulated beach grid.
gridSize = 200;
beachMap = zeros(gridSize, gridSize);

% Set the initial counts for different types of waste to be placed.
totalMetallicWaste = 50;
totalNonMetallicWaste = 100;
totalWaste = totalMetallicWaste + totalNonMetallicWaste;

% Randomly place obstacles (represented by value 3) on the map.
numObstacles = 50;
obstacles_x = randi([1, gridSize], 1, numObstacles);
obstacles_y = randi([1, gridSize], 1, numObstacles);
for i = 1:numObstacles
    beachMap(obstacles_y(i), obstacles_x(i)) = 3;
end

% Randomly place metallic waste (value 1) on the map, avoiding obstacles.
for i = 1:totalMetallicWaste
    x = randi([1, gridSize]);
    y = randi([1, gridSize]);
    % Ensure the waste is not placed on an obstacle.
    while beachMap(y, x) ~= 0
        x = randi([1, gridSize]);
        y = randi([1, gridSize]);
    end
    beachMap(y, x) = 1;
end

% Randomly place non-metallic waste (value 2) on the map, also avoiding obstacles.
for i = 1:totalNonMetallicWaste
    x = randi([1, gridSize]);
    y = randi([1, gridSize]);
    while beachMap(y, x) ~= 0
        x = randi([1, gridSize]);
        y = randi([1, gridSize]);
    end
    beachMap(y, x) = 2;
end

%% Robot Initialization and Simulation Parameters
% Create an instance of the CrabRobot class. The class must be defined in 'CrabRobot.m'.
robot = CrabRobot(gridSize, gridSize);

% Define the number of steps for the simulation to run.
numSteps = 5000;

% Setup the main figure for the real-time simulation visualization.
fig = figure;
axis equal;
hold on;
title('Autonomous Beach Crab Simulation');

%% Simulation Loop
% This loop runs the simulation for the specified number of steps.
for step = 1:numSteps
    % The robot senses its environment to detect waste and obstacles.
    robot.senseEnvironment(beachMap);

    % Based on sensor readings, the robot decides how to navigate.
    robot.navigate();

    % The robot attempts to collect waste at its current position.
    [newMap, collected] = robot.collectWaste(beachMap);
    beachMap = newMap;
    
    % Refresh the visualization every 10 steps to improve performance.
    if mod(step, 10) == 0
        plotSimulation(fig, beachMap, robot);
    end

    % Exit the loop early if all waste has been collected.
    if (robot.metallicWasteCount + robot.nonMetallicWasteCount) >= totalWaste
        disp('All waste collected. Simulation finished.');
        break;
    end
end

hold off;

%% Results Analysis and Visualization
% Create a new figure to display the simulation results.
resultsFig = figure('Name', 'Simulation Results');

% Subplot for a bar graph showing the absolute count of waste collected by type.
subplot(1, 2, 1);
barData = [robot.metallicWasteCount, robot.nonMetallicWasteCount];
bar(barData, 'FaceColor', [0.2 0.7 0.9]);
set(gca, 'XTickLabel', {'Metallic', 'Non-Metallic'});
title('Waste Collected by Type');
ylabel('Number of Items');

% Subplot for a pie chart showing the percentage of each type of waste collected from the total collected.
subplot(1, 2, 2);
% Calculate the percentages for the pie chart.
if totalWaste > 0
    metallicPercentage = (robot.metallicWasteCount / totalWaste) * 100;
    nonMetallicPercentage = (robot.nonMetallicWasteCount / totalWaste) * 100;
    pieData = [metallicPercentage, nonMetallicPercentage];
    pie(pieData);
    legend({'Metallic', 'Non-Metallic'}, 'Location', 'best');
    title('Percentage of Total Waste Collected');
else
    title('No Waste to Collect');
end

% Print the final results to the MATLAB Command Window.
fprintf('\n--- Simulation Results ---\n');
fprintf('Metallic Waste Collected: %d of %d (%.2f%%)\n', ...
    robot.metallicWasteCount, totalMetallicWaste, (robot.metallicWasteCount / totalMetallicWaste) * 100);
fprintf('Non-Metallic Waste Collected: %d of %d (%.2f%%)\n', ...
    robot.nonMetallicWasteCount, totalNonMetallicWaste, (robot.nonMetallicWasteCount / totalNonMetallicWaste) * 100);
fprintf('Total Waste Collected: %d of %d (%.2f%%)\n', ...
    (robot.metallicWasteCount + robot.nonMetallicWasteCount), totalWaste, ((robot.metallicWasteCount + robot.nonMetallicWasteCount) / totalWaste) * 100);