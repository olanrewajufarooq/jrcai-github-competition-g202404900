function [env, agent, qRepresentation, agentOpts] = setup()
    % SETUP Initializes the CartPole environment and configures the DQN agent.
    %
    %   [env, agent, qRepresentation, agentOpts] = setup()
    %
    % This function creates a predefined CartPole environment and sets up a DQN agent
    % with a neural network backbone. The network is designed with two hidden layers
    % and ReLU activations to approximate the Q-function, following the guidelines of
    % Mnih et al. (2015) and Sutton and Barto (2018).
    
    % Create the CartPole environment (discrete version)
    env = rlPredefinedEnv('CartPole-Discrete');

    % Extract observation and action information
    obsInfo = getObservationInfo(env);
    actInfo = getActionInfo(env);
    numObservations = obsInfo.Dimension(1);
    numActions = numel(actInfo.Elements);

    % Define the neural network architecture (backbone)
    layers = [
        featureInputLayer(numObservations, 'Normalization', 'none', 'Name', 'state')
        fullyConnectedLayer(128, 'Name', 'fc1')
        reluLayer('Name', 'relu1')
        fullyConnectedLayer(128, 'Name', 'fc2')
        reluLayer('Name', 'relu2')
        fullyConnectedLayer(numActions, 'Name', 'fc3')];

    % Create a layer graph from the layers
    lgraph = layerGraph(layers);

    % Create Q-value representation (automatically handles data processing)
    qRepresentation = rlQValueRepresentation(lgraph, obsInfo, actInfo, ...
                'Observation', {'state'}, 'Action', {'fc3'});

    % Configure agent options excluding the epsilon parameters from the constructor
    agentOpts = rlDQNAgentOptions(...
        'SampleTime', env.Ts, ...
        'TargetUpdateFrequency', 4, ...          % Update target network every 4 steps
        'ExperienceBufferLength', 1e4, ...         % Replay buffer capacity
        'MiniBatchSize', 64, ...                   % Mini-batch size for training
        'DiscountFactor', 0.99);                   % Discount factor (gamma)

    % Set epsilon-greedy exploration parameters via the EpsilonGreedyExploration property
    agentOpts.EpsilonGreedyExploration.Epsilon = 1.0;      % Initial exploration rate
    agentOpts.EpsilonGreedyExploration.EpsilonMin = 0.01;    % Minimum exploration rate
    agentOpts.EpsilonGreedyExploration.EpsilonDecay = 0.995; % Decay factor per episode

    % Create the DQN agent using the Q-value representation and options
    agent = rlDQNAgent(qRepresentation, agentOpts);
end
