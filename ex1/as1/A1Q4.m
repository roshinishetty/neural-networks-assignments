clc;
clear;
close all;

data = xlsread('data.xlsx');
X = [ones(size(data,1),1) data(:,1:2)];
Y = data(:,3);

W = pinv( X' * X) * X' * Y;
fprintf("Using vectorised regression:");
W
%pause;

regCof = 0.02;
W = pinv( (X' * X) + (regCof * eye(3)) ) * X' * Y;
fprintf("Using norm-2:");
W
%pause;

W = pinv( X' * X ) * (X' * Y - regCof * 1/2 * signum(W));
fprintf("Using norm-1:");
W
%exit(0);