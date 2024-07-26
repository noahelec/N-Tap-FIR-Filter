% Define filter parameters
N = 4; % Number of taps
coeffs = [0.1, 0.2, 0.3, 0.4]; % Filter coefficients
input_sequence = [3, 1, 5, 15, 3, 1, 5, 15, 3, 1, 5, 15, 3, 1, 5, 15, 3, 1, 5, 15, 3, 1, 5, 15]; % Input sequence

% Initialize shift register
shift_register = zeros(1, N);

% Prepare to store outputs
outputs = zeros(1, length(input_sequence));

% Filtering process
for i = 1:length(input_sequence)
    % Shift the register
    shift_register = [input_sequence(i), shift_register(1:end-1)];
    
    % Calculate the output
    output = sum(shift_register .* coeffs);
    outputs(i) = output;
    
    % Display the process
    fprintf('Input: %d, Shift Register: [%s], Output: %d\n', input_sequence(i), num2str(shift_register), output);
end

% Plotting the results
figure;
subplot(2, 1, 1);
stem(input_sequence, 'filled');
title('Input Sequence');
xlabel('Sample');
ylabel('Value');
grid on;

subplot(2, 1, 2);
stem(outputs, 'filled');
title('Filtered Output Sequence');
xlabel('Sample');
ylabel('Value');
grid on;

