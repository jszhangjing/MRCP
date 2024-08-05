function feat = calculateFeatures(data)
    feat = [];

    d1 = diff(data, 1, 1);
    m0 = sum(data .^5);
    m1 = sum(nthroot(d1,3),1);  % живЊ
    feat = [feat, m0, m1];
end
