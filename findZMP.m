function px = findZMP(w, dT, cpdesired, cpcurrent)
    b = exp(w*dT); 
    px = 1/(1-b)*cpdesired - b/(1-b)*cpcurrent; 
end