clc; clear; close all;

% Add source folder
addpath("src\")

% ================================
% Boolean to control retraining
% ================================
doTraining = false;  % Set to true if you want to retrain

% Define path for saving/loading
if ~exist("data","dir")
    mkdir("data");
end
dataFile = fullfile("data", "trainedAgent.mat");

if doTraining
    % If doTraining is true, we always retrain (ignoring any existing file)

    % Step 1: Setup the environment and agent
    [env, agent, ~, ~] = env_setup();

    % Step 2: Train the agent
    disp("Starting training phase...");
    trainingStats = trainAgent(env, agent);

    % Save environment and agent
    savedEnv = env; 
    savedAgent = agent;
    save(dataFile, "savedEnv", "savedAgent");
    disp("Training completed. The agent and environment have been saved.");

else
    % If doTraining is false, check if a saved file exists
    if exist(dataFile, "file")
        % Load previously saved environment and agent
        loadedData = load(dataFile, "savedEnv", "savedAgent");
        env = loadedData.savedEnv;
        agent = loadedData.savedAgent;
        disp("Loaded the trained agent and environment from data/trainedAgent.mat.");
    else
        % No saved data found, so proceed to train
        warning("No saved data found! Proceeding to train the agent...");
        [env, agent, ~, ~] = env_setup();

        disp("Starting training phase...");
        trainingStats = trainAgent(env, agent);

        savedEnv = env; 
        savedAgent = agent;
        save(dataFile, "savedEnv", "savedAgent");
        disp("Training completed. The agent and environment have been saved.");
    end
end

if doTraining
    % Step 3: Test the agent
    disp('Starting testing phase...');
    testRewards = testAgent(env, agent, 20);

    % Step 4: Plot results
    disp('Generating plots...');
    plotResults(trainingStats, testRewards);

    % Step 5: Analysis
    disp('Performing analysis...');
    analysis(trainingStats, testRewards);
end

% Step 6: Visualize dynamics
disp("Visualizing dynamics...");
dur = 3;
visualizeDynamics(env, agent, dur);
