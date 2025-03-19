function visualizeDynamics(env, agent, simDuration)
% VISUALIZEDYNAMICS Animates the CartPole dynamics along with agent actions.
%
%   visualizeDynamics(env, agent, simDuration)
%
% This function simulates one episode using the trained agent and animates the
% CartPole dynamics for exactly simDuration seconds. Both the state evolution
% and the applied actions are displayed.
%
% The observation is assumed to be a struct with a timeseries field "CartPoleStates"
% containing the full state information in the format [4 x 1 x N], and the actions
% are stored as a timeseries under the field "CartPoleAction".
%
% References:
%   - MATLAB. (2023). Reinforcement Learning Toolbox Documentation. The MathWorks, Inc.
%   - Sutton, R. S., & Barto, A. G. (2018). Reinforcement Learning: An Introduction (2nd ed.).
%     MIT Press.

    % Determine sample time and create a time vector.
    sampleTime = env.Ts;
    timeVec = 0:sampleTime:simDuration;
    numSteps = length(timeVec);
    
    % Simulate one episode with a maximum number of steps equal to numSteps.
    simOptions = rlSimulationOptions('MaxSteps', numSteps, 'StopOnError', 'on');
    experience = sim(env, agent, simOptions);
    
    % Extract state trajectories from the observation.
    ts = experience.Observation.CartPoleStates;
    data = squeeze(ts.Data); % Expected size: [4 x N]
    states = data';          % Transpose to [N x 4]
    
    % Extract action data from the simulation.
    actions = squeeze(experience.Action.CartPoleAction.Data)'; % Transpose to [N x 1]
    
    % Verify that the state matrix has full state information.
    if size(states, 2) < 4
        disp('Dynamics visualization requires full state information.');
        return;
    end

    % (Optional) Print out the total number of states and actions.
    % fprintf('Total States: %d. Total Actions: %d\n', size(states, 1), length(actions));
    
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
        
        % Map time index to simulation frame indices.
        stateIndex = min(t, size(states, 1));
        actionIndex = min(t, numel(actions));
        
        % Extract state variables.
        cartPos = states(stateIndex, 1);
        poleAngle = states(stateIndex, 3);
        action = actions(actionIndex);
        
        % Define visualization dimensions.
        cartWidth = 0.4;
        cartHeight = 0.2;
        poleLength = 1.0;
        
        % Draw the cart.
        cartX = cartPos - cartWidth/2;
        cartY = 0;
        rectangle('Position', [cartX, cartY, cartWidth, cartHeight], 'FaceColor', [0 0.5 0.5]);
        
        % Compute and draw the pole.
        poleX = cartPos + poleLength * sin(poleAngle);
        poleY = cartY + cartHeight + poleLength * cos(poleAngle);
        line([cartPos, poleX], [cartY + cartHeight, poleY], 'LineWidth', 2, 'Color', 'r');
        
        % Draw a ground reference line.
        line([-3, 3], [0, 0], 'Color', 'k', 'LineStyle', '--');
        
        % Display the action applied at this frame.
        if action < 0
            actionText = '← Left';
        elseif action > 0
            actionText = '→ Right';
        else
            actionText = '⏹ No Force';
        end
        text(cartPos, cartY - 0.2, sprintf('Action: %s', actionText), ...
             'HorizontalAlignment', 'center', 'FontSize', 10, 'Color', 'b');
        
        drawnow;           % Update the figure.
        pause(sampleTime); % Pause for one sample time.
    end
end
