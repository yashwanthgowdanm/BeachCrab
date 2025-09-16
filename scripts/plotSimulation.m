% plotSimulation.m

function plotSimulation(fig, map, robot)
    figure(fig);
    cla;

    % Create a colormap for the environment
    % 0 = Sand (white)
    % 1 = Metallic Waste (blue)
    % 2 = Non-Metallic Waste (green)
    % 3 = Obstacle (red)
    beachColormap = [1, 1, 1; 0, 0, 1; 0, 1, 0; 1, 0, 0];
    colormap(beachColormap);

    % Display the map
    imagesc(map);
    axis equal;
    hold on;

    % Plot robot as a yellow circle with an arrow for heading
    plot(robot.x, robot.y, 'yo', 'MarkerFaceColor', 'y', 'MarkerSize', 10);
    plot([robot.x, robot.x + 5*cosd(robot.heading)], ...
         [robot.y, robot.y + 5*sind(robot.heading)], 'k-', 'LineWidth', 2);

    % Display collected waste counts
    text(10, -5, ['Metallic Waste: ' num2str(robot.metallicWasteCount)], 'Color', 'b', 'FontWeight', 'bold');
    text(10, -10, ['Non-Metallic Waste: ' num2str(robot.nonMetallicWasteCount)], 'Color', 'g', 'FontWeight', 'bold');

    title('Autonomous Beach Crab Simulation');
    set(gca, 'XTick', [], 'YTick', []); % Hide axis ticks
    drawnow;
end