function [X_indizes, I_indizes, U_indizes, P_indizes, H_indizes] = getStageIndizes(stage)

N = length(stage.H_norm);
nx = stage.nx;
ni = stage.integrator.num_i;
nu = stage.nu;
np = stage.np;

% number of variables in one control interval
% + 1 for the timestep
nci = nx+ni+nu+np+1;

% Finds indizes of the variables in the NlpVars array.
% cellfun is similar to python list comprehension
% e.g. [range(start_i,start_i+nx) for start_i in range(1,nv,nci)]
X_indizes = cell2mat(arrayfun(@(start_i) (start_i:start_i+nx-1)', (0:N)*nci+1, 'UniformOutput', false));
I_indizes = cell2mat(arrayfun(@(start_i) (start_i:start_i+ni-1)', (0:N-1)*nci+nx+1, 'UniformOutput', false));
U_indizes = cell2mat(arrayfun(@(start_i) (start_i:start_i+nu-1)', (0:N-1)*nci+nx+ni+1, 'UniformOutput', false));

p_start = [(0:N-1)*nci+nx+ni+nu+1, (N)*nci+nx+1];
P_indizes = cell2mat(arrayfun(@(start_i) (start_i:start_i+np-1)', p_start, 'UniformOutput', false));
H_indizes = cell2mat(arrayfun(@(start_i) (start_i:start_i)', (0:N-1)*nci+nx+ni+nu+np+1, 'UniformOutput', false));