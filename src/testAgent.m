function testRewards = testAgent(env, agent, numTestEpisodes)
% TESTAGENT Evaluates the trained DQN agent.
%
%   testRewards = testAgent(env, agent, numTestEpisodes)
%
% This function evaluates the trained agent by simulating numTestEpisodes episodes.
% During testing, the agent's exploration is disabled by setting the epsilon value to 0.
% The function returns an array of total rewards for each episode.
%
% References:
%   - MATLAB. (2023). Reinforcement Learning Toolbox Documentation. The MathWorks, Inc.
%   - Sutton, R. S., & Barto, A. G. (2018). Reinforcement Learning: An Introduction (2nd ed.). MIT Press.

    if nargin < 3
        numTestEpisodes = 20;
    end
    
    % Backup the current epsilon value using the correct property path.
    originalEpsilon = agent.AgentOptions.EpsilonGreedyExploration.Epsilon;
    
    % Disable exploration by setting epsilon to 0.
    agent.AgentOptions.EpsilonGreedyExploration.Epsilon = 0;
    
    totalRewards = zeros(numTestEpisodes, 1);
    
    for i = 1:numTestEpisodes
        simOptions = rlSimulationOptions('MaxSteps', 500);
        experience = sim(env, agent, simOptions);
        totalRewards(i) = sum(experience.Reward);
        fprintf('Test Episode %d/%d - Reward: %.2f\n', i, numTestEpisodes, totalRewards(i));
    end
    
    % Restore the original epsilon value.
    agent.AgentOptions.EpsilonGreedyExploration.Epsilon = originalEpsilon;
    
    testRewards = totalRewards;
end
