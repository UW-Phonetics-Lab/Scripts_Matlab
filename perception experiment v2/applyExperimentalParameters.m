% create a full list of trials from a stimulus list and a set of experimental parameters
function [fullStimList] = applyExperimentalParameters(repetitions,lrScheme,randScheme,stimList)

    % tempStimList includes the repetitions and L/R scheme of the stimuli.
    % Column 1 is stimulus ID number, column 2 is a code for the L/R
    % presentation of the stimulus:
    % -1 = user specified that the stims are stereo
    %  0 = play mono sound to both ears
    %  1 = play mono sound to left ear
    %  2 = play mono sound to right ear
    %
    % fullStimList is a permutation of tempStimList, whose order depends on
    % the randomization scheme selected. Ultimately tempStimList and
    % fullStimList will have other columns (for forced-choice responses or
    % images/text that goes along with the audio stim)

    
    % this sequentially numbers stimuli, and repeats that sequential
    % list of numbers for as many times as specified in the
    % "repetitions" variable
    blocksize = length(stimList);
    stimNums = permute(1:length(stimList),[2 1]);
    tempStimList = repmat(stimNums,repetitions,1);

    switch lrScheme
        case 'mono'
        % left and right channels identical
            tempStimList(:,2) = 0;

        case 'random'
        % left and right channels randomly assigned
            a = round(1 + rand([length(tempStimList),1]));
            tempStimList(:,2) = a;
            % this gives a random assortment of ones and twos, which
            % will be interpreted as left and right

        case 'balanced'
        % half of stimuli to each side
            a = ones([length(tempStimList),1]);
            a(1:floor(length(tempStimList)/2)) = 2;
            b = a(randperm(length(a)));
            tempStimList(:,2) = b;
            % this gives a random ordering of ones and twos, with equal
            % numbers of each.  If there are an odd number of distinct
            % stimuli and an odd number of repetitions, then there will
            % be an odd number of trials and hence one more stim going
            % to the left ear than the number going to the right ear

        case 'mirrored'
        % each stimulus to right & left sides an equal number of times
        % (requires an even number of "repetitions")
            a = zeros([length(tempStimList),1]);
            b = ones(repetitions,1);
            b(1:floor(repetitions/2)) = 2;
            % the "floor" part is not strictly necessary since 
            % 'repetitions' is restricted to an even number when the 
            % l/r scheme = 'mirrored'. It is left in for cases where
            % someone erroneously edited the parameter file by hand.
            
            for k = 1:blocksize
                c = b(randperm(repetitions));
                for j = 1:repetitions
                    a(k+(j-1)*blocksize) = c(j);
                end
            end
            % the above loop iterates through the stimulus ID numbers (k)
            % and randomly assigns an equal number of ones and twos to each
            % instance of that stimulus across all blocks (j).  Thus,
            % each stimulus (k) will play an equal number of times to
            % the left and right ear, but the L/R assignment for any
            % given trial block is not necessarily balanced (i.e., it
            % is possible (though unlikely) that a two block trial
            % could end up with all the first block stims playing left,
            % and all the second block stims playing right).  If you
            % want a 'mirrored' setup but with a balanced number of
            % L/R stimuli in each block, then run each block as a
            % separate experiment with only 2 repetitions and a 'block'
            % type randomization scheme.
            tempStimList(:,2) = a;

        otherwise
        % the user says the stimuli are stereo (2-channel) WAV files
            tempStimList(:,2) = -1;
    end

    switch randScheme
        case 'full'
            % this randomizes all trials/repetitions at once.
            fullStimList = tempStimList(randperm(length(tempStimList)),:);
        case 'block'
            % this randomizes each block of stims separately, and plays
            % the blocks sequentially
            f = zeros(length(tempStimList),1);
            for r = 0:repetitions-1
                a = 1+(r*blocksize);
                b = (1+r)*blocksize;
                c = a:b;
                d = randperm(blocksize);
                f(a:b) = c(d);
            end
            fullStimList = tempStimList(f,:);
        otherwise
            % do nothing. no randomization was requested, so we play
            % the stims in the order presented (with repetitions at the
            % block level)
            fullStimList = tempStimList;
    end