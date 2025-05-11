function mask = genMask(img, percent, SamplingName)
    switch SamplingName
        case "Uniform"
            mask = genUnif(img, percent);
        case "Random"
            mask = genRand(img, percent);
        otherwise
            error("Wrong Sampling Method")
    end
end