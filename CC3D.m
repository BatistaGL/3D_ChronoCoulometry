% CC3D.m
%
% This algorithms processes converted data files from NOVA 1.10
% into a 3D chronocoulogram (Charge x time x potential).
% The experiment consists of successive double step chronocoulograms
% with increasing potential steps 
% (potential program comparable to normal pulse voltammetry).
%
% The implementation of the method in NOVA uses succesive
% fast Chronocoulograms, with change in current range
% during experiment to best accomodate double layer charging
% and increase measurement precision after potential.
%
% Once every current range change leads to a restart of
% the measured charge, the segments of each chronocoulogram
% need to be summed up to achieve a full double-step chronocoulogram.
% Time corrections are also applied when needed.
%
% This algorithm also implements chronocoulogram linearisation
% Further information can be found the thesis (INSERT LINK).
% The correction of integrator drift is not calculated here
% (It is expected during NOVA measurement).
%
% USAGE: [cc3d_raw cc3d_transf] = ConvCC3D(raw_data)
% being cc3d.raw    : 3d data w/o transformation
%       cc3d.transf : 3d data w/ time linearisation
%       raw_data    : the txt data exported from NOVA

function [cc3d_raw, cc3d_transf] = CC3D(raw_data)

% General Variable definitions:
	% t	Related to Time
	% E	Related to Potential
	% Q	Related to Charge
	% K	Constants for corrections/extrapolations
	% R	Cell Ranges

% Other recurrent descriptors associated to variables:
	% he	related to extrapolation for charge to infinity
	% le	related to extrapolaton for charge to zero

	DataSize = zeros(length(raw_data), 1);	% Size of data vectors

	E.start = -0.1;
	E.step = -0.025;


	Q.raw = DataSize;
	t.raw = DataSize;
	E.raw = DataSize;

	Q.correct = DataSize;	
	t.transf = DataSize;	

	t.thau = 0.107;		% Potential change timing
	t.cc = 0.01;		% Time interval between Chronocoulograms
	t.ch = 0.003;		% Time interval between Current Range/Potential Step changes

% Start Values
	t.raw(1) = 0;
	E.raw(1) = E.start;
	Q.raw(1) = raw_data(1, 2);

	for n = [2: length(raw_data)];
		if (raw_data(n, 1) - raw_data(n-1, 1) > t.cc)
			t.raw(n) 	= 0;
			E.raw(n)	= E.raw(n-1) + E.step;
			Q.raw(n)	= raw_data(n, 2);
		elseif (raw_data(n, 1) - raw_data(n-1, 1) > t.ch)
			t.raw(n)	= t.raw(n-1) + raw_data(n, 1) - raw_data(n-1, 1);
			E.raw(n)	= E.raw(n-1);
			Q.raw(n)	= raw_data(n, 2) + Q.raw(n-1);
		else
			t.raw(n)	= t.raw(n-1) + raw_data(n, 1) - raw_data(n-1, 1);
			E.raw(n)	= E.raw(n-1);
			Q.raw(n)	= raw_data(n, 2) - raw_data(n-1, 2) + Q.raw(n-1);
		end
	end

% Saving file without time transformation
	cc3d_raw	= [t.raw, E.raw, Q.raw];

% Time Transformation
	for n = [1: length(t.raw)]
		if (t.raw(n) < t.thau)
			% first step
			t.transf(n) = t.raw(n) ^ (1 / 2);
		else
			% second step
			t.transf(n) = 2 * t.thau^(1/2) + (t.raw(n) - t.thau)^(1/2) - t.raw(n)^(1/2);
		end
	end

% Value extrapolation

	for n = unique(E.raw)';

		% Extrapolation to infinity
		R.he = 	intersect(find(E.raw == n), ...	
			intersect(find(t.raw > max(t.raw) * 2 / 3), ...	
			find(t.raw < max(t.raw))));
		K.he = polyfit(t.transf(R.he), Q.raw(R.he), 1);	
		t.he = [max(t.transf(find(E.raw == n))) + .001: .005: 2 * sqrt(t.thau)]';
		Q.he = t.he * K.he(1) + K.he(2);
		E.he = ones(1, length(t.he))';

		% Extrapolation to zero
		R.le = 	intersect(find(E.raw == n), ...
			intersect(find(t.raw > t.thau), ...
			find(t.raw < t.thau + .01)));
		K.le = polyfit(t.transf(R.le), Q.raw(R.le), 1);
		t.le = [sqrt(t.thau): 0.005: 0.355]'; % (0.355 still arbitrary)
		Q.le = t.le * K.le(1) + K.le(2);
		E.le = ones(1, length(t.le))';

		% Data Matrix Composition
		t.transf = cat(1, t.transf, t.le, t.he);
		E.raw = cat(1, E.raw, E.le * n, E.he * n);
		Q.raw = cat(1, Q.raw, Q.le, Q.he);

		clear R t.he t.le Q.he Q.le E.he E.le;
	end

	cc3d_transf	= [t.transf, E.raw, Q.raw];
end
