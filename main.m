clc; clear; close all;

addpath("src\.")

% Step 1: Setup the environment and agent
[env, agent, ~, ~] = env_setup();

% Step 2: Train the agent
disp('Starting training phase...');
trainingStats = trainAgent(env, agent);

% Step 3: Visualize dynamics
disp('Visualizing dynamics...');
dur = 3;
visualizeDynamics(env, agent, dur);
