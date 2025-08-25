function corpuswav = concatenatewavs(wavdata)

    % initialize massive concatenated wav file
    corpuswav = wavdata{1};

    % concatenate into one big wav file
    for j=2:length(pathlist)
        corpuswav = [corpuswav; wavdata{j}];
    end
end