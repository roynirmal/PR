[trn, tst, b1, c1] = gendat(A, 0.05);
w1 = svc(trn);
testc(tst, w1);
w2 = qdc(trn);
testc(tst,w2);
w3 = parzenc(trn);
testc(tst, w3);
w4 = bpxnc(trn, [10 10 10]);
testc(tst,w4);
w5 = loglc(trn);
testc(tst, w5)

B=im_threshold(A,'otsu')
[trn, tst, b1, c1] = gendat(B, 0.05);
w1 = svc(trn);
testc(tst, w1);
w2 = qdc(trn);
testc(tst,w2);
w3 = parzenc(trn);
testc(tst, w3);
w4 = bpxnc(trn, [10 10 10]);
testc(tst,w4);
w5 = loglc(trn);
testc(tst, w5)
