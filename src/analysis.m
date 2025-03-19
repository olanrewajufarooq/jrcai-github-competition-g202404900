function analysis(trainingStats, testRewards)
    % ANALYSIS Computes performance metrics and performs statistical analysis.
    %
    %   analysis(trainingStats, testRewards)
    %
    % This function calculates mean and standard deviation for both training and testing rewards.
    % Additionally, it generates a histogram of the testing rewards.
    
    % Analysis of training rewards
    if isfield(trainingStats, 'EpisodeReward')
        trainingRewards = trainingStats.EpisodeReward;
        meanTrainingReward = mean(trainingRewards);
        stdTrainingReward = std(trainingRewards);
        fprintf('Training Rewards: Mean = %.2f, Std = %.2f\n', meanTrainingReward, stdTrainingReward);
    else
        disp('Training statistics do not contain ''EpisodeReward'' field.');
    end
    
    % Analysis of testing rewards
    meanTestReward = mean(testRewards);
    stdTestReward = std(testRewards);
    fprintf('Testing Rewards: Mean = %.2f, Std = %.2f\n', meanTestReward, stdTestReward);
    
    % Plot histogram of testing rewards
    figure;
    histogram(testRewards, 10);
    xlabel('Total Reward');
    ylabel('Frequency');
    title('Histogram of Testing Rewards');
    grid on;
end
