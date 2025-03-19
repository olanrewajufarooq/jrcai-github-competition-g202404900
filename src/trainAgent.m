function trainingStats = trainAgent(env, agent)
    % TRAINAGENT Trains the DQN agent on the CartPole environment.
    %
    %   trainingStats = trainAgent(env, agent)
    %
    % This function sets the training options and invokes the train function.
    % The training process leverages experience replay and target network updates as
    % described in Mnih et al. (2015) and reinforced by Sutton and Barto (2018).
    
    trainOpts = rlTrainingOptions(...
        'MaxEpisodes', 200, ...
        'MaxStepsPerEpisode', 500, ...
        'ScoreAveragingWindowLength', 20, ...
        'Verbose', false, ...
        'Plots', 'training-progress', ...
        'StopTrainingCriteria', 'AverageReward', ...
        'StopTrainingValue', 500);

    % Agent Evaluator
    evl = rlEvaluator(EvaluationFrequency=20, NumEpisodes=5);
    
    % Train the agent on the environment
    trainingStats = train(agent, env, trainOpts);
end
