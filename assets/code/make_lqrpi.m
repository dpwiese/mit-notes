%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% makeLQRPI.m
% Flight Control Tools: Make LQR-PI Controller
% Written by: Daniel Wiese, Wednesday 15-October-2014
% Updated by: Daniel Wiese, Sunday 18-October-2015
%-----------------------------------------------------------------------------------
%
% This script makes an LQR-PI controller given a system A and B matrices, and Q and
% R weights. Additionally the user must specify which (up to two) state variables
% should be augmented with an integral error state. Specify which state variable(s)
% are to be integrated using a scalar parameter corresponding to the ith state
% variable. If only one integrator is to be used, specify only the first 'e', and it
% doesn't matter what the second 'e' is. Pass the weighting matrices Q and R to the
% function as vectors, which will act as the diagonal entries of the weights.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Kx, P, A, Am, B, Bcmd, C, D, n] = makeLQRPI(Ap, Bp, Cp, Cpz, Dpz, Qlqr, Rlqr)

    % Find number of states and inputs of \dot{x} = Ax + Bu
    [np, m] = size(Bp);
    [l, ~] = size(Cp);
    [ne, ~] = size(Cpz);

    % The total size of the augmented system will be original size plus error
    n = np + ne;
    p = l + ne;

    if rank(ctrb(Ap,Bp)) ~= np
        error('The plant is not controllable!')
    end

    if rank([Ap, Bp; Cpz, Dpz]) ~= n
        error('Selection of regulated output destroys controllability!')
    end

    % Augment the system with the integral error state
    A = [Ap, zeros(np,ne); -Cpz, zeros(ne,ne)];
    B = [Bp; -Dpz];
    Bcmd = [zeros(np,ne); eye(ne,ne)];
    C = [Cp, zeros(l,ne); zeros(ne,np), eye(ne,ne)];
    D = zeros(p,m);

    % Solve for the LKQ feedback gain
    [Kx, P, ~] = lqr(A, B, diag(Qlqr,0), diag(Rlqr,0));
    Kx = -Kx';
    Am = (A + B*Kx');

end
