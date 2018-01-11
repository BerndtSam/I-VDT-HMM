function ibdt( d , maxSaccadeDuration )

% Smooth pursuit consideration window size
windowSize = round( 1.5 * maxSaccadeDuration / (1000.0 / d.fps));

% Assume fixations and saccades velocities are normally distributed
fixationDist = 'Normal';
saccadeDist = 'Normal';

% Find minimal dispersion based on minimal values for each axis from the
% first 500 samples
dxMin = abs(diff(d.ox(1:500)));
dxMin(dxMin == 0) = [];
dxMin = min(dxMin);

dyMin = abs(diff(d.oy(1:500)));
dyMin(dyMin == 0) = [];
dyMin = min(dyMin);

minVal = dispersion( [ 0 dxMin ], [ 0 dyMin ] );

% Convert to speed based on the framerate ( pixels / ms )
minVal = double(minVal)/(1000/double(d.fps));

% Fixation distribution parameters
fmu = minVal;
fstd = 2*minVal/3;

% Saccade distribution parameters
vGmm = Gmm(d.v(1:500), 2);
smu = vGmm.mu(2);
sstd = vGmm.s(2);

% Initialize posteriors
fixationPosterior = zeros(1, length(d.v));
saccadePosterior = zeros(1, length(d.v));
pursuitPosterior = zeros(1, length(d.v));

% Initialize priors
fixationPrior = zeros(1, length(d.v));
saccadePrior = zeros(1, length(d.v));
pursuitPrior = zeros(1, length(d.v));

fixationLikelihood = zeros(1, length(d.v));
saccadeLikelihood = zeros(1, length(d.v));
pursuitLikelihood = zeros(1, length(d.v));


minVel = 0;
maxVel = vGmm.mu(2);

for i = 2 : length(d.v)

    if d.c.value(i) == noise
        continue
    end

    % window range
    we = i;
    ws = we - windowSize;
    if ws < 1
        ws = 1;
    end

    v = smooth(d, ws, we, minVel, maxVel, d.c.value(i-1)==pursuit);

    % Smooth pursuit likelihood and prior
    pursuitLikelihood(i) = sum(v > 0)/length(v);
    pursuitPrior(i) = mean(pursuitLikelihood(ws:we-1));

    % Remaining prior is divided equally between fixation and saccade
    fixationPrior(i) = (1 - pursuitPrior(i) ) / 2;
    saccadePrior(i) = fixationPrior(i);

    % Update fixation likelihood
    if d.v(i) < fmu
        fixationLikelihood(i) = pdf(fixationDist, fmu, fmu, fstd);
    else
        fixationLikelihood(i) = pdf(fixationDist, d.v(i), fmu, fstd);
    end

    % Update saccade likelihood
    if d.v(i) > smu
        saccadeLikelihood(i) = pdf(saccadeDist, smu, smu, sstd);
    else
        saccadeLikelihood(i) = pdf(saccadeDist, d.v(i), smu, sstd);
    end

    % Normalization factor
    evidence = ...
        fixationLikelihood(i)  * fixationPrior(i) ...
        + saccadeLikelihood(i) * saccadePrior(i) ...
        + pursuitLikelihood(i) * pursuitPrior(i);

    % Update the posteriors
    fixationPosterior(i) = fixationPrior(i) * fixationLikelihood(i) / evidence;
    saccadePosterior(i)  = saccadePrior(i)  * saccadeLikelihood(i)  / evidence;
    pursuitPosterior(i)  = pursuitPrior(i)  * pursuitLikelihood(i)  / evidence;

    % Get maximum posterior
    [ maxPosterior, maxPosteriorIdx ] = max([ fixationPosterior(i) saccadePosterior(i) pursuitPosterior(i) ]);

    % Now to the classification...
    % Fixation = 0, saccade = 1, pursuit = 2

    % Don't distinguish catch-up saccades
    d.c.set(i, maxPosteriorIdx-1);

    % Distinguish catch-up saccades
%     if d.v(i) > vGmm.mu(2)
%         d.c.set(i, saccade);
%     else
%         d.c.set(i, maxPosteriorIdx - 1);
%     end

end

% Quick visualtization ...
clf
subplot(5,1,1:4)
plot(d.v)
hold on
a = zeros(1, length(d.v));
a(:) = NaN;
a(d.reference.get(pursuit)) = -0.15;
plot(a, 'LineWidth', 5);
a(:) = NaN;
a(d.c.get(pursuit)) = -0.1;
plot(a, 'LineWidth', 5);
legend('speed', 'groundTruth(pur)', 'algorithm(pur)')
ylabel('speed')
xlabel('time')
axis( [ 0 length(d.v) -0.5 5 ] )
subplot(5,1,5)
plot(pursuitPosterior)
axis( [ 0 length(d.v) -0.05 1.05 ] )
ylabel('posterior(pur)')
xlabel('time')

end

