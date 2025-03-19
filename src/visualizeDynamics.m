function visualizeDynamics(env, agent, simDuration)
    % VISUALIZEDYNAMICS Animates the CartPole dynamics with a timer.
    %
    %   visualizeDynamics(env, agent, simDuration)
    %
    % This function simulates one episode using the trained agent and animates the
    % CartPole dynamics. The total duration of the animation is exactly simDuration
    % seconds. A timer is displayed at the top of the figure showing the elapsed time.
    %
    % The observation is assumed to be a struct with a timeseries field "CartPoleStates"
    % containing the full state information in the format [4 x 1 x N].
    
    % Simulate one episode with a maximum of 500 steps.
    simOptions = rlSimulationOptions('MaxSteps', 500, 'StopOnError', 'on');
    experience = sim(env, agent, simOptions);
    
    % Extract state trajectories from the observation.
    % The observation is assumed to be a struct with a timeseries field "CartPoleStates".
    ts = experience.Observation.CartPoleStates;
    % Remove singleton dimensions. Expected Data size: [4 x 1 x N]
    data = squeeze(ts.Data);
    % After squeeze, data should be [4 x N]. Transpose to get [N x 4]
    states = data';
    
    % Verify that the state matrix has the expected dimensions.
    if size(states, 2) < 4
        disp('Dynamics visualization requires full state information.');
        return;
    end
    
    % Determine sample time and create a time vector so that the total animation
    % lasts exactly simDuration seconds.
    sampleTime = env.Ts;
    timeVec = 0:sampleTime:simDuration;
    numSteps = length(timeVec);
    
    % Set up the figure for animation.
    figure;
    axis([-2.5 2.5 -0.5 2.5]);
    hold on;
    xlabel('Cart Position');
    ylabel('Height');
    title('CartPole Dynamics Visualization');
    
    % Animate the dynamics over the time vector.
    for t = 1:numSteps
        cla;  % Clear the current axes
        
        % Use the current time from the time vector.
        elapsedTime = timeVec(t);
        % Display the elapsed time at the top of the figure.
        text(0, 2.3, sprintf('Time: %.2f s', elapsedTime), ...
             'HorizontalAlignment', 'center', 'FontSize', 12);
        
        % Determine the corresponding simulation frame.
        % If there are fewer simulation frames than time steps, use the last frame.
        frameIndex = min(t, size(states, 1));
        
        % Extract state variables (assumes state = [cart position, cart velocity, pole angle, pole angular velocity])
        cartPos = states(frameIndex, 1);
        poleAngle = states(frameIndex, 3);
        
        % Define dimensions for visualization.
        cartWidth = 0.4;
        cartHeight = 0.2;
        poleLength = 1.0;
        
        % Draw the cart as a rectangle.
        cartX = cartPos - cartWidth/2;
        cartY = 0;
        rectangle('Position', [cartX, cartY, cartWidth, cartHeight], 'FaceColor', [0 0.5 0.5]);
        
        % Compute the endpoint of the pole using trigonometry.
        poleX = cartPos + poleLength * sin(poleAngle);
        poleY = cartY + cartHeight + poleLength * cos(poleAngle);
        line([cartPos, poleX], [cartY + cartHeight, poleY], 'LineWidth', 2, 'Color', 'r');
        
        % Draw the ground line for reference.
        line([-3, 3], [0, 0], 'Color', 'k', 'LineStyle', '--');
        
        drawnow;  % Update the figure.
        pause(sampleTime);  % Pause for the sample time.
    end
end
