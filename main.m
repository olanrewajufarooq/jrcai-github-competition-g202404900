clc; clear; close all;

addpath("src\.")

 % Step 1: Setup the environment and agent
 [env, agent, ~, ~] = env_setup();

 % Step 2: Visualize dynamics
disp('Visualizing dynamics...');
dur = 10;
visualizeDynamics(env, agent, dur);
