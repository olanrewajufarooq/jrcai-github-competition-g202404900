function visualizeDynamics(env, agent, simDuration)
    % VISUALIZEDYNAMICS Animates the CartPole dynamics along with agent actions.
    %
    %   visualizeDynamics(env, agent, simDuration)
    %
    % This function simulates one episode using the trained agent and animates the
    % CartPole dynamics. The total duration of the animation is exactly simDuration
    % seconds, and the applied actions are displayed.
    %
    % The observation is assumed to be a struct with a timeseries field "CartPoleStates"
    % containing the full state information in the format [4 x 1 x N].
    
    % Determine sample time and create a time vector so that the total animation
    % lasts exactly simDuration seconds.
    sampleTime = env.Ts;
    timeVec = 0:sampleTime:simDuration;
    numSteps = length(timeVec);
    
    % Simulate one episode with a maximum of numSteps.
    simOptions = rlSimulationOptions('MaxSteps', numSteps, 'StopOnError', 'on');
    experience = sim(env, agent, simOptions);
    
    % Extract state trajectories from the observation.
    ts = experience.Observation.CartPoleStates;
    data = squeeze(ts.Data); % Expected size: [4 x N]
    states = data';          % Transpose to [N x 4]
    
    % Extract action data from the simulation.
    % The action is assumed to be stored as a timeseries under the field "CartPoleAction".
    actions = squeeze(experience.Action.CartPoleAction.Data)'; % [N x 1]
    
    % Verify that the state matrix has the expected dimensions.
    if size(states, 2) < 4
        disp('Dynamics visualization requires full state information.');
        return;
    end
    
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
        text(0, 2.3, sprintf('Time: %.2f s', elapsedTime), ...
             'HorizontalAlignment', 'center', 'FontSize', 12);
        
        % Use separate indices for state and action.
        stateIndex = min(t, size(states, 1));
        actionIndex = min(t, numel(actions));  % Use the last available action if t exceeds number of actions
        
        % Extract state variables.
        cartPos = states(stateIndex, 1);
        poleAngle = states(stateIndex, 3);
        action = actions(actionIndex);
        
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
        
        % Display action as a force direction.
        if action == -1
            actionText = '← Left';
        elseif action == 1
            actionText = '→ Right';
        else
            actionText = '⏹ No Force';
        end
        text(cartPos, cartY - 0.2, sprintf('Action: %s', actionText), ...
             'HorizontalAlignment', 'center', 'FontSize', 10, 'Color', 'b');
        
        drawnow;  % Update the figure.
        pause(sampleTime);  % Pause for the sample time.
    end
end
