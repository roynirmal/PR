function feat_select = featureSelect(Hog, Projection, ChainCode)

feat_select=[];

if(Hog)
    feat_select = [feat_select feat_hog];
end

if(Projection)
    feat_select = [feat_select feat_proj];
end

if(ChainCode)
    feat_select = [feat_select feat_chaincode];
end
