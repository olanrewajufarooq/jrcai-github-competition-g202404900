function plotResults(trainingStats, testRewards)
    % PLOTRESULTS Plots training and testing performance metrics.
    %
    %   plotResults(trainingStats, testRewards)
    %
    % This function generates two figures:
    %   1. Training progress (episode rewards over time)
    %   2. Testing performance (total rewards per test episode)
    
    % Plot training rewards
    figure;
    if isfield(trainingStats, 'EpisodeReward')
        plot(trainingStats.EpisodeReward, 'LineWidth', 1.5);
        xlabel('Episode');
        ylabel('Episode Reward');
        title('Training Progress');
        grid on;
    else
        disp('Training statistics do not contain ''EpisodeReward'' field.');
    end
    
    % Plot testing rewards
    figure;
    plot(testRewards, 'o-', 'LineWidth', 1.5);
    xlabel('Test Episode');
    ylabel('Total Reward');
    title('Testing Performance');
    grid on;
end
